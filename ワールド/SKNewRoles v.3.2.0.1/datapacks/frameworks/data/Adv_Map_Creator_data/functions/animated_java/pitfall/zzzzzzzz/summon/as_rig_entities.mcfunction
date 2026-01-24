scoreboard players operation @s aj.id = .aj.last_id aj.id
tag @s remove aj.new
function #Adv_Map_Creator_data:animated_java/pitfall/on_summon/as_rig_entities
execute if entity @s[tag=aj.pitfall.bone] run function #Adv_Map_Creator_data:animated_java/pitfall/zzzzzzzz/on_summon/as_bones

