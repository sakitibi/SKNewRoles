execute if data storage sys: {game_phase:5} run data modify storage sys: win.camp set value '[{"text":"死神陣営 (","color":"aqua"},{"selector":"@a[tag=team_shinigami]","color":"aqua"},{"text":")","color":"aqua"}]'
execute if data storage sys: {game_phase:5} run title @a subtitle {"text":""}
execute if data storage sys: {game_phase:5} run title @a title [{"text":"\uF811\uE104\uF811","font":"announce"}]
execute if data storage sys: {game_phase:5} as @a[tag=team_shinigami] run function werewolf:.system/point
execute if data storage sys: {game_phase:5} as @a[tag=!team_shinigami] run function werewolf:.system/lose