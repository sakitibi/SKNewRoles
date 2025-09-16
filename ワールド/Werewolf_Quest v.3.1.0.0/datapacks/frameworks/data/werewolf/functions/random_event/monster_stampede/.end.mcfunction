#デスポーンの演出
execute at @e[type=zombie] run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a
execute at @e[type=witch] run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a
#デスポーン
tp @e[type=zombie] ~ ~-1000 ~
kill @e[type=zombie]
tp @e[type=witch] ~ ~-1000 ~
kill @e[type=witch]
data modify storage sys: monster_stampede set value 1

tellraw @a {"interpret":true,"nbt":"monster_stampede.announce.end.2","storage":"wolf_data:"}