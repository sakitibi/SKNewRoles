execute if data storage sys: {game_phase:3} run data modify storage sys: win.camp set value '[{"text":"村陣営 (","color":"green"},{"selector":"@a[tag=camp_green]","color":"green"},{"text":")","color":"green"}]'
execute if data storage sys: {game_phase:3} run title @a subtitle {"text":""}
execute if data storage sys: {game_phase:3} run title @a title [{"text":"\uF811\uE101\uF811","font":"announce"}]
execute if data storage sys: {game_phase:3} as @a[tag=camp_green] run function werewolf:.system/point
execute if data storage sys: {game_phase:3} as @a[tag=!camp_green] run function werewolf:.system/lose