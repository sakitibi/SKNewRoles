execute unless data storage sys: {game_phase:0} run data modify storage sys: game_phase set value 8
execute unless data storage sys: {game_phase:0} run tellraw @a [{"text":"[システムアナウンス] "},{"selector":"@s"},{"text":"がゲームを強制終了"}]

execute if data storage sys: {game_phase:0} run tellraw @a [{"text":"[システムアナウンス] "},{"selector":"@s"},{"text":"がゲームをリセット"}]
execute if data storage sys: {game_phase:0} if data storage sys: {game_start:1} run schedule clear werewolf:.system/countdown/1
execute if data storage sys: {game_phase:0} if data storage sys: {game_start:1} run schedule clear werewolf:.system/countdown/2
execute if data storage sys: {game_phase:0} if data storage sys: {game_start:1} run schedule clear werewolf:.system/countdown/3
execute if data storage sys: {game_phase:0} if data storage sys: {game_start:1} run schedule clear werewolf:.system/gamestart
execute if data storage sys: {game_phase:0} if data storage sys: {game_start:1} run data modify storage sys: game_start set value 0
execute if data storage sys: {game_phase:0} run function werewolf:.system/.game_end

function werewolf:.install