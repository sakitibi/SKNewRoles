execute if entity @a[tag=7] run tellraw @s [{"selector":"@a[tag=7]"},{"text":"を凍結させた"}]
effect give @a[tag=7] slowness 15 255 true
effect give @a[tag=7] poison 15 0 true
effect give @a[tag=7] mining_fatigue 15 255 true
effect give @a[tag=7] weakness 15 255 true
execute as @a[tag=7] run tellraw @s [{"text":"あなたは凍結された","color":"aqua"}]
execute as @a[tag=7,team=Wanashi] run tellraw @s [{"text":"あなたは村人になった。","color":"lime"}]

execute as @a[tag=7,team=Wanashi] run function werewolf:skill/skill_snowgirl/.snowgirl_change_role