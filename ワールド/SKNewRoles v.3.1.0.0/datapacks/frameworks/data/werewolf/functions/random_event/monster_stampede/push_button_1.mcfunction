#タスクボタン切り替え
execute at @e[type=marker,tag=re_button_1] align xyz run data merge entity @e[type=item_display,tag=re_button_1,sort=nearest,limit=1] {item:{tag:{CustomModelData:102}}}
execute at @e[type=interaction,tag=re_button_1] align xyz run kill @e[type=interaction,distance=..2,tag=re_button_1,tag=random_event]
#音を鳴らす
execute as @e[type=marker,tag=re_button_1] at @s run playsound minecraft:block.piston.contract master @a
data modify storage sys: random_event.1.button_1 set value 1
schedule function werewolf:random_event/monster_stampede/off_button_1 1s
advancement revoke @s only werewolf:random_event/event_1/button_1