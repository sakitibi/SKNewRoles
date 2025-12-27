#single_chest

#s
execute as @s[type=marker,tag=chest_point,tag=type_single,tag=south] at @s run setblock ~ ~ ~ chest[facing=south]{LootTable:"werewolf:random_event/event_10/chest"}
#w
execute as @s[type=marker,tag=chest_point,tag=type_single,tag=west] at @s run setblock ~ ~ ~ chest[facing=west]{LootTable:"werewolf:random_event/event_10/chest"}
#n
execute as @s[type=marker,tag=chest_point,tag=type_single,tag=north] at @s run setblock ~ ~ ~ chest[facing=north]{LootTable:"werewolf:random_event/event_10/chest"}
#e
execute as @s[type=marker,tag=chest_point,tag=type_single,tag=east] at @s run setblock ~ ~ ~ chest[facing=east]{LootTable:"werewolf:random_event/event_10/chest"}


#double_chest
#s
execute as @s[type=marker,tag=chest_point,tag=type_left_double,tag=south] at @s run setblock ~ ~ ~ chest[type=left,facing=south]
execute as @s[type=marker,tag=chest_point,tag=type_right_double,tag=south] at @s run setblock ~ ~ ~ chest[type=right,facing=south]
#w
execute as @s[type=marker,tag=chest_point,tag=type_left_double,tag=west] at @s run setblock ~ ~ ~ chest[type=left,facing=west]
execute as @s[type=marker,tag=chest_point,tag=type_right_double,tag=west] at @s run setblock ~ ~ ~ chest[type=right,facing=west]

#n
execute as @s[type=marker,tag=chest_point,tag=type_left_double,tag=north] at @s run setblock ~ ~ ~ chest[type=left,facing=north]
execute as @s[type=marker,tag=chest_point,tag=type_right_double,tag=north] at @s run setblock ~ ~ ~ chest[type=right,facing=north]

#e
execute as @s[type=marker,tag=chest_point,tag=type_left_double,tag=east] at @s run setblock ~ ~ ~ chest[type=left,facing=east]
execute as @s[type=marker,tag=chest_point,tag=type_right_double,tag=east] at @s run setblock ~ ~ ~ chest[type=right,facing=east]




