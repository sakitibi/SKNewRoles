#デスポーンの演出
execute at @e[type=skeleton,tag=event_skeleton] run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a
#デスポーン
tp @e[type=skeleton,tag=event_skeleton] ~ ~-1000 ~
kill @e[type=skeleton,tag=event_skeleton]

tellraw @a {"interpret":true,"nbt":"hit_the_target.announce.end.2","storage":"wolf_data:"}
