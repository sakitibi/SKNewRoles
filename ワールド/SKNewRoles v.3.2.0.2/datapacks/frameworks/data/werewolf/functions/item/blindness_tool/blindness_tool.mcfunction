execute unless data storage sys: {item_phase:0} run tellraw @s {"text":"今は使えない。"}
execute if data storage sys: {item_phase:0} run title @a[team=Jinrou,tag=player] title [{"text":"\uF811\uE202\uF811","font":"announce"}]
execute if data storage sys: {item_phase:0} run title @a[team=Asasine,tag=player] title [{"text":"\uF811\uE202\uF811","font":"announce"}]

execute if data storage sys: {item_phase:0} run title @a[team=!Jinrou,team=!Asasine,team=!Witch,team=!Rimokon,tag=player] title [{"text":"\uF811\uE201\uF811","font":"announce"}]

# Witch居ない時のエフェクト付与
execute unless entity @a[team=Witch] if data storage sys: {item_phase:0} run effect give @a[team=!Jinrou,team=!Asasine,team=!Witch,team=!Rimokon,team=!Tenkai,team=!Fusanka] blindness 10 0 true
execute unless entity @a[team=Witch] if data storage sys: {item_phase:0} run effect give @a[team=Yakousei] night_vision 10 0 true
# Witch居る時のエフェクト付与
execute if entity @a[team=Witch] if data storage sys: {item_phase:0} run effect give @a[team=!Jinrou,team=!Asasine,team=!Witch,team=!Rimokon,team=!Tenkai,team=!Fusanka] blindness 30 255 true
execute if entity @a[team=Witch] if data storage sys: {item_phase:0} run effect give @a[team=Yakousei] night_vision 30 255 true
execute if data storage sys: {witch_weakness:false} if entity @a[team=Witch] if data storage sys: {item_phase:0} run effect give @a[team=!Jinrou,team=!Asasine,team=!Witch,team=!Rimokon,team=!Tenkai,team=!Fusanka] slowness 30 1 true
execute if data storage sys: {witch_weakness:false} if entity @a[team=Witch] if data storage sys: {item_phase:0} run effect give @a[team=!Jinrou,team=!Asasine,team=!Witch,team=!Rimokon,team=!Tenkai,team=!Fusanka] wither 30 0 true
execute if data storage sys: {witch_weakness:false} if entity @a[team=Witch] if data storage sys: {item_phase:0} run effect give @a[team=Jinrou,team=Asasine,team=Witch,team=Rimokon,team=!Tenkai,team=!Fusanka] regeneration 30 1 true
execute if data storage sys: {witch_weakness:false} if entity @a[team=Witch] if data storage sys: {item_phase:0} run effect give @a[team=Jinrou,team=Asasine,team=Witch,team=Rimokon,team=!Tenkai,team=!Fusanka] night_vision 30 255 true
execute if data storage sys: {witch_weakness:false} if entity @a[team=Witch] if data storage sys: {item_phase:0} run effect give @a[team=Witch,team=!Tenkai,team=!Fusanka] resistance 30 4 true
execute if data storage sys: {witch_weakness:true} if entity @a[team=Witch,tag=Sorceress] if data storage sys: {item_phase:0} run effect give @a[team=!Jinrou,team=!Asasine,team=!Witch,team=!Rimokon,team=!Tenkai,team=!Fusanka] slowness 30 1 true
execute if data storage sys: {witch_weakness:true} if entity @a[team=Witch,tag=Sorceress] if data storage sys: {item_phase:0} run effect give @a[team=!Jinrou,team=!Asasine,team=!Witch,team=!Rimokon,team=!Tenkai,team=!Fusanka] wither 30 0 true
execute if data storage sys: {witch_weakness:true} if entity @a[team=Witch,tag=Sorceress] if data storage sys: {item_phase:0} run effect give @a[team=Jinrou,team=Asasine,team=Witch,team=Rimokon,team=!Tenkai,team=!Fusanka] regeneration 30 1 true
execute if data storage sys: {witch_weakness:true} if entity @a[team=Witch,tag=Sorceress] if data storage sys: {item_phase:0} run effect give @a[team=Jinrou,team=Asasine,team=Witch,team=Rimokon,team=!Tenkai,team=!Fusanka] night_vision 30 255 true
execute if data storage sys: {witch_weakness:true} if entity @a[team=Witch,tag=Sorceress] if data storage sys: {item_phase:0} run effect give @a[team=Witch,team=!Tenkai,team=!Fusanka] resistance 30 4 true

execute if data storage sys: {item_phase:0} run item replace entity @s weapon.mainhand with air

execute if data storage sys: {item_phase:0} run schedule function werewolf:item/blindness_tool/defuse_blindness 10s

execute if data storage sys: {item_phase:0} run data modify storage sys: item_phase set value 1