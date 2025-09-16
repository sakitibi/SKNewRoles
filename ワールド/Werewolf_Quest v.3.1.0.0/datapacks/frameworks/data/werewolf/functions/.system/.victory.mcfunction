## タスク勝利
execute if data storage sys: task_win{active:0} if data storage sys: task_win{progress:0} run data modify storage sys: game_phase set value 3
##勝利を記録
execute if data storage sys: task_win{active:0} if data storage sys: task_win{progress:0} run data modify storage sys: win.camp set value '[{"text":"村陣営","color":"green"}]'
execute if data storage sys: task_win{active:0} if data storage sys: task_win{progress:0} run data modify storage sys: win.cause set value '[{"text":"タスク勝利"}]'

execute if data storage sys: task_win{active:0} if data storage sys: task_win{progress:0} if entity @e[team=Youko] run data modify storage sys: game_phase set value 4
##勝利を記録
execute if data storage sys: task_win{active:0} if data storage sys: task_win{progress:0} if entity @e[team=Youko] run data modify storage sys: win.camp set value '[{"text":"妖狐陣営","color":"light_purple"}]'
execute if data storage sys: task_win{active:0} if data storage sys: task_win{progress:0} if entity @e[team=Youko] run data modify storage sys: win.camp set value '[{"text":"村陣営のタスク勝利時に妖狐が生存"}]'



# 全滅モード
#人狼陣営勝利判定
execute if data storage judge_mode: {judge_mode:0} if entity @e[tag=camp_red,team=!Kyoujin,team=!Kyoushin,team=!Wanashi,scores={satsumatoimo_role=0},team=Madseer,team=!Tenkai] unless entity @e[tag=camp_green,team=!Tenkai,team=!Ojousama,team=Jackal,team=Sidekick] unless entity @e[tag=camp_pink,team=!Cupid,team=!Haitoku,team=!Jackal,team=Sidekick,team=!Tenkai] run data modify storage sys: game_phase set value 2
execute if data storage judge_mode: {judge_mode:0} if entity @e[tag=camp_red,team=!Kyoujin,team=!Kyoushin,team=!Wanashi,scores={satsumatoimo_role=0},team=Madseer,team=!Tenkai] unless entity @e[tag=camp_green,team=!Tenkai,team=!Ojousama,team=Jackal,team=Sidekick] unless entity @e[tag=camp_pink,team=!Cupid,team=!Haitoku,team=!Jackal,team=Sidekick,team=!Tenkai] run data modify storage sys: win.cause set value '[{"text":"狼陣営が最後まで生き残る"}]'

#ジャッカル陣営勝利判定
execute if data storage judge_mode: {judge_mode:0} if entity @e[tag=camp_pink,team=Jackal,team=Sidekick,team=!Tenkai] unless entity @e[tag=!camp_green,team=Tenkai,team=Ojousama] unless entity @e[tag=!camp_red,team=Kyoujin,team=Kyoushin,team=Wanashi,team=Madseer] unless entity @e[tag=camp_pink,team=!Cupid,team=!Haitoku,team=!Tenkai] run data modify storage sys: game_phase set value 11
execute if data storage judge_mode: {judge_mode:0} if entity @e[tag=camp_pink,team=Jackal,team=Sidekick,team=!Tenkai] unless entity @e[tag=!camp_green,team=Tenkai,team=Ojousama] unless entity @e[tag=!camp_red,team=Kyoujin,team=Kyoushin,team=Wanashi,team=Madseer] unless entity @e[tag=camp_pink,team=!Cupid,team=!Haitoku,team=!Tenkai] run data modify storage sys: win.cause set value '[{"text":"ジャッカル陣営が最後まで生き残る"}]'

#村人陣営勝利判定
execute if data storage judge_mode: {judge_mode:0} if entity @e[tag=camp_green,team=!Tenkai] unless entity @e[tag=camp_red,team=!Kyoujin,team=!Kyoushin,team=!Wanashi,team=!Tenkai] unless entity @e[tag=camp_pink,team=!Cupid,team=!Haitoku,team=Jackal,team=Sidekick,team=!Tenkai] run data modify storage sys: game_phase set value 3
 #例外:さつまといも_m
execute if data storage judge_mode: {judge_mode:0} if entity @e[scores={satsumatoimo_role=1}] unless entity @e[tag=camp_green,team=!Tenkai] unless entity @e[tag=camp_red,team=!Kyoujin,team=!Kyoushin,team=!Wanashi,scores={satsumatoimo_role=1},team=!Tenkai] unless entity @e[tag=camp_pink,team=!Cupid,team=!Haitoku,team=Jackal,team=Sidekick,team=!Tenkai] run data modify storage sys: game_phase set value 3
 #村人陣営勝利判定
execute if data storage judge_mode: {judge_mode:0} if data storage sys: {game_phase:3} run data modify storage sys: win.cause set value '[{"text":"村陣営が最後まで生き残る"}]'

#妖狐陣営勝利判定
execute if data storage judge_mode: {judge_mode:0} if entity @e[team=Youko] unless entity @e[tag=camp_pink,team=!Youko,team=!Haitoku,team=!Tenkai] unless entity @e[tag=camp_red,team=!Kyoujin,team=!Kyoushin,team=!Wanashi,team=Madseer,team=!Tenkai] if entity @e[tag=camp_green,team=!Tenkai,team=!Ojousama] run data modify storage sys: game_phase set value 4
execute if data storage judge_mode: {judge_mode:0} if entity @e[team=Youko] unless entity @e[tag=camp_pink,team=!Youko,team=!Haitoku,team=!Tenkai] unless entity @e[tag=camp_red,team=!Kyoujin,team=!Kyoushin,team=!Wanashi,team=Madseer,team=!Tenkai] if entity @e[tag=camp_green,team=!Tenkai,team=!Ojousama] run data modify storage sys: win.cause set value '[{"text":"村陣営の勝利時に妖狐が生存"}]'

execute if data storage judge_mode: {judge_mode:0} if entity @e[team=Youko] unless entity @e[tag=camp_pink,team=!Youko,team=!Haitoku,team=!Tenkai] unless entity @e[tag=camp_green,team=!Tenkai,team=!Ojousama] if entity @e[tag=camp_red,team=!Kyoujin,team=!Kyoushin,team=!Wanashi,team=Madseer,team=!Tenkai] run data modify storage sys: game_phase set value 4
execute if data storage judge_mode: {judge_mode:0} if entity @e[team=Youko] unless entity @e[tag=camp_pink,team=!Youko,team=!Haitoku,team=!Tenkai] unless entity @e[tag=camp_green,team=!Tenkai,team=!Ojousama] if entity @e[tag=camp_red,team=!Kyoujin,team=!Kyoushin,team=!Wanashi,team=Madseer,team=!Tenkai] run data modify storage sys: win.cause set value '[{"text":"狼陣営の勝利時に妖狐が生存"}]'

execute if data storage judge_mode: {judge_mode:0} if entity @e[team=Youko] unless entity @e[tag=camp_pink,team=!Youko,team=!Haitoku,team=!Tenkai] unless entity @e[tag=camp_green,team=!Tenkai,team=!Ojousama] unless entity @e[tag=camp_red,team=!Kyoujin,team=!Kyoushin,team=!Wanashi,team=Madseer,team=!Tenkai] unless entity @e[tag=camp_pink,team=Jackal,team=Sidekick] run data modify storage sys: game_phase set value 4
execute if data storage judge_mode: {judge_mode:0} if entity @e[team=Youko] unless entity @e[tag=camp_pink,team=!Youko,team=!Haitoku,team=!Tenkai] unless entity @e[tag=camp_green,team=!Tenkai,team=!Ojousama] unless entity @e[tag=camp_red,team=!Kyoujin,team=!Kyoushin,team=!Wanashi,team=Madseer,team=!Tenkai] unless entity @e[tag=camp_pink,team=Jackal,team=Sidekick] run data modify storage sys: win.cause set value '[{"text":"ジャッカル陣営の勝利時に妖狐が生存"}]'

execute if data storage judge_mode: {judge_mode:0} if entity @e[team=Youko] unless entity @e[tag=camp_pink,team=!Youko,team=!Haitoku,team=!Tenkai] unless entity @e[tag=camp_green,team=!Tenkai,team=!Ojousama] unless entity @e[tag=camp_red,team=!Kyoujin,team=!Kyoushin,team=!Wanashi,team=Madseer,team=!Tenkai] run data modify storage sys: game_phase set value 4
execute if data storage judge_mode: {judge_mode:0} if entity @e[team=Youko] unless entity @e[tag=camp_pink,team=!Youko,team=!Haitoku,team=!Tenkai] unless entity @e[tag=camp_green,team=!Tenkai,team=!Ojousama] unless entity @e[tag=camp_red,team=!Kyoujin,team=!Kyoushin,team=!Wanashi,team=Madseer,team=!Tenkai] run data modify storage sys: win.cause set value '[{"text":"妖狐陣営が最後まで生き残る"}]'

#死神陣営勝利判定
execute if data storage judge_mode: {judge_mode:0} if entity @e[team=Shinigami] unless entity @e[tag=camp_pink,team=!Shinigami,team=Jackal,team=Sidekick,team=!Tenkai] unless entity @e[tag=camp_red,team=!Tenkai] unless entity @e[tag=camp_green,team=!Tenkai,team=!Ojousama] run data modify storage sys: game_phase set value 5
execute if data storage judge_mode: {judge_mode:0} if entity @e[team=Shinigami] unless entity @e[tag=camp_pink,team=!Shinigami,team=Jackal,team=Sidekick,team=!Tenkai] unless entity @e[tag=camp_red,team=!Tenkai] unless entity @e[tag=camp_green,team=!Tenkai,team=!Ojousama] run data modify storage sys: win.cause set value '[{"text":"死神陣営が最後まで生き残る"}]'

#恋人陣営勝利判定
 #ラバーズ2人生存＋キューピット以外の生存者がいない
execute if data storage judge_mode: {judge_mode:0} if entity @e[tag=player,tag=lovers_1] if entity @e[tag=player,tag=lovers_2] unless entity @e[tag=player,team=!Cupid,tag=!lovers,tag=!lovers_1,tag=!lovers_2,team=!Ojousama] run data modify storage sys: game_phase set value 6
execute if data storage judge_mode: {judge_mode:0} if entity @e[tag=player,tag=lovers_1] if entity @e[tag=player,tag=lovers_2] unless entity @e[tag=player,team=!Cupid,tag=!lovers,tag=!lovers_1,tag=!lovers_2,team=!Ojousama] run data modify storage sys: win.cause set value '[{"text":"恋人2人が最後まで生き残る"}]'
 #1陣営全滅＋ラバーズが生存
execute if data storage judge_mode: {judge_mode:0} unless data storage sys: {game_phase:1} if entity @e[tag=player,tag=lovers_1] if entity @e[tag=player,tag=lovers_2] run data modify storage sys: game_phase set value 6
execute if data storage judge_mode: {judge_mode:0} unless data storage sys: {game_phase:1} if entity @e[tag=player,tag=lovers_1] if entity @e[tag=player,tag=lovers_2] run data modify storage sys: win.cause set value '[{"text":"恋人2人が最後まで生き残る"}]'

## 同数モード
##人狼の人数を記録
execute if data storage judge_mode: {judge_mode:1} run execute store result score GameManager red_count if entity @e[tag=player,tag=!no_jinrou]
##村陣営の人数を記録
execute if data storage judge_mode: {judge_mode:1} run execute store result score GameManager green_count if entity @e[tag=player,tag=no_jinrou,tag=!camp_pink]

##人狼陣営勝利判定
execute if data storage judge_mode: {judge_mode:1} if score GameManager red_count >= GameManager green_count if score GameManager blue_count matches ..0 run data modify storage sys: game_phase set value 2
execute if data storage judge_mode: {judge_mode:1} if score GameManager red_count >= GameManager green_count if score GameManager blue_count matches ..0 run data modify storage sys: win.camp set value '[{"text":"狼陣営","color":"red"}]'
execute if data storage judge_mode: {judge_mode:1} if score GameManager red_count >= GameManager green_count if score GameManager blue_count matches ..0 run data modify storage sys: win.cause set value '[{"text":"人狼の数が村陣営の半数以上を占める"}]'

##村人陣営勝利判定
execute if data storage judge_mode: {judge_mode:1} if score GameManager red_count matches ..0 if score GameManager blue_count matches ..0 run data modify storage sys: game_phase set value 3
execute if data storage judge_mode: {judge_mode:1} if score GameManager red_count matches ..0 if score GameManager blue_count matches ..0 run data modify storage sys: win.camp set value '[{"text":"村陣営","color":"green"}]'
execute if data storage judge_mode: {judge_mode:1} if score GameManager red_count matches ..0 if score GameManager blue_count matches ..0 run data modify storage sys: win.cause set value '[{"text":"人狼の全滅"}]'

##妖狐陣営勝利判定
execute if data storage judge_mode: {judge_mode:1} unless data storage sys: {game_phase:1} if entity @e[team=Youko] run data modify storage sys: game_phase set value 4
execute if data storage judge_mode: {judge_mode:1} unless data storage sys: {game_phase:1} if entity @e[team=Youko] if score GameManager red_count >= GameManager green_count run data modify storage sys: win.camp set value '[{"text":"妖狐陣営","color":"light_purple"}]'
execute if data storage judge_mode: {judge_mode:1} unless data storage sys: {game_phase:1} if entity @e[team=Youko] if score GameManager red_count >= GameManager green_count run data modify storage sys: win.cause set value '[{"text":"狼陣営勝利時に妖狐が生存"}]'
execute if data storage judge_mode: {judge_mode:1} unless data storage sys: {game_phase:1} if entity @e[team=Youko] if score GameManager red_count matches ..0 run data modify storage sys: win.camp set value '[{"text":"妖狐陣営","color":"light_purple"}]'
execute if data storage judge_mode: {judge_mode:1} unless data storage sys: {game_phase:1} if entity @e[team=Youko] if score GameManager red_count matches ..0 run data modify storage sys: win.cause set value '[{"text":"村陣営勝利時に妖狐が生存"}]'
execute if data storage judge_mode: {judge_mode:1} unless data storage sys: {game_phase:1} if entity @e[team=Youko] if score GameManager red_count matches ..0 if score GameManager blue_count >= GameManager run data modify storage sys: win.cause set value '[{"text":"ジャッカル陣営勝利時に妖狐が生存"}]'


#結果出力の前にクエストを強制終了
execute unless data storage sys: {game_phase:0} unless data storage sys: {game_phase:1} run function werewolf:random_event/event_reset_1


#人狼陣営勝利演出
execute if data storage sys: {game_phase:2} run data modify storage sys: win.camp set value '[{"text":"狼陣営 (","color":"red"},{"selector":"@a[tag=camp_red]","color":"red"},{"text":")","color":"red"}]'
execute if data storage sys: {game_phase:2} run title @a subtitle {"text":""}
execute if data storage sys: {game_phase:2} run title @a title [{"text":"\uF811\uE102\uF811","font":"announce"}]
execute if data storage sys: {game_phase:2} as @a[tag=camp_red] run function werewolf:.system/point
execute if data storage sys: {game_phase:2} as @a[tag=!camp_red] run function werewolf:.system/lose
#村人陣営勝利演出
execute if data storage sys: {game_phase:3} run data modify storage sys: win.camp set value '[{"text":"村陣営 (","color":"green"},{"selector":"@a[tag=camp_green]","color":"green"},{"text":")","color":"green"}]'
execute if data storage sys: {game_phase:3} run title @a subtitle {"text":""}
execute if data storage sys: {game_phase:3} run title @a title [{"text":"\uF811\uE101\uF811","font":"announce"}]
execute if data storage sys: {game_phase:3} as @a[tag=camp_green] run function werewolf:.system/point
execute if data storage sys: {game_phase:3} as @a[tag=!camp_green] run function werewolf:.system/lose
#妖狐陣営勝利演出
execute if data storage sys: {game_phase:4} unless entity @a[tag=team_haitoku] run data modify storage sys: win.camp set value '[{"text":"妖狐陣営 (","color":"aqua"},{"selector":"@a[tag=team_youko]","color":"aqua"},{"text":")","color":"aqua"}]'
execute if data storage sys: {game_phase:4} if entity @a[tag=team_haitoku] run data modify storage sys: win.camp set value '[{"text":"妖狐陣営 (","color":"aqua"},{"selector":"@a[tag=team_youko]","color":"aqua"},{"text":", ","color":"gray"},{"selector":"@a[tag=team_haitoku]","color":"aqua"},{"text":")","color":"aqua"}]'
execute if data storage sys: {game_phase:4} run title @a subtitle {"text":""}
execute if data storage sys: {game_phase:4} run title @a title [{"text":"\uF811\uE103\uF811","font":"announce"}]
execute if data storage sys: {game_phase:4} as @a[tag=team_youko] run function werewolf:.system/point
execute if data storage sys: {game_phase:4} as @a[tag=team_haitoku] run function werewolf:.system/point
execute if data storage sys: {game_phase:4} as @a[tag=!team_youko] run function werewolf:.system/lose
execute if data storage sys: {game_phase:4} as @a[tag=!team_haitoku] run function werewolf:.system/lose
#死神陣営勝利演出
execute if data storage sys: {game_phase:5} run data modify storage sys: win.camp set value '[{"text":"死神陣営 (","color":"aqua"},{"selector":"@a[tag=team_shinigami]","color":"aqua"},{"text":")","color":"aqua"}]'
execute if data storage sys: {game_phase:5} run title @a subtitle {"text":""}
execute if data storage sys: {game_phase:5} run title @a title [{"text":"\uF811\uE104\uF811","font":"announce"}]
execute if data storage sys: {game_phase:5} as @a[tag=team_shinigami] run function werewolf:.system/point
execute if data storage sys: {game_phase:5} as @a[tag=!team_shinigami] run function werewolf:.system/lose
#キューピット陣営勝利演出
execute if data storage sys: {game_phase:6} unless entity @a[tag=lovers] run data modify storage sys: win.camp set value '[{"text":"恋人陣営 (","color":"aqua"},{"selector":"@a[tag=team_cupid],","color":"aqua"},{"text":")","color":"aqua"}]'
execute if data storage sys: {game_phase:6} if entity @a[tag=lovers] run data modify storage sys: win.camp set value '[{"text":"恋人陣営 (","color":"aqua"},{"selector":"@a[tag=team_cupid],","color":"aqua"},{"text":", ","color":"gray"},{"selector":"@a[tag=lovers],","color":"aqua"},{"text":")","color":"aqua"}]'
execute if data storage sys: {game_phase:6} run title @a subtitle {"text":""}
execute if data storage sys: {game_phase:6} run title @a title [{"text":"\uF811\uE105\uF811","font":"announce"}]
execute if data storage sys: {game_phase:6} as @a[tag=lovers] run function werewolf:.system/point
execute if data storage sys: {game_phase:6} as @a[tag=team_cupid] run function werewolf:.system/point
execute if data storage sys: {game_phase:6} as @a[tag=!lovers] run function werewolf:.system/lose
execute if data storage sys: {game_phase:6} as @a[tag=!team_cupid] run function werewolf:.system/lose
#引き分け
execute unless entity @a[tag=player] run data modify storage sys: game_phase set value 7
execute if data storage sys: {game_phase:7} run title @a title {"text":"ドロー","color":"white"}

#ゲームを強制終了
# プレイヤーがいなくなったらゲームを強制終了
execute unless entity @a[tag=player] run data modify storage sys: game_phase set value 8
execute if data storage sys: {game_phase:8} run title @a subtitle {"text":""}
execute if data storage sys: {game_phase:8} run title @a title {"text":"強制終了","color":"white"}

#ジャッカル陣営勝利演出
execute if data storage sys: {game_phase:11} unless entity @a[tag=team_haitoku] run data modify storage sys: win.camp set value '[{"text":"ジャッカル陣営 (","color":"aqua"},{"selector":"@a[tag=team_jackal]","color":"aqua"},{"text":")","color":"aqua"}]'
execute if data storage sys: {game_phase:11} if entity @a[tag=team_haitoku] run data modify storage sys: win.camp set value '[{"text":"ジャッカル陣営 (","color":"aqua"},{"selector":"@a[tag=team_jackal]","color":"aqua"},{"text":", ","color":"gray"},{"selector":"@a[tag=team_sidekick]","color":"aqua"},{"text":")","color":"aqua"}]'
execute if data storage sys: {game_phase:11} run title @a subtitle {"text":""}
execute if data storage sys: {game_phase:11} run title @a title [{"text":"\uF811\uE107\uF811","font":"announce"}]
execute if data storage sys: {game_phase:11} as @a[tag=team_jackal] run function werewolf:.system/point
execute if data storage sys: {game_phase:11} as @a[tag=team_sidekick] run function werewolf:.system/point
execute if data storage sys: {game_phase:11} as @a[tag=!team_jackal] run function werewolf:.system/lose
execute if data storage sys: {game_phase:11} as @a[tag=!team_sidekick] run function werewolf:.system/lose

#最終処理
#カップル未達成時にラバーズタグを削除
execute unless data storage sys: {game_phase:0} unless data storage sys: {game_phase:1} if score GameManager lovers_full matches 0 run tag @a remove lovers
#ゲーム終了
execute unless data storage sys: {game_phase:0} unless data storage sys: {game_phase:1} run function werewolf:.system/.game_end