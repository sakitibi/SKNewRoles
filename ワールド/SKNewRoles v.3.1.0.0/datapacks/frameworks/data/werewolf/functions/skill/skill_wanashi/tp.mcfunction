#tpの向きをプレイヤーに合わせる
execute as @a[scores={fall_into_a_pitfall=2..95}] at @s run data modify entity @e[type=marker,tag=pitfall_tp,limit=1,sort=nearest] Rotation set from entity @s Rotation
execute as @a[scores={fall_into_a_pitfall=2..}] at @s run tp @s @e[type=marker,tag=pitfall_tp,limit=1,sort=nearest] 
execute as @a[scores={fall_into_a_pitfall=1}] at @s at @e[type=marker,tag=pitfall_tp,limit=1,sort=nearest] run tp ~ ~1.5 ~

execute as @a[scores={fall_into_a_pitfall=1}] at @s run kill @e[type=marker,tag=pitfall_tp,limit=1,sort=nearest]

execute as @a[scores={fall_into_a_pitfall=1..}] run scoreboard players remove @s fall_into_a_pitfall 1