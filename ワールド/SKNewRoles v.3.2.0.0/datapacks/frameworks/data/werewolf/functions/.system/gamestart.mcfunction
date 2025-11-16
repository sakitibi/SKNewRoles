#参加プレイヤーの人数を記録
execute store result score GameManager member_count if entity @a[team=Sanka]

#初期設定 
# タイトル設定をリセット
title @a reset
# 死亡カウントをリセット
scoreboard players set @a death 0
# タスク場所をセット
function werewolf:task/set_task
# チェストをセット
#function werewolf:.system/chest/set_chest
# スキルモードをリセット
scoreboard players set @a skill_mode 0

#体力を戻す
execute as @a run attribute @s minecraft:generic.max_health base set 20
#移動速度を戻す
execute as @a run attribute @s minecraft:generic.movement_speed base set 0.1

# ランダムイベントタイマーを設定 ##後に設定
execute if data storage sys: {event_active:0} run scoreboard players set GameManager event_timer 2400
execute if data storage sys: {event_active:1} run scoreboard players reset GameManager event_timer
# ランダムイベント個別設定
function werewolf:random_event/ancient_hidden_room/hidden_wall/set_fake_wall

# 緊急会議関連
scoreboard players set @a meeting_button 0
scoreboard players set GameManager can_convence 0
data remove storage sys: meeting.dead

#役職追加　　　　　　　　　//------------------------------------------------役職追加の際追記
function werewolf:.system/game_start_modules/team_add/mura
function werewolf:.system/game_start_modules/team_add/jinrou
function werewolf:.system/game_start_modules/team_add/other

# 個別タグ付け
tag @a[team=Sanka] add player
team join Fusanka @a[team=!Sanka]
function werewolf:.system/game_start_modules/team_add/mura
function werewolf:.system/game_start_modules/team_add/jinrou
function werewolf:.system/game_start_modules/team_add/other
#                        //------------------------------------------------役職追加の際追記
scoreboard players set GameManager Role_count 0
function werewolf:.system/game_start_modules/score_add/mura
function werewolf:.system/game_start_modules/score_add/jinrou
function werewolf:.system/game_start_modules/score_add/other
#                        //------------------------------------------------役職追加の際追記
function werewolf:.settings/role/count/reset_count

#スコアを再設定
function werewolf:.system/game_start_modules/score_resettings/mura
function werewolf:.system/game_start_modules/score_resettings/jinrou
function werewolf:.system/game_start_modules/score_resettings/other

scoreboard players random @a randomattribute 0 3
scoreboard players set @a itemreset 0

#参加人数に応じてモード変更
execute if score GameManager member_count matches ..5 run data modify storage sys: task_count set value 0
execute if score GameManager member_count matches 6..9 run data modify storage sys: task_count set value 1
execute if score GameManager member_count matches 10.. run data modify storage sys: task_count set value 2

#商人のアイテムリストをリセット
execute as @e[type=wandering_trader] run schedule function werewolf:shop/add_products 1t append true

# 数合わせのアーマースタンドをキル
kill @e[type=armor_stand,tag=player_dummy]

#乱数の偏り防止のための処理-1
#プレイヤーの座標に役職分配の為のアーマースタンドを召喚
execute as @a[team=Sanka] at @s run summon armor_stand ~ ~ ~ {Team:"Sanka",Tags:["player_dummy"],Marker:true,Invisible:true,NoGravity:true}
#役職余り分のアーマースタンドを召喚
schedule function werewolf:.system/gamestart2 1t append true