#宝箱の場所を指定
execute as @s at @s run summon marker ~ ~ ~ {Tags:["treasure_chest_place","not_yet"]}
#プレイヤーの向きを代入
execute as @s at @s run data modify entity @e[type=marker,sort=nearest,limit=1,tag=treasure_chest_place,tag=not_yet] Rotation[0] set from entity @s Rotation[0]

#処理完了のタグけし
execute as @s at @s run tag @e[type=marker,sort=nearest,limit=1,tag=treasure_chest_place,tag=not_yet] remove not_yet