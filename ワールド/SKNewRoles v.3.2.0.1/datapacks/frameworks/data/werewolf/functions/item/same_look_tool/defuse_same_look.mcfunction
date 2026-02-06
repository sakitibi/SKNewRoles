title @a title [{"text":"\uF811\uE205\uF811","font":"announce"}]
#item replace entity @a armor.head with air
#item replace entity @a armor.chest with air
#item replace entity @a armor.legs with air
#item replace entity @a armor.feet with air

clear @a chainmail_helmet{Tags:["same_look_armer"]}
clear @a chainmail_chestplate{Tags:["same_look_armer"]}
clear @a chainmail_leggings{Tags:["same_look_armer"]}
clear @a chainmail_boots{Tags:["same_look_armer"]}

attribute @s minecraft:generic.armor base set 0

effect clear @a invisibility

data modify storage sys: item_phase set value 0