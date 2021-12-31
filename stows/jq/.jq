# Converts a json object into a line-orient format for exploration.
def explore:
  paths(scalars) as $p
    | [
        (
          [ $p[]
              | if type == "string"
                then
                  "." +
                    if false
                      or (. | contains(" "))
                      or (. | contains("-"))
                      or (. | contains(":"))
                      or (. | contains("["))
                      or (. | contains("]"))
                    then "[\"" + (. | tostring) + "\"]"
                    else .
                    end
                else "[" + (. | tostring) + "]"
                end
          ] | join("")
          )
        ,
        (getpath($p) | tojson)
      ]
    | join(": ")
  ;
