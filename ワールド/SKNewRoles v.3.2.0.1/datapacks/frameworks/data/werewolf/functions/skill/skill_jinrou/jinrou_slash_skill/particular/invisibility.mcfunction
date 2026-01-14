particle minecraft:end_rod ~ ~0.5 ~ 0 0 0 0.2 8
playsound minecraft:entity.experience_orb.pickup master @a ~ ~ ~ 1.0 1 0.0
effect give @s[team=Asasine] minecraft:invisibility 10 0 true
tellraw @s "あなたは透明化した。"