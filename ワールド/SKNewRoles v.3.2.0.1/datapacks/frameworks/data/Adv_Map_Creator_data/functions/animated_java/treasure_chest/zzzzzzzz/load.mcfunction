scoreboard objectives add aj.i dummy
scoreboard objectives add aj.id dummy
scoreboard objectives add aj.tween_time dummy
scoreboard objectives add aj.anim_time dummy
scoreboard objectives add aj.life_time dummy
scoreboard objectives add aj.treasure_chest.export_version dummy
scoreboard objectives add aj.treasure_chest.rig_loaded dummy
scoreboard objectives add aj.treasure_chest.animation.open.local_anim_time dummy
scoreboard objectives add aj.treasure_chest.animation.open.loop_mode dummy
scoreboard players set $aj.treasure_chest.animation.open aj.id 0
scoreboard players set $aj.treasure_chest.variant.default aj.id 0
scoreboard players add .aj.last_id aj.id 0
scoreboard players set $aj.loop_mode.loop aj.i 0
scoreboard players set $aj.loop_mode.once aj.i 1
scoreboard players set $aj.loop_mode.hold aj.i 2
scoreboard players set aj.treasure_chest.export_version aj.i -1299512418
scoreboard players reset * aj.treasure_chest.rig_loaded
execute as @e[type=minecraft:item_display,tag=aj.treasure_chest.root] run function Adv_Map_Creator_data:animated_java/treasure_chest/zzzzzzzz/on_load