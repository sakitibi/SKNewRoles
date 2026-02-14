execute if data storage sys: {game_phase:6} unless entity @a[tag=lovers] run data modify storage sys: win.camp set value '[{"text":"恋人陣営 (","color":"aqua"},{"selector":"@a[tag=team_cupid],","color":"aqua"},{"text":")","color":"aqua"}]'
execute if data storage sys: {game_phase:6} if entity @a[tag=lovers] run data modify storage sys: win.camp set value '[{"text":"恋人陣営 (","color":"aqua"},{"selector":"@a[tag=team_cupid],","color":"aqua"},{"text":", ","color":"gray"},{"selector":"@a[tag=lovers],","color":"aqua"},{"text":")","color":"aqua"}]'
execute if data storage sys: {game_phase:6} run title @a subtitle {"text":""}
execute if data storage sys: {game_phase:6} run title @a title [{"text":"\uF811\uE105\uF811","font":"announce"}]
execute if data storage sys: {game_phase:6} as @a[tag=lovers] run function werewolf:.system/point
execute if data storage sys: {game_phase:6} as @a[tag=team_cupid] run function werewolf:.system/point
execute if data storage sys: {game_phase:6} as @a[tag=!lovers] run function werewolf:.system/lose
execute if data storage sys: {game_phase:6} as @a[tag=!team_cupid] run function werewolf:.system/lose