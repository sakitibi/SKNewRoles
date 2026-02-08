tellraw @s "妖狐が死亡してしまったようだ…"
execute as @s at @s run particle soul_fire_flame ~ ~1 ~ 0.5 0.5 0.5 0 10 force @s
execute as @s at @s run playsound minecraft:entity.blaze.shoot master @s
kill @s