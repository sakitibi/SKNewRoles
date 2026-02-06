scoreboard players random GameManager emerald_give 0 2
title @a title {text:"社長からエメラルドをもらえた！"}
execute if score GameManager emerald_give matches 0 run give @a[tag=player] emerald 1
execute if score GameManager emerald_give matches 1 run give @a[tag=player] emerald 2
execute if score GameManager emerald_give matches 2 run give @a[tag=player] emerald 3
# 仮
execute as @a at @s run playsound minecraft:bake_bread master @a