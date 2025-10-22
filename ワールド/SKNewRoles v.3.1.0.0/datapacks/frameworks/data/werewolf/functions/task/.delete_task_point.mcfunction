# 削除
execute align xyz if entity @e[type=marker,tag=task_point,distance=..0.5,limit=1,sort=nearest] run tellraw @p {"text":"タスクマーカーを削除しました。"}
execute align xyz unless entity @e[type=marker,tag=task_point,distance=..0.5,limit=1,sort=nearest] run tellraw @p {"text":"周辺にタスクマーカーが存在しません。"}
#PlayerHeadを削除
execute align xyz at @e[type=marker,tag=task_point,distance=..0.5,limit=1,sort=nearest] run setblock ~ ~ ~ air replace
#Makerを削除
execute align xyz run kill @e[type=marker,tag=task_point,distance=..0.5,limit=1,sort=nearest]
