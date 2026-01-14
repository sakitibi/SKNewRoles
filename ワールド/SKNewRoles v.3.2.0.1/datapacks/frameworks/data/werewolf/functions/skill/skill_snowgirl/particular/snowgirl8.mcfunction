execute if entity @a[tag=8] run tellraw @s [{"selector":"@a[tag=8]"},{"text":"を凍結させた"}]
effect give @a[tag=8] slowness 15 255 true
effect give @a[tag=8] poison 15 0 true
effect give @a[tag=8] mining_fatigue 15 255 true
effect give @a[tag=8] weakness 15 255 true
execute as @a[tag=8] run tellraw @s [{"text":"あなたは凍結された","color":"aqua"}]
execute as @a[tag=8,team=Wanashi] run tellraw @s [{"text":"あなたは村人になった。","color":"lime"}]

execute as @a[tag=8,team=Wanashi] run function werewolf:skill/skill_snowgirl/.snowgirl_change_role