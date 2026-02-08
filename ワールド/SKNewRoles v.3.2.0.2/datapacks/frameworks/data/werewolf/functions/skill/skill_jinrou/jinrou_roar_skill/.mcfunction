#チャージ
#通常
execute as @a[team=Jinrou,scores={charge_roar=0..}] run function werewolf:skill/skill_jinrou/jinrou_roar_skill/charge
#当たり判定処理
#execute if entity @e[type=item,tag=roar] at @e[type=item,tag=roar] positioned ~-0.3 ~ ~-0.3 as @e[tag=!roar,dx=0] unless score @s charge_roar matches 0.. positioned ~-0.3 ~-0.3 ~-0.3 if entity @s[dx=0] positioned ~0.3 ~0.3 ~0.3 run tag @s add hit_roar
execute if entity @e[type=item,tag=roar] at @e[type=item,tag=roar] as @e[tag=!roar,tag=!no_collision,type=!#werewolf:no_shield,distance=..2] unless score @s charge_roar matches 0.. run tag @s add hit_roar
execute if entity @e[type=item,tag=roar] as @e[tag=hit_roar] at @s run kill @e[type=item,tag=roar,sort=nearest,limit=1]
execute as @e[tag=hit_roar] at @s run function werewolf:skill/skill_jinrou/jinrou_roar_skill/damage
#壁や床に当たったら消滅
execute as @e[type=item,tag=roar] run function werewolf:skill/skill_jinrou/jinrou_roar_skill/bounce
#パーティクルの表示
execute if entity @e[type=item,tag=roar] at @e[type=item,tag=roar] run particle sonic_boom 
 
#ポンコツ
execute as @a[team=Ponkotsu,scores={charge_roar=0..}] run function werewolf:skill/skill_jinrou/jinrou_roar_skill/charge_dummy
#当たり判定処理
execute if entity @e[type=item,tag=roar_dummy] at @e[type=item,tag=roar_dummy] as @e[tag=!roar_dummy,tag=!no_collision,type=!#werewolf:no_shield,distance=..2] unless score @s charge_roar matches 0.. run kill @e[type=item,tag=roar_dummy,sort=nearest,limit=1]
#壁や床に当たったら消滅
execute as @e[type=item,tag=roar_dummy] run function werewolf:skill/skill_jinrou/jinrou_roar_skill/bounce_dummy
#パーティクルの表示
execute if entity @e[type=item,tag=roar_dummy] as @e[type=item,tag=roar_dummy] at @s on origin run particle minecraft:sonic_boom ~ ~ ~ 0 0 0 0 1 force @s
execute if entity @e[type=item,tag=roar_dummy] at @e[type=item,tag=roar_dummy] run particle minecraft:sonic_boom ~ ~ ~ 0 0 0 0 1 force @a[tag=!player]