# -*- coding: utf-8 -*-
"""
Display upcoming Google Calendar events in your i3 status bar.

Uses colours to inform you how close an event is to starting. Properly decline
events to make them not show up. All day events are never shown.

go/i3cal

Author: Jeroen van Wolffelaar (jvw@)

$Id: //depot/google3/experimental/jvw/google_cal_py3status/google_cal_py3status.py#8 $

"""

import httplib2
import contextlib
import os
import datetime
import random
import traceback
import re

import googleapiclient.discovery
import oauth2client.client
import oauth2client.tools
import oauth2client.file

import dateutil.parser
from dateutil.tz import tzutc

SCOPES = ['https://www.googleapis.com/auth/calendar.readonly']

"""
UX:

  [I/N] HH:MM t-NN <event title> TODO: @ loc [w/ others]
  cycle through the meetings that start in the next hour, or just show the next
  one if there are none.

  scroll: prev/next event, after 15s idle it reverts to cycling

  colour:

  white:     inf .. -60
  green:     -60 .. -10
  yellow:    -10 ..  -5
  orange:     -5 ..  -3
  red:        -3 ..  -1
  red blink:  -1 ..  +5
  blue blink: +5 .. end

  TODO: left click: -> to event
  TODO: (configurable?) fixed width
  TODO: make error status better, show actual text/error or something
  TODO: http://g3doc/company/teams/sso/howto/oauth_from_loas (via rbn@)

"""

# Note: touch the file to make this script log, it will not create it. Unlink or
# move the logfile to stop logging
LOGFILE = '/tmp/google_cal_py3status.log'
# If it exists, will be continuously filled with the latest API response
EVENTSFILE = '/tmp/google_cal_py3status.events'

# Granularity with which to display hour countdowns, in minutes:
HOUR_DISPLAY_GRANULARITY = 30  # i.e. half-hour granularity

def debug(s):
  if not os.path.exists(LOGFILE):
    return
  with open(LOGFILE, 'a') as fd:
    fd.write(datetime.datetime.now().isoformat() + ' ' +s+'\n')

class EventGetter:

  # State, public:
  status = 'init' # or: 'ok', 'login-required', 'login', 'error'
  # State, private:
  service = None
  next_update = None
  num_failures = 0
  cmds = []

  # Constants
  _update_frequency_minmax = 60, 90
  _retry_minmax = 5, 15*60
  _retry_exp = 1.5

  # Settings:

  # Not displaying dates, so must be well below 24h to avoid confusion
  events_within_hours = 12
  token_fn = os.path.expanduser('~/.config/calendar-status/token.json')
  credentials_fn = os.path.expanduser('~/.config/calendar-status/credentials.json')

  def enqueue_command(self, cmd):
    self.cmds.append(cmd)

  def step(self):
    if 'login' in self.cmds:
      if self.status == 'login':
        self.cmds.remove('login')
        self.login()
        self.update(force=True)
      else:
        # First set status, have display updated, and then in next iteration run
        self.status = 'login'
        return
    elif 'force-update' in self.cmds:
      self.cmds.remove('force-update')
      self.update(force=True)
    else:
      self.update()

  def update(self, force=False):
    """Returns whether updated."""
    now = datetime.datetime.utcnow()

    if not force and self.next_update and now < self.next_update:
      return False

    try:
      self.status = self._do_update()
    except:
      self.status = 'error'

      self.num_failures += 1
      self.next_update = now + datetime.timedelta(seconds=min(
          int(self._retry_minmax[0] * self._retry_exp ** self.num_failures),
          self._retry_minmax[1]))
      raise
    else:
      self.num_failures = 0
      self.next_update = now + datetime.timedelta(
          seconds=random.randint(*self._update_frequency_minmax))


  def login(self):
    return self._do_setup(interactive=True)

  def _do_setup(self, interactive=False):
    if self.service:
      return

    store = oauth2client.file.Storage(self.token_fn)
    creds = store.get()
    if not creds or creds.invalid:
      if interactive:
        flow = oauth2client.client.flow_from_clientsecrets(self.credentials_fn, SCOPES)

        @contextlib.contextmanager
        def lowlevel_stdout_wrapper():
          backup_stdout = os.dup(1)
          os.dup2(2, 1)
          try:
            yield
          finally:
            os.dup2(backup_stdout, 1)
            os.close(backup_stdout)

        # It uses print(), the spawned browser hard writes to stdout, and if
        # there's an error it calls sys.exit (!). Not cool. At least make the
        # no-error situation pass without incident...
        with lowlevel_stdout_wrapper():
          creds = oauth2client.tools.run_flow(
              flow, store, flags=oauth2client.tools.argparser.parse_args([]))

      else:
        return 'login-required'

    self.service = googleapiclient.discovery.build('calendar', 'v3', http=creds.authorize(httplib2.Http()))

  def _do_update(self):
    newstatus = self._do_setup()
    if newstatus:
      return newstatus

    time_min = datetime.datetime.utcnow()
    time_max = time_min + datetime.timedelta(hours=self.events_within_hours)

    try:
      debug('Querying...')
      eventsResult = self.service.events().list(
          calendarId='primary',
          timeMax=time_max.isoformat() + 'Z',  # 'Z' indicates UTC time
          timeMin=time_min.isoformat() + 'Z',  # 'Z' indicates UTC time
          singleEvents=True,
          orderBy='startTime').execute()
    except:
      self.service = None
      raise

    if os.path.exists(EVENTSFILE):
      with open(EVENTSFILE, 'w') as fd:
        import pprint
        pprint.pprint(eventsResult, stream=fd)

    self.events = eventsResult['items']
    debug('Success, %d items' % len(self.events))

    return 'ok'

class Py3status:
  # State:
  # - in error condition:
  #   - invalid-creds/error: show error
  #   - need login: show invitation to login
  #   - in process of login: show that
  # - or... ok
  #   - default mode: auto-scroll
  #     - countdown till next item
  #   - manual scroll
  #     - countdown till reset

  events = None
  displayedEvent = None
  mutedEventIds = set()
  cur = 999
  next_scroll = -1 # how many ticks until the next item

  exclude_events_regex = None

  def get_status(self):
    try:
      return self._update()
    except:
      debug(traceback.format_exc())
      raise

  def _update(self):
    self.displayedEvent = None

    if not self.events:
      self.events = EventGetter()

    self.events.step()

    if self.events.status != 'ok':
      return dict(
          full_text='Status: %s' % self.events.status,
          color = '#ff0000',
          cached_until=self.py3.time_in(seconds=0),
      )

    now = datetime.datetime.now(tz=tzutc())
    eventlist = []
    for event in self.events.events:
      if 'dateTime' not in event['start']:
        # All day event, not in scope for the statusbar
        continue

      if self.exclude_events_regex and re.match(self.exclude_events_regex,
                                                event['summary']):
        continue

      self_declined = False
      for attendee in event.get('attendees', []):
        if attendee.get('self') and attendee.get('responseStatus') == 'declined':
          self_declined = True

      if self_declined:
        continue

      start = dateutil.parser.parse(event['start']['dateTime'])
      tts = (start - now).total_seconds()

      eventlist.append(dict(
          id=event['id'],
          tts=tts,
          start=start,
          event=event))

    # Snap to existing event
    if not eventlist:
      return dict(
          full_text='* no events in next 12h *',
          color='#ffffff',
          cached_until=self.py3.time_in(seconds=5),
      )
    if self.cur < 0:
      self.cur = 0
    if self.cur >= len(eventlist):
      self.cur = len(eventlist)-1

    # Scroll if needed. Note, now wrapping, not snapping.
    self.next_scroll -= 1
    if self.next_scroll <= 0:
      self.cur += 1
      if self.cur >= len(eventlist):
        self.cur = 0

      # We want to only cycle through the events in the next hour. So if we now
      # scrolled to one further in the future, wrap back to start. Note that if
      # no event is in the next hour, we this will cause us to just display the
      # very first event.
      if eventlist[self.cur]['tts'] > 60*60:
        self.cur = 0

      # Even number of ticks helps with smooth blinking
      self.next_scroll = 6

    event = eventlist[self.cur]
    tts = event['tts']

    if tts > 60*60:
      # Calculate properly-rounded countdown
      tts_round = (HOUR_DISPLAY_GRANULARITY *
                   round(float(tts//60)/HOUR_DISPLAY_GRANULARITY))/60
      # Prettify format: if a round number of hours, print 'Nh' instead of
      # 'N.0h'. Otherwise print one decimal place.
      tts_fmt_str = 'T-%.1fh' if int(tts_round) != tts_round else 'T-%dh'
      ttstxt = tts_fmt_str % tts_round
    elif tts > 0:
      ttstxt = 'T-%dm' % (tts//60)
    else:
      ttstxt = 'T+%dm' % ((-tts)//60)
    ttstxt = '(%s)' % ttstxt
    while len(ttstxt) < len('(T+00m)'):
      ttstxt += ' '

    txt = '[%d/%d] %02d:%02d %s %-30s' % (
        self.cur+1, len(eventlist), event['start'].hour, event['start'].minute,
        ttstxt, event['event']['summary'])

    tts = event['tts']
    bg = '#000000'
    if tts > 60*60:
      fg = '#ffffff' # white
    elif tts > 10*60:
      fg = '#00ff00' # green
    elif tts >  5*60:
      fg = '#ffff00' # yellow
    elif tts >  3*60:
      fg = '#ffa500' # orange
    elif tts > -1*60:
      fg = '#ff0000' # red
      bg = '#ffffff'
    else:
      fg = '#00ffff' # blue

    emphasis = tts <= 10*60
    blink = tts <= 1*60

    if emphasis:
      muted = event['id'] in self.mutedEventIds
      event['muted'] = muted  # presence signals mutability
      if muted:
        emphasis = blink = False

    if emphasis:
      bg, fg = fg, bg

    if blink and self.next_scroll % 2:
      bg, fg = fg, bg

    self.displayedEvent = event
    return dict(
        full_text=txt,
        color=fg,
        background=bg,
        cached_until=self.py3.time_in(seconds=0),
    )

  _BUTTON_DICT = dict(enumerate(['pri', 'mid', 'sec', 'up', 'down']))

  def on_click(self, event):
    try:
      self._on_click(event)
    except:
      debug(traceback.format_exc())
      raise

  def _on_click(self, event):
    debug('on_click: %r' % repr(event))

    button = self._BUTTON_DICT.get(event['button']-1, 'unknown')
    if button == 'pri':
      if self.events.status == 'ok':
        pass
      elif self.events.status == 'login-required':
        self.events.enqueue_command('login')
    elif button == 'sec':
      self.events.enqueue_command('force-update')
    elif button == 'mid':
      if self.displayedEvent and 'muted' in self.displayedEvent:
        if self.displayedEvent['muted']:
          self.mutedEventIds.discard(self.displayedEvent['id'])
        else:
          self.mutedEventIds.add(self.displayedEvent['id'])
          # 'memory leak', but ¯\_(ツ)_/¯
      self.next_scroll = 11
    elif button == 'up':
      self.cur -= 1
      self.next_scroll = 11
    elif button == 'down':
      self.cur += 1
      self.next_scroll = 11


if __name__ == "__main__":
    """
    Run module in test mode.
    """
    from py3status.module_test import module_test
    module_test(Py3status)
