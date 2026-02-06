scoreboard players set GameManager event_timer 1000
function werewolf:.system/get_rng
#50%でイベント無し
execute if score GameManager rng matches 0..29 run tellraw @a {"text":"[システムアナウンス] 何も起きなかった。"}

#約70%でイベント
execute if score GameManager rng matches 30..99 run function werewolf:random_event/event_start