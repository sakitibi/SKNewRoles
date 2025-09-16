#チャージ
execute as @a[team=Sniper,scores={charge_roar=0..}] run function werewolf:skill/skill_sniper/charge
#当たり判定処理
#execute if entity @e[type=item,tag=roar] at @e[type=item,tag=roar] positioned ~-0.3 ~ ~-0.3 as @e[tag=!roar,dx=0] unless score @s charge_roar matches 0.. positioned ~-0.3 ~-0.3 ~-0.3 if entity @s[dx=0] positioned ~0.3 ~0.3 ~0.3 run tag @s add hit_roar
execute if entity @e[type=item,tag=roar] at @e[type=item,tag=roar] as @e[tag=!roar,tag=!no_collision,type=!#werewolf:no_shield,distance=..2] unless score @s charge_roar matches 0.. run tag @s add hit_roar
execute if entity @e[type=item,tag=roar] as @e[tag=hit_roar] at @s run kill @e[type=item,tag=roar,sort=nearest,limit=1]
execute unless entity @a[tag=poisoner] as @e[tag=hit_roar] at @s run function werewolf:skill/skill_sniper/damage
execute if entity @a[tag=poisoner] as @e[tag=hit_roar] at @s run function werewolf:skill/skill_sniper/poison
#壁や床に当たったら消滅
execute as @e[type=item,tag=roar] run function werewolf:skill/skill_sniper/bounce
#パーティクルの表示
execute if entity @e[type=item,tag=roar] as @e[type=item,tag=roar] at @s on origin run particle minecraft:sonic_boom ~ ~ ~ 0 0 0 0 1 force @s
execute if entity @e[type=item,tag=roar] at @e[type=item,tag=roar] run particle minecraft:sonic_boom ~ ~ ~ 0 0 0 0 1 force @a[tag=!player]