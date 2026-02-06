execute as @a[tag=player] at @s run tp @s @e[type=marker,sort=nearest,limit=1]
execute if entity @a[tag=player,predicate=werewolf:is_effects/luck] run schedule function werewolf:role/.role_view_lock 1t
