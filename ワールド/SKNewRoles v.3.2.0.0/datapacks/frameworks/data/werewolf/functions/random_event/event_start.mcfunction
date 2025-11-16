#前回のイベントリストを削除
data remove storage sys: random_event.recent_event
#クエストナンバーの読み込み
execute if data storage sys: random_event.shuffle[0] store result storage sys: random_event.recent_event int 1 run data get storage sys: random_event.shuffle[0]
#残りのクエストが存在しない場合
#execute unless data storage sys: random_event.shuffle[0] run tellraw @a "何も起こらなかった"



#1
execute if data storage sys: random_event{recent_event:1} run function werewolf:random_event/monster_stampede/.start
#2
execute if data storage sys: random_event{recent_event:2} run function werewolf:random_event/acid_rain/.start
#3
execute if data storage sys: random_event{recent_event:3} run function werewolf:random_event/falling_salmon/.start
#4
execute if data storage sys: random_event{recent_event:4} run function werewolf:random_event/poison_axolotl/.start
#5
execute if data storage sys: random_event{recent_event:5} run function werewolf:random_event/stray_wolf/.start
#6
execute if data storage sys: random_event{recent_event:6} run function werewolf:random_event/delivery_bread/.start
#7
execute if data storage sys: random_event{recent_event:7} run function werewolf:random_event/random_teleport/.start
#8
execute if data storage sys: random_event{recent_event:8} run function werewolf:random_event/delivery_apple/.start
#9 制限時間が100秒のため開始フラグを限定
execute if data storage sys: random_event{recent_event:9} unless score GameManager common_timer matches ..2100 run function werewolf:random_event/hit_the_target/.start
#10
execute if data storage sys: random_event{recent_event:10} run function werewolf:random_event/hidden_property/.start
#11
execute if data storage sys: random_event{recent_event:11} run function werewolf:random_event/ancient_hidden_room/.start
#12
execute if data storage sys: random_event{recent_event:12} run execute if entity @a[team=Witch] run function werewolf:random_event/delivery_emerald/.start