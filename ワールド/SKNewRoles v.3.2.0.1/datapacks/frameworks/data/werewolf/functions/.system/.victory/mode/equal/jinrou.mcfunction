#人狼の人数を記録
execute if data storage judge_mode: {judge_mode:1} run execute store result score GameManager red_count if entity @e[tag=player,tag=!no_jinrou]
#人狼陣営勝利判定
execute if data storage judge_mode: {judge_mode:1} if score GameManager red_count >= GameManager green_count if score GameManager blue_count matches ..0 run data modify storage sys: game_phase set value 2
execute if data storage judge_mode: {judge_mode:1} if score GameManager red_count >= GameManager green_count if score GameManager blue_count matches ..0 run data modify storage sys: win.camp set value '[{"text":"狼陣営","color":"red"}]'
execute if data storage judge_mode: {judge_mode:1} if score GameManager red_count >= GameManager green_count if score GameManager blue_count matches ..0 run data modify storage sys: win.cause set value '[{"text":"人狼の数が村陣営の半数以上を占める"}]'