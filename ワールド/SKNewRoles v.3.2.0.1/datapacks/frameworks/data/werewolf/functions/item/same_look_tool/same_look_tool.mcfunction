execute unless data storage sys: {item_phase:0} run tellraw @s {"text":"今は使えない。"}

execute if data storage sys: {item_phase:0} run title @a title [{"text":"\uF811\uE204\uF811","font":"announce"}]
execute if data storage sys: {item_phase:0} as @a[team=!Tenkai] run attribute @s minecraft:generic.armor base set -100
execute if data storage sys: {item_phase:0} as @a[team=!Tenkai] run item replace entity @s armor.head with chainmail_helmet{Tags:["same_look_armer"],Enchantments:[{id:"minecraft:binding_curse",lvl:1s},{id:"minecraft:vanishing_curse",lvl:1s}]}
execute if data storage sys: {item_phase:0} as @a[team=!Tenkai] run item replace entity @s armor.chest with chainmail_chestplate{Tags:["same_look_armer"],Enchantments:[{id:"minecraft:binding_curse",lvl:1s},{id:"minecraft:vanishing_curse",lvl:1s}]}
execute if data storage sys: {item_phase:0} as @a[team=!Tenkai] run item replace entity @s armor.legs with chainmail_leggings{Tags:["same_look_armer"],Enchantments:[{id:"minecraft:binding_curse",lvl:1s},{id:"minecraft:vanishing_curse",lvl:1s}]}
execute if data storage sys: {item_phase:0} as @a[team=!Tenkai] run item replace entity @s armor.feet with chainmail_boots{Tags:["same_look_armer"],Enchantments:[{id:"minecraft:binding_curse",lvl:1s},{id:"minecraft:vanishing_curse",lvl:1s}]}
execute if data storage sys: {item_phase:0} run item replace entity @s weapon.mainhand with air
execute if data storage sys: {item_phase:0} run effect give @a[team=!Tenkai] invisibility infinite 0 true
execute if data storage sys: {item_phase:0} run schedule function werewolf:item/same_look_tool/defuse_same_look 30s

execute if data storage sys: {item_phase:0} run data modify storage sys: item_phase set value 1

