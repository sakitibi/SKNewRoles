execute if data storage sys: {game_phase:2} run data modify storage sys: win.camp set value '[{"text":"狼陣営 (","color":"red"},{"selector":"@a[tag=camp_red]","color":"red"},{"text":")","color":"red"}]'
execute if data storage sys: {game_phase:2} run title @a subtitle {"text":""}
execute if data storage sys: {game_phase:2} run title @a title [{"text":"\uF811\uE102\uF811","font":"announce"}]
execute if data storage sys: {game_phase:2} as @a[tag=camp_red] run function werewolf:.system/point
execute if data storage sys: {game_phase:2} as @a[tag=!camp_red] run function werewolf:.system/lose