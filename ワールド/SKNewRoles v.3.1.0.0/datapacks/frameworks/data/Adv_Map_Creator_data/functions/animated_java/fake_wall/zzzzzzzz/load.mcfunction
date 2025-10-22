scoreboard objectives add aj.i dummy
scoreboard objectives add aj.id dummy
scoreboard objectives add aj.tween_time dummy
scoreboard objectives add aj.anim_time dummy
scoreboard objectives add aj.life_time dummy
scoreboard objectives add aj.fake_wall.export_version dummy
scoreboard objectives add aj.fake_wall.rig_loaded dummy
scoreboard objectives add aj.fake_wall.animation.open.local_anim_time dummy
scoreboard objectives add aj.fake_wall.animation.open.loop_mode dummy
scoreboard players set $aj.fake_wall.animation.open aj.id 0
scoreboard players set $aj.fake_wall.variant.default aj.id 0
scoreboard players add .aj.last_id aj.id 0
scoreboard players set $aj.loop_mode.loop aj.i 0
scoreboard players set $aj.loop_mode.once aj.i 1
scoreboard players set $aj.loop_mode.hold aj.i 2
scoreboard players set aj.fake_wall.export_version aj.i 422355852
scoreboard players reset * aj.fake_wall.rig_loaded
execute as @e[type=minecraft:item_display,tag=aj.fake_wall.root] run function Adv_Map_Creator_data:animated_java/fake_wall/zzzzzzzz/on_load