function werewolf:.system/get_rng

execute if score GameManager rng matches 0..75 run give @s emerald 1
execute if score GameManager rng matches 76..94 run give @s emerald 2
execute if score GameManager rng matches 95..99 run give @s emerald 3