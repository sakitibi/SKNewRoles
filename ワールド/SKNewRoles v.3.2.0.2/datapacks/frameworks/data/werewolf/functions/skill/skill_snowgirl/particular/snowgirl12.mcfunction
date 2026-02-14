execute if entity @a[tag=12] run tellraw @s [{"selector":"@a[tag=12]"},{"text":"を凍結させた"}]
effect give @a[tag=12] slowness 15 255 true
effect give @a[tag=12] poison 15 0 true
effect give @a[tag=12] mining_fatigue 15 255 true
effect give @a[tag=12] weakness 15 255 true
execute as @a[tag=12] run tellraw @s [{"text":"あなたは凍結された","color":"aqua"}]
execute as @a[tag=12,team=Wanashi] run tellraw @s [{"text":"あなたは村人になった。","color":"lime"}]

execute as @a[tag=12,team=Wanashi] run function werewolf:skill/skill_snowgirl/.snowgirl_change_role