#single_chest

#s
execute at @e[type=marker,tag=chest_point,tag=type_single,tag=south] run setblock ~ ~ ~ chest[facing=south]
#w
execute at @e[type=marker,tag=chest_point,tag=type_single,tag=west] run setblock ~ ~ ~ chest[facing=west]
#n
execute at @e[type=marker,tag=chest_point,tag=type_single,tag=north] run setblock ~ ~ ~ chest[facing=north]
#e
execute at @e[type=marker,tag=chest_point,tag=type_single,tag=east] run setblock ~ ~ ~ chest[facing=east]


#double_chest
#s
execute at @e[type=marker,tag=chest_point,tag=type_left_double,tag=south] run setblock ~ ~ ~ chest[type=left,facing=south]
execute at @e[type=marker,tag=chest_point,tag=type_right_double,tag=south] run setblock ~ ~ ~ chest[type=right,facing=south]
#w
execute at @e[type=marker,tag=chest_point,tag=type_left_double,tag=west] run setblock ~ ~ ~ chest[type=left,facing=west]
execute at @e[type=marker,tag=chest_point,tag=type_right_double,tag=west] run setblock ~ ~ ~ chest[type=right,facing=west]

#n
execute at @e[type=marker,tag=chest_point,tag=type_left_double,tag=north] run setblock ~ ~ ~ chest[type=left,facing=north]
execute at @e[type=marker,tag=chest_point,tag=type_right_double,tag=north] run setblock ~ ~ ~ chest[type=right,facing=north]

#e
execute at @e[type=marker,tag=chest_point,tag=type_left_double,tag=east] run setblock ~ ~ ~ chest[type=left,facing=east]
execute at @e[type=marker,tag=chest_point,tag=type_right_double,tag=east] run setblock ~ ~ ~ chest[type=right,facing=east]




