title @a title [{"text":"\uF811\uE206\uF811","font":"announce"}]
execute unless entity @a[team=Witch] run effect give @a[gamemode=!spectator] glowing 15 0 true
execute if entity @a[team=Witch] run title @a[team=!Witch] title 発光が無効化された
execute if entity @a[team=Witch] run tag @s add glowing_failed
execute if entity @a[team=Witch] run function werewolf:item/glowing_tool_failed
item replace entity @s weapon.mainhand with air