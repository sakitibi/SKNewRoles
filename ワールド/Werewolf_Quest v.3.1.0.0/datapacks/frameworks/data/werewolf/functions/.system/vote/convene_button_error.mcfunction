#エラー通知
#execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} run tellraw @s "は既に緊急会議を招集している"

advancement revoke @s only werewolf:meeting/convence_error