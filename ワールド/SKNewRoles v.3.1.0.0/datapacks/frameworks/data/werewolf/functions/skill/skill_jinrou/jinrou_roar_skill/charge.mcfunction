#チャージ時間管理
execute as @a[scores={charge_roar=0..}] run scoreboard players add @s charge_roar 1
execute as @a[scores={charge_roar=1}] at @s run playsound entity.player.breath master @a ~ ~ ~ 1 1 0.5
#/playsound minecraft:entity.player.breath master @a
execute as @a[scores={charge_roar=1}] run effect give @s slowness 1 3 true
#スキル発動
execute as @a[scores={charge_roar=20}] at @s run function werewolf:skill/skill_jinrou/jinrou_roar_skill/main

#チャージ用のスコアボードをリセット
execute as @a[scores={charge_roar=30..}] run scoreboard players reset @s charge_roar

#再帰
execute if entity @a[scores={charge_roar=0..}] run schedule function werewolf:skill/skill_jinrou/jinrou_roar_skill/charge 1t