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
schedule function werewolf:.system/.victory/mode/annihilation 1t append false
## 同数モード
schedule function werewolf:.system/.victory/mode/equal 1t append false
#結果出力の前にクエストを強制終了
execute unless data storage sys: {game_phase:0} unless data storage sys: {game_phase:1} run function werewolf:random_event/event_reset_1

#人狼陣営勝利演出
schedule function werewolf:.system/.victory/ensyutsu/jinrou 1t append false
#村人陣営勝利演出
schedule function werewolf:.system/.victory/ensyutsu/mura 1t append false
#妖狐陣営勝利演出
schedule function werewolf:.system/.victory/ensyutsu/youko 1t append false
#死神陣営勝利演出
schedule function werewolf:.system/.victory/ensyutsu/shinigami 1t append false
#キューピット陣営勝利演出
schedule function werewolf:.system/.victory/ensyutsu/cupid 1t append false
#ジャッカル陣営勝利演出
schedule function werewolf:.system/.victory/ensyutsu/jackal 1t append false
#引き分け
execute unless entity @a[tag=player] run data modify storage sys: game_phase set value 7
execute if data storage sys: {game_phase:7} run title @a title {"text":"ドロー","color":"white"}

#ゲームを強制終了
# プレイヤーがいなくなったらゲームを強制終了
execute unless entity @a[tag=player] run data modify storage sys: game_phase set value 8
execute if data storage sys: {game_phase:8} run title @a subtitle {"text":""}
execute if data storage sys: {game_phase:8} run title @a title {"text":"強制終了","color":"white"}

#最終処理
#カップル未達成時にラバーズタグを削除
execute unless data storage sys: {game_phase:0} unless data storage sys: {game_phase:1} if score GameManager lovers_full matches 0 run tag @a remove lovers
#ゲーム終了
execute unless data storage sys: {game_phase:0} unless data storage sys: {game_phase:1} run function werewolf:.system/.game_end