scoreboard players set GameManager event_timer 1000
function werewolf:.system/get_rng
#60%でイベント無し
#execute if score GameManager rng matches 0..50 run tellraw @a {"text":"[システムアナウンス] 何も起きなかった。"}

#クエスト発生で効果音を鳴らす
execute if score GameManager rng matches 51..99 as @a at @s run playsound minecraft:quest_start master @s

#49%でイベント
#1
execute if score GameManager rng matches 51..57 run function werewolf:random_event/monster_stampede/.start
#2
execute if score GameManager rng matches 58..64 run function werewolf:random_event/acid_rain/.start
#3
execute if score GameManager rng matches 65..71 run function werewolf:random_event/falling_salmon/.start
#4
execute if score GameManager rng matches 72..78 run function werewolf:random_event/poison_axolotl/.start
#5
execute if score GameManager rng matches 79..85 run function werewolf:random_event/stray_wolf/.start
#6
execute if score GameManager rng matches 86..92 run function werewolf:random_event/delivery_bread/.start
#7
execute if score GameManager rng matches 93..99 run function werewolf:random_event/random_teleport/.start
