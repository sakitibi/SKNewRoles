#村陣営の人数を記録
execute if data storage judge_mode: {judge_mode:1} run execute store result score GameManager green_count if entity @e[tag=player,tag=no_jinrou,tag=!camp_pink]

#村人陣営勝利判定
execute if data storage judge_mode: {judge_mode:1} if score GameManager red_count matches ..0 if score GameManager blue_count matches ..0 run data modify storage sys: game_phase set value 3
execute if data storage judge_mode: {judge_mode:1} if score GameManager red_count matches ..0 if score GameManager blue_count matches ..0 run data modify storage sys: win.camp set value '[{"text":"村陣営","color":"green"}]'
execute if data storage judge_mode: {judge_mode:1} if score GameManager red_count matches ..0 if score GameManager blue_count matches ..0 run data modify storage sys: win.cause set value '[{"text":"人狼の全滅"}]'