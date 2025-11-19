# 必要な変数を定義
scoreboard objectives add witchtype dummy
scoreboard objectives add magic1 dummy
scoreboard objectives add magic2 dummy
# 基本処理
effect give @e[scores={witchtype=1}] invisibility 1 255 true
execute if entity @e[type=witch] as @e[type=iron_golem,distance=..30] at @s run effect give @s wither 20 1 true
execute as @e[type=witch,tag=kakusei] run tp @s @e[name=bat,type=bat,limit=1]
execute unless entity @e[scores={magic1=0..100}] at @s run effect give @s instant_health 1 255 true
effect give @e[type=witch] speed infinite 2 true
effect give @e[type=witch] resistance infinite 3 true
kill @e[type=splash_potion]
effect give @e[type=witch] fire_resistance infinite 255 true
effect give @e[type=witch] health_boost infinite 29 true
execute if data storage sys: {time_query:15000} run tag @e[type=witch] add kakusei
execute if data storage sys: {time_query:6000} run tag @e[type=witch] remove kakusei
execute if entity @e[type=witch,tag=] run function magic-and-spells-java:magician/setup
scoreboard players set @e[type=witch,tag=charge] magic1 0
#スケジュール用関数をn秒おきに呼び出し
schedule function magic-and-spells-java:magician/charge 15s append false
schedule function magic-and-spells-java:magician/health 3s append false
schedule function magic-and-spells-java:poison/curse 30s append false
schedule function magic-and-spells-java:poison/curse_kill 60s append false
schedule function magic-and-spells-java:levitation/levitation 180s append false
schedule function magic-and-spells-java:asister/asister 60s append false
schedule function magic-and-spells-java:magician/nokakusei/1 15s append false
schedule function magic-and-spells-java:magician/kakusei/1 15s append false
schedule function magic-and-spells-java:magician/3 15s append false
schedule function magic-and-spells-java:magician/nokakusei/5 15s append false
schedule function magic-and-spells-java:magician/kakusei/5 15s append false
schedule function magic-and-spells-java:magician/nokakusei/7 15s append false
schedule function magic-and-spells-java:magician/kakusei/7 15s append false
function magic-and-spells-java:magician/9
schedule function magic-and-spells-java:magician/11 15s append false
schedule function magic-and-spells-java:magician/nokakusei/13 15s append false
schedule function magic-and-spells-java:magician/kakusei/13 15s append false
schedule function magic-and-spells-java:magician/nokakusei/15 15s append false
schedule function magic-and-spells-java:magician/kakusei/15 15s append false
schedule function magic-and-spells-java:magician/nokakusei/17 15s append false
schedule function magic-and-spells-java:magician/kakusei/17 15s append false
schedule function magic-and-spells-java:magician/kakusei/19 5s append false
schedule function magic-and-spells-java:magician/kakusei/21 15s append false

schedule function magic-and-spells-java:invisibility/nokakusei/1 15s append false
schedule function magic-and-spells-java:invisibility/kakusei/1 15s append false
schedule function magic-and-spells-java:invisibility/3 15s append false
schedule function magic-and-spells-java:invisibility/nokakusei/5 15s append false
schedule function magic-and-spells-java:invisibility/kakusei/5 15s append false
schedule function magic-and-spells-java:invisibility/nokakusei/7 15s append false
schedule function magic-and-spells-java:invisibility/kakusei/7 15s append false
function magic-and-spells-java:invisibility/9
schedule function magic-and-spells-java:invisibility/11 15s append false
schedule function magic-and-spells-java:invisibility/nokakusei/13 15s append false
schedule function magic-and-spells-java:invisibility/kakusei/13 15s append false
schedule function magic-and-spells-java:invisibility/nokakusei/15 15s append false
schedule function magic-and-spells-java:invisibility/kakusei/15 15s append false
schedule function magic-and-spells-java:invisibility/nokakusei/17 15s append false
schedule function magic-and-spells-java:invisibility/kakusei/17 15s append false
schedule function magic-and-spells-java:invisibility/kakusei/19 5s append false
schedule function magic-and-spells-java:invisibility/kakusei/21 15s append false

schedule function magic-and-spells-java:bat/1setup 3s append false
execute if entity @e[type=witch] run schedule function magic-and-spells-java:bat/spawn 120s append false

execute if entity @e[tag=kakusei,scores={magic1=7}] run scoreboard players set @e[tag=kakusei,scores={magic1=9}] magic1 1
execute if entity @e[tag=kakusei,scores={magic1=9}] run scoreboard players set @e[tag=kakusei,scores={magic1=7}] magic1 1
execute if entity @e[tag=kakusei,scores={magic1=19}] run scoreboard players set @e[tag=kakusei,scores={magic1=5}] magic1 17
execute if entity @e[tag=kakusei,scores={magic1=5}] run scoreboard players set @e[tag=kakusei,scores={magic1=19}] magic1 17