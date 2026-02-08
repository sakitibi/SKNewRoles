execute as @s[tag=1] run data modify storage sys: random_event.shuffle append value 1
execute as @s[tag=2] run data modify storage sys: random_event.shuffle append value 2
execute as @s[tag=3] run data modify storage sys: random_event.shuffle append value 3
execute as @s[tag=4] run data modify storage sys: random_event.shuffle append value 4
execute as @s[tag=5] run data modify storage sys: random_event.shuffle append value 5
execute as @s[tag=6] run data modify storage sys: random_event.shuffle append value 6
execute as @s[tag=7] run data modify storage sys: random_event.shuffle append value 7
execute as @s[tag=8] run data modify storage sys: random_event.shuffle append value 8
#[hit_the_target] 弓が売られていなければ発生しないように,昼時間が2分以下なら発生しないように
execute as @s[tag=9] unless data storage shop: price{normal_arrow:0} unless data storage shop: price{normal_bow:0} unless score GameManager set_daytime matches ..2400 run data modify storage sys: random_event.shuffle append value 9
execute as @s[tag=10] run data modify storage sys: random_event.shuffle append value 10
execute as @s[tag=11] run data modify storage sys: random_event.shuffle append value 11
execute as @s[tag=12] run data modify storage sys: random_event.shuffle append value 12
execute as @s[tag=13] run data modify storage sys: random_event.shuffle append value 13
execute as @s[tag=14] run data modify storage sys: random_event.shuffle append value 14
execute as @s[tag=15] run data modify storage sys: random_event.shuffle append value 15
execute as @s[tag=16] run data modify storage sys: random_event.shuffle append value 16
execute as @s[tag=17] run data modify storage sys: random_event.shuffle append value 17
execute as @s[tag=18] run data modify storage sys: random_event.shuffle append value 18
execute as @s[tag=19] run data modify storage sys: random_event.shuffle append value 19
execute as @s[tag=20] run data modify storage sys: random_event.shuffle append value 20
execute as @s[tag=21] run data modify storage sys: random_event.shuffle append value 21
execute as @s[tag=22] run data modify storage sys: random_event.shuffle append value 22
execute as @s[tag=23] run data modify storage sys: random_event.shuffle append value 23
execute as @s[tag=24] run data modify storage sys: random_event.shuffle append value 24

kill @s[type=marker,tag=event_shuffle]