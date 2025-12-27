team join Sanka @a[team=!Fusanka]
kill @e[type=item]
clear @a
kill @e[tag=grave]
gamemode adventure @a
time set 3000
effect clear @a
#                        //------------------------------------------------役職追加の際追記
function werewolf:.system/game_end_modules/team_remove/jinrou
function werewolf:.system/game_end_modules/team_remove/mura
function werewolf:.system/game_end_modules/team_remove/other
#役職結果出力
#                        //------------------------------------------------役職追加の際追記
#execute unless data storage sys: {game_phase:0} run function werewolf:.system/result/main

# 役職判定をリセット
scoreboard players set @a role 0
# タグリセット
tag @a remove player
tag @a remove 1
tag @a remove 2
tag @a remove 3
tag @a remove 4
tag @a remove 5
tag @a remove 6
tag @a remove 7
tag @a remove 8
tag @a remove 9
tag @a remove 10
tag @a remove 11
tag @a remove 12
tag @a remove 13
tag @a remove hang
# 結果出力用の役職タグをリセット
#                        //------------------------------------------------役職追加の際追記
function werewolf:.system/game_end_modules/team_remove/tags/jinrou
function werewolf:.system/game_end_modules/team_remove/tags/mura
function werewolf:.system/game_end_modules/team_remove/tags/other

tag @a remove no_jinrou
tag @a remove camp_red
tag @a remove camp_green
tag @a remove camp_pink

tag @a remove lovers
tag @a remove lovers_1
tag @a remove lovers_2

tag @a remove saibankan_1

tag @a remove jinrou_dummy
tag @a remove wanashi_dummy
tag @a remove uranai_dummy
tag @a remove reinou_dummy
tag @a remove kishi_dummy
tag @a remove hoankan_dummy
tag @a remove ojousama_dummy
tag @a remove saibankan_dummy

tag @a remove be_written_jinrou
tag @a remove be_written_jackal
tag @a remove be_written_comuner
tag @a remove can_use_vent

# ボスバー削除
bossbar remove time_bossbar

# クエスト関連
function werewolf:random_event/event_reset_1
# 門が閉まっていれば開ける
kill @e[type=block_display,tag=gate]

# エリアを解除する
function werewolf:.system/no_passage_delete

# チェスト関連
#function werewolf:.system/chest/.set_chest_player_head
# ランダムチェスト関連
function werewolf:.system/treasure_chest/kill_all_treasure_chest
# タスク関連
execute at @e[type=marker,tag=task_point] as @e[type=marker,tag=task_point] run setblock ~ ~ ~ air
kill @e[type=item_display,tag=no_task]
kill @e[type=block_display,tag=no_task]
kill @e[type=item_display,tag=select_block]
kill @e[type=interaction,tag=task_point]
kill @e[type=interaction,tag=switcher]
tag @e[type=marker,tag=task_point,tag=set_task] remove set_task
function werewolf:task/.set_task_player_head
function werewolf:task/night_task/remove_task
#タスク勝利関連
kill @e[type=!marker,tag=task_win_chest]
execute at @e[type=marker,tag=task_win_chest] align xyz run setblock ~ ~ ~ air
#演出
execute if data storage sys: task_win{active:0} at @e[type=marker,tag=task_win_chest] align xyz run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a
# スキル関連
# スキルモードをリセット
scoreboard players set @a skill_mode 0
# 落とし穴をリセット
kill @e[type=marker,tag=pitfall]
kill @e[type=marker,tag=pitfall_tp]
scoreboard players set @a fall_into_a_pitfall 0
# 落ちているアイテムをキル
kill @e[type=item]
# 弓矢をキル
kill @e[type=arrow]

# 交易内容をリセット
execute as @e[type=wandering_trader] run data remove entity @s Offers.Recipes

# オーナー検知用のスコアボードリセット
scoreboard players reset @e owner

scoreboard players set @a ready 0
data modify storage sys: game_start set value 0

data modify storage sys: game_phase set value 0
scoreboard reset GameManager emerald_give
execute as @a run function werewolf:.system/inventory_menu/set_inventory_menu

#体力を戻す
execute as @a run attribute @s minecraft:generic.max_health base set 20
#移動速度を戻す
execute as @a run attribute @s minecraft:generic.movement_speed base set 0.1

# 終了後ワープ
#tp @a @e[type=marker,tag=end,limit=1]

#設定ボスバーを表示
bossbar set minecraft:settings_bossbar visible true
scoreboard players reset @a[scores={seer_madness=0..}] seer_madness
scoreboard players reset @a[team=Serialkiller] serialkiller_countdown
scoreboard players reset @a[team=Serialkiller] serialkiller_killcooldown
scoreboard players reset @a comuner_fined
tag @a remove isFined