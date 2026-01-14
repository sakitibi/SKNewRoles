#タスクボタン切り替え
execute at @e[type=marker,tag=re_button_2] align xyz run data merge entity @e[type=item_display,tag=re_button_2,sort=nearest,limit=1] {item:{tag:{CustomModelData:101}}}
execute at @e[type=marker,tag=re_button_2] align xyz run summon interaction ~0.9 ~1.2 ~0.5 {width:0.5f,height:0.65f,Tags:["re_button_2","random_event"]}
#音を鳴らす
execute as @e[type=marker,tag=re_button_2] at @s run playsound minecraft:block.piston.extend master @a

data modify storage sys: random_event.1.button_2 set value 0