summon marker ~ ~ ~ {Tags:["RNG"]}

execute store result score GameManager rng run data get entity @e[tag=RNG,type=marker,limit=1] UUID[0]

kill @e[type=marker,tag=RNG,sort=nearest,limit=1]

scoreboard players operation GameManager rng %= GameManager .100 