# No1
execute if entity @a[scores={warlock_curse=1200..}] at @s run effect give @s slowness 1 0 true
execute if entity @a[scores={warlock_curse=1200}] at @s run effect give @s hunger 15 0 true
# No2
execute if entity @a[scores={warlock_curse=1800}] at @s run effect give @s mining_fatigue 15 0 true
execute if entity @a[scores={warlock_curse=1800..}] at @s run effect give @s slowness 1 1 true
execute if entity @a[scores={warlock_curse=1800..}] at @s run effect give @s weakness 1 1 true
execute if entity @a[scores={warlock_curse=1800..}] at @s run tag @a[tag=no_jinrou,tag=!warlock_curse,distance=..3] add warlock_curse
execute if entity @a[scores={warlock_curse=1800..}] run execute at @a[tag=no_jinrou,tag=!warlock_curse,distance=..3] at @s run title @a[team=Witch] title {"text":"誰かが魔女の魔法にかかったようだ!","color":"red"}
# No3
execute if entity @a[scores={warlock_curse=2400..}] at @s run effect give @s darkness 1 255 true
execute if entity @a[scores={warlock_curse=2400..}] at @s run effect give @s slowness 1 3 true
execute if entity @a[scores={warlock_curse=2400..}] at @s run effect give @s hunger 1 2 true
execute if entity @a[scores={warlock_curse=2400..}] at @s run effect give @s weakness 1 2 true
execute if entity @a[scores={warlock_curse=2400..}] at @s run effect give @s mining_fatigue 1 2 true
# No4
execute if entity @a[scores={warlock_curse=3000..}] at @s run effect give @s poison 1 0 true
execute if entity @a[scores={warlock_curse=3000..}] at @s run effect give @s darkness 1 255 true
execute if entity @a[scores={warlock_curse=3000..}] at @s run effect give @s slowness 1 6 true
execute if entity @a[scores={warlock_curse=3000..}] at @s run effect give @s hunger 1 4 true
execute if entity @a[scores={warlock_curse=3000..}] at @s run effect give @s weakness 1 4 true
execute if entity @a[scores={warlock_curse=3000..}] at @s run effect give @s mining_fatigue 1 4 true
execute if entity @a[scores={warlock_curse=3000..}] at @s run effect give @s blindness 1 255 true
execute if entity @a[scores={warlock_curse=3000..}] at @s run effect give @s nausea 1 255 true
execute if data storage sys: {lang:ja} if entity @a[scores={warlock_curse=3000}] at @s run title @s title {"text":"あなたはすでに魔女に魔法をかけられていた!","color":"red"}
execute if data storage sys: {lang:ru} if entity @a[scores={warlock_curse=3000}] at @s run title @s title {"text":"Ты уже был очарован ведьмой!","color":"red"}
# No5
execute if entity @a[scores={warlock_curse=3600..}] at @s run damage @s 0.01 magic by @a[team=Witch,tag=Warlock,limit=1]
execute if data storage sys: {lang:ja} if entity @a[scores={warlock_curse=3600..}] at @s run title @a[team=Witch,tag=Warlock,limit=1] title [{"text":"あなたは魔法で","color":"red"},{"selector":"@s","color":"red"},{"text":"を倒した!","color":"red"}]
execute if data storage sys: {lang:ru} if entity @a[scores={warlock_curse=3600..}] at @s run title @a[team=Witch,tag=Warlock,limit=1] title [{"text":"Ты волшебник","color":"red"},{"selector":"@s","color":"red"},{"text":"Побежден!","color":"red"}]