execute if data storage sys: {game_phase:11} unless entity @a[tag=team_haitoku] run data modify storage sys: win.camp set value '[{"text":"ジャッカル陣営 (","color":"aqua"},{"selector":"@a[tag=team_jackal]","color":"aqua"},{"text":")","color":"aqua"}]'
execute if data storage sys: {game_phase:11} if entity @a[tag=team_haitoku] run data modify storage sys: win.camp set value '[{"text":"ジャッカル陣営 (","color":"aqua"},{"selector":"@a[tag=team_jackal]","color":"aqua"},{"text":", ","color":"gray"},{"selector":"@a[tag=team_sidekick]","color":"aqua"},{"text":")","color":"aqua"}]'
execute if data storage sys: {game_phase:11} run title @a subtitle {"text":""}
execute if data storage sys: {game_phase:11} run title @a title [{"text":"\uF811\uE107\uF811","font":"announce"}]
execute if data storage sys: {game_phase:11} as @a[tag=team_jackal] run function werewolf:.system/point
execute if data storage sys: {game_phase:11} as @a[tag=team_sidekick] run function werewolf:.system/point
execute if data storage sys: {game_phase:11} as @a[tag=!team_jackal] run function werewolf:.system/lose
execute if data storage sys: {game_phase:11} as @a[tag=!team_sidekick] run function werewolf:.system/lose