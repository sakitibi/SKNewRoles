#夜になったらペナルティ発動
execute if data storage sys: {time_phase:night} run schedule function werewolf:random_event/monster_stampede/.time_up 3s

#夜になるまで再帰処理
execute if data storage sys: {game_phase:1} if data storage sys: {time_phase:day} run schedule function werewolf:random_event/monster_stampede/.schedule_penalty 1t