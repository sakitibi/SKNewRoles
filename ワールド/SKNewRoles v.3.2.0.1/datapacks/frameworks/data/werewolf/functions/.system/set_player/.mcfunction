tag @e[type=marker,tag=start] add not_yet


tp @a[tag=1] @e[type=marker,tag=start,tag=not_yet,sort=random,limit=1]
execute at @a[tag=1] run tag @e[type=marker,tag=start,tag=not_yet,sort=nearest,limit=1] remove not_yet

tp @a[tag=2] @e[type=marker,tag=start,tag=not_yet,sort=random,limit=1]
execute at @a[tag=2] run tag @e[type=marker,tag=start,tag=not_yet,sort=nearest,limit=1] remove not_yet

tp @a[tag=3] @e[type=marker,tag=start,tag=not_yet,sort=random,limit=1]
execute at @a[tag=3] run tag @e[type=marker,tag=start,tag=not_yet,sort=nearest,limit=1] remove not_yet

tp @a[tag=4] @e[type=marker,tag=start,tag=not_yet,sort=random,limit=1]
execute as @a[tag=4] at @s run tag @e[type=marker,tag=start,tag=not_yet,sort=nearest,limit=1] remove not_yet

tp @a[tag=5] @e[type=marker,tag=start,tag=not_yet,sort=random,limit=1]
execute as @a[tag=5] at @s run tag @e[type=marker,tag=start,tag=not_yet,sort=nearest,limit=1] remove not_yet

tp @a[tag=6] @e[type=marker,tag=start,tag=not_yet,sort=random,limit=1]
execute as @a[tag=6] at @s run tag @e[type=marker,tag=start,tag=not_yet,sort=nearest,limit=1] remove not_yet

tp @a[tag=7] @e[type=marker,tag=start,tag=not_yet,sort=random,limit=1]
execute as @a[tag=7] at @s run tag @e[type=marker,tag=start,tag=not_yet,sort=nearest,limit=1] remove not_yet

tp @a[tag=8] @e[type=marker,tag=start,tag=not_yet,sort=random,limit=1]
execute as @a[tag=8] at @s run tag @e[type=marker,tag=start,tag=not_yet,sort=nearest,limit=1] remove not_yet

tp @a[tag=9] @e[type=marker,tag=start,tag=not_yet,sort=random,limit=1]
execute as @a[tag=9] at @s run tag @e[type=marker,tag=start,tag=not_yet,sort=nearest,limit=1] remove not_yet

tp @a[tag=10] @e[type=marker,tag=start,tag=not_yet,sort=random,limit=1]
execute as @a[tag=10] at @s run tag @e[type=marker,tag=start,tag=not_yet,sort=nearest,limit=1] remove not_yet

tp @a[tag=11] @e[type=marker,tag=start,tag=not_yet,sort=random,limit=1]
execute as @a[tag=11] at @s run tag @e[type=marker,tag=start,tag=not_yet,sort=nearest,limit=1] remove not_yet

tp @a[tag=12] @e[type=marker,tag=start,tag=not_yet,sort=random,limit=1]
execute as @a[tag=12] at @s run tag @e[type=marker,tag=start,tag=not_yet,sort=nearest,limit=1] remove not_yet

tp @a[tag=13] @e[type=marker,tag=start,tag=not_yet,sort=random,limit=1]
execute as @a[tag=13] at @s run tag @e[type=marker,tag=start,tag=not_yet,sort=nearest,limit=1] remove not_yet

tag @e[type=marker,tag=start] remove not_yet


#effect give @a[tag=player] luck 2 0 true
#function werewolf:role/.role_view_lock