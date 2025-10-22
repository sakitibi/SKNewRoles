#チャージ時間管理
execute as @a[scores={charge_cupid_arrow=0..}] run scoreboard players add @s charge_cupid_arrow 1
#execute as @a[scores={charge_cupid_arrow=1}] at @s run playsound entity.player.breath master @a ~ ~ ~ 1 1 0.5
#/playsound minecraft:entity.player.breath master @a
#execute as @a[scores={charge_cupid_arrow=1}] run effect give @s slowness 1 3 true
#スキル発動
execute as @a[scores={charge_cupid_arrow=1}] at @s run function werewolf:skill/skill_cupid/main

#チャージ用のスコアボードをリセット
execute as @a[scores={charge_cupid_arrow=10..}] run scoreboard players reset @s charge_cupid_arrow

#再帰
execute if entity @a[scores={charge_cupid_arrow=0..}] run schedule function werewolf:skill/skill_cupid/charge 1t