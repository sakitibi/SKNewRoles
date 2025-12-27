scoreboard players remove @a[scores={poisoner_timelimit=1..10}] poisoner_timelimit 1
damage @a[scores={poisoner_timelimit=0}] 0.01
execute if entity @a[scores={poisoner_timelimit=0}] run schedule function werewolf:item/blindness_tool/blindness_tool
scoreboard players reset @a[scores={poisoner_timelimit=0}] poisoner_timelimit