execute align xyz positioned ~ ~-1 ~ unless entity @e[type=marker,tag=amc,distance=..0.5] run tellraw @s "オブジェクトを設置しました"
execute align xyz positioned ~ ~-1 ~ if entity @e[type=marker,tag=amc,distance=..0.5] run tellraw @s "既にオブジェクトが設置されています"


execute align xyz positioned ~ ~-1 ~ unless entity @e[type=marker,tag=amc,distance=..0.5] positioned ~ ~1 ~ run function Adv_Map_Creator_data:amc/set_block/farmland
execute align xyz positioned ~ ~-1 ~ unless entity @e[type=marker,tag=amc,distance=..0.5] positioned ~ ~1 ~ run function Adv_Map_Creator_data:amc/set_block/crops/potatoes
execute align xyz positioned ~ ~-1 ~ unless entity @e[type=marker,tag=amc,distance=..0.5] run summon marker ~ ~ ~ {Tags:["amc","potatoes"]}
