# 落ちているアイテムをキル
kill @e[type=item]
# 弓矢をキル
kill @e[type=arrow]

# タスク勝利関係
execute if data storage sys: task_win{active:0} store result storage sys: task_win.progress int 1 run data get storage sys: task_win.count
#納品箱設置
execute if data storage sys: task_win{active:0} at @e[type=marker,tag=task_win_chest] align xyz run summon block_display ~ ~ ~ {block_state:{Name:"barrel",Properties:{facing:"up"}},Tags:["task_win_chest"]}
execute if data storage sys: task_win{active:0} at @e[type=marker,tag=task_win_chest] align xyz run setblock ~ ~ ~ barrier
execute if data storage sys: task_win{active:0} at @e[type=marker,tag=task_win_chest] align xyz run summon item ~0.5 ~1.3 ~0.5 {Item:{id:"minecraft:emerald",Count:1b},Tags:["task_win_chest"],PickupDelay:100000,NoGravity:true}
execute if data storage sys: task_win{active:0} at @e[type=marker,tag=task_win_chest] align xyz run summon interaction ~0.5 ~1.01 ~0.5 {Tags:["task_win_chest"],width:1.01f,height:-1.01f}
#演出
execute if data storage sys: task_win{active:0} at @e[type=marker,tag=task_win_chest] align xyz run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a

#役職振り分け
#                        //------------------------------------------------役職追加の際追記
# 参加者全員を村人に
team join Mura @e[team=Sanka,type=#werewolf:role_is_chosen]
function werewolf:.system/game_start_modules/role_draw/mura
function werewolf:.system/game_start_modules/role_draw/jinrou
function werewolf:.system/game_start_modules/role_draw/other
# 数合わせのアーマースタンドをキル
kill @e[type=armor_stand,tag=player_dummy]

# 役職判定を設定
#                        //------------------------------------------------役職追加の際追記
function werewolf:role/.rolejudge


# 昼夜の設定
function werewolf:.system/time_change/change_first_day

#日付を記録
scoreboard players set GameManager day 1

# 扉を閉めておく
function werewolf:.system/close_door/

# ランダムチェストを設置
function werewolf:.system/treasure_chest/set_treasure_chest

# イベントをシャッフル
function werewolf:random_event/.event_shuffle/

# エリアを封鎖する
function werewolf:.system/no_passage

#設定ボスバーを非表示
bossbar set minecraft:settings_bossbar visible false

# ゲームフェイズを変更
function werewolf:.system/gamephasechange

# アイテムを配布
function werewolf:item/.set_item

# 役職を表示
function werewolf:role/.role_view

# プレイヤーを指定位置にtp
schedule function werewolf:.system/set_player/ 2s

data modify storage sys: enchantress set value true