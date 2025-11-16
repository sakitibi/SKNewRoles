#ヒットタグを削除
tag @s remove hit_roar
#ダメージ元を召喚
summon area_effect_cloud ~ ~ ~ {Tags:["roar"]}
#ダメージ処理
execute as @s run schedule function werewolf:skill/skill_sniper/poison_exec 15s append true
damage @s 0.01 fall by @e[type=area_effect_cloud,tag=roar,limit=1]
#演出
particle minecraft:explosion ~ ~1 ~ 1 1 1 0 3 force @a[team=Cupid]