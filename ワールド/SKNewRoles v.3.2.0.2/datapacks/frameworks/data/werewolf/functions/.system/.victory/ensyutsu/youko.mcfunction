execute if data storage sys: {game_phase:4} unless entity @a[tag=team_haitoku] run data modify storage sys: win.camp set value '[{"text":"妖狐陣営 (","color":"aqua"},{"selector":"@a[tag=team_youko]","color":"aqua"},{"text":")","color":"aqua"}]'
execute if data storage sys: {game_phase:4} if entity @a[tag=team_haitoku] run data modify storage sys: win.camp set value '[{"text":"妖狐陣営 (","color":"aqua"},{"selector":"@a[tag=team_youko]","color":"aqua"},{"text":", ","color":"gray"},{"selector":"@a[tag=team_haitoku]","color":"aqua"},{"text":")","color":"aqua"}]'
execute if data storage sys: {game_phase:4} run title @a subtitle {"text":""}
execute if data storage sys: {game_phase:4} run title @a title [{"text":"\uF811\uE103\uF811","font":"announce"}]
execute if data storage sys: {game_phase:4} as @a[tag=team_youko] run function werewolf:.system/point
execute if data storage sys: {game_phase:4} as @a[tag=team_haitoku] run function werewolf:.system/point
execute if data storage sys: {game_phase:4} as @a[tag=!team_youko] run function werewolf:.system/lose
execute if data storage sys: {game_phase:4} as @a[tag=!team_haitoku] run function werewolf:.system/lose