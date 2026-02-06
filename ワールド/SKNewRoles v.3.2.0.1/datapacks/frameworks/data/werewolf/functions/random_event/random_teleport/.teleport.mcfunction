execute as @a[tag=player,team=!Tenkai] at @s run summon marker ^ ^ ^ {Tags:["teleport"]}
execute as @a[tag=player,team=!Tenkai] at @s run tp @e[type=marker,tag=teleport,sort=nearest,limit=1] @s

execute as @a[tag=1,team=!Tenkai] run tp @s @e[type=marker,tag=teleport,sort=random,limit=1]
execute as @a[tag=1,team=!Tenkai] at @s run kill @e[type=marker,tag=teleport,sort=nearest,limit=1]

execute as @a[tag=2,team=!Tenkai] run tp @s @e[type=marker,tag=teleport,sort=random,limit=1]
execute as @a[tag=2,team=!Tenkai] at @s run kill @e[type=marker,tag=teleport,sort=nearest,limit=1]

execute as @a[tag=3,team=!Tenkai] run tp @s @e[type=marker,tag=teleport,sort=random,limit=1]
execute as @a[tag=3,team=!Tenkai] at @s run kill @e[type=marker,tag=teleport,sort=nearest,limit=1]

execute as @a[tag=4,team=!Tenkai] run tp @s @e[type=marker,tag=teleport,sort=random,limit=1]
execute as @a[tag=4,team=!Tenkai] at @s run kill @e[type=marker,tag=teleport,sort=nearest,limit=1]

execute as @a[tag=5,team=!Tenkai] run tp @s @e[type=marker,tag=teleport,sort=random,limit=1]
execute as @a[tag=5,team=!Tenkai] at @s run kill @e[type=marker,tag=teleport,sort=nearest,limit=1]

execute as @a[tag=6,team=!Tenkai] run tp @s @e[type=marker,tag=teleport,sort=random,limit=1]
execute as @a[tag=6,team=!Tenkai] at @s run kill @e[type=marker,tag=teleport,sort=nearest,limit=1]

execute as @a[tag=7,team=!Tenkai] run tp @s @e[type=marker,tag=teleport,sort=random,limit=1]
execute as @a[tag=7,team=!Tenkai] at @s run kill @e[type=marker,tag=teleport,sort=nearest,limit=1]

execute as @a[tag=8,team=!Tenkai] run tp @s @e[type=marker,tag=teleport,sort=random,limit=1]
execute as @a[tag=8,team=!Tenkai] at @s run kill @e[type=marker,tag=teleport,sort=nearest,limit=1]

execute as @a[tag=9,team=!Tenkai] run tp @s @e[type=marker,tag=teleport,sort=random,limit=1]
execute as @a[tag=9,team=!Tenkai] at @s run kill @e[type=marker,tag=teleport,sort=nearest,limit=1]

execute as @a[tag=10,team=!Tenkai] run tp @s @e[type=marker,tag=teleport,sort=random,limit=1]
execute as @a[tag=10,team=!Tenkai] at @s run kill @e[type=marker,tag=teleport,sort=nearest,limit=1]

execute as @a[tag=11,team=!Tenkai] run tp @s @e[type=marker,tag=teleport,sort=random,limit=1]
execute as @a[tag=11,team=!Tenkai] at @s run kill @e[type=marker,tag=teleport,sort=nearest,limit=1]

execute as @a[tag=12,team=!Tenkai] run tp @s @e[type=marker,tag=teleport,sort=random,limit=1]
execute as @a[tag=12,team=!Tenkai] at @s run kill @e[type=marker,tag=teleport,sort=nearest,limit=1]

execute as @a[tag=13,team=!Tenkai] run tp @s @e[type=marker,tag=teleport,sort=random,limit=1]
execute as @a[tag=13,team=!Tenkai] at @s run kill @e[type=marker,tag=teleport,sort=nearest,limit=1]

kill @e[type=marker,tag=teleport]

#イベント詳細を削除
data modify storage sys: random_event.title set value ''
data modify storage sys: random_event.content.1 set value ''
data modify storage sys: random_event.content.2 set value ''
data modify storage sys: random_event.content.3 set value ''
#ボスバー名を更新
bossbar set time_bossbar name [{"interpret":true,"nbt":"time_text","storage":"sys:"},{"interpret":true,"nbt":"random_event.title","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.1","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.2","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.3","storage":"sys:"}]
