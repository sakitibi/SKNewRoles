#タスクをセット
#ボタン1
#タスク土台
#execute at @e[type=marker,tag=re_button_1] align xyz run setblock ~ ~ ~ stone
#execute at @e[type=marker,tag=re_button_1] align xyz run summon minecraft:item_display ~0.5 ~1 ~0.5 {item:{id:"minecraft:stone",Count:1b},Tags:["re_button_1","random_event"],transformation:{translation:[-0.00001f,0f,0f],left_rotation:[0.46f,0f,0f,0.888f],scale:[0.999f,0.82f,0.58f],right_rotation:[0f,0f,0f,1f]}}
#タスクボタン[off]
#execute at @e[type=marker,tag=re_button_1] align xyz run summon item_display ~ ~1.5 ~ {item:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{CustomModelData:101}},Tags:["re_button_1","random_event"],transformation:{translation:[1f,0f,0f],left_rotation:[0f,-0.707f,0f,0.707f],scale:[1f,1f,1f],right_rotation:[0f,0f,0f,1f]}}
execute at @e[type=marker,tag=re_button_1] align xyz run summon item_display ~1.5 ~1.5 ~0.5 {item:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{CustomModelData:101}},Tags:["re_button_1","random_event"],transformation:{translation:[0f,0f,0f],left_rotation:[0f,-0.707f,0f,0.707f],scale:[1f,1f,1f],right_rotation:[0f,0f,0f,1f]}}
#クリック判定を追加
#execute at @e[type=marker,tag=re_button_1] align xyz run summon interaction ~0.5 ~2 ~0.5 {width:0.35f,height:0.35f,Tags:["re_button_1","random_event"]}
execute at @e[type=marker,tag=re_button_1] align xyz align xyz positioned ~0.9 ~1.2 ~0.5 run summon minecraft:interaction ~ ~ ~ {Tags:["re_button_1","random_event"],width:0.5f,height:0.65f}

#ボタン2
#タスク土台
#execute at @e[type=marker,tag=re_button_2] align xyz run setblock ~ ~ ~ stone
#execute at @e[type=marker,tag=re_button_2] align xyz run summon minecraft:item_display ~0.5 ~1 ~0.5 {item:{id:"minecraft:stone",Count:1b},Tags:["re_button_2","random_event"],transformation:{translation:[-0.00001f,0f,0f],left_rotation:[0.46f,0f,0f,0.888f],scale:[0.999f,0.82f,0.58f],right_rotation:[0f,0f,0f,1f]}}
#タスクボタン[off]
#execute at @e[type=marker,tag=re_button_2] align xyz run summon item_display ~ ~1.5 ~ {item:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{CustomModelData:101}},Tags:["re_button_2","random_event"]}
execute at @e[type=marker,tag=re_button_2] align xyz run summon item_display ~1.5 ~1.5 ~0.5 {item:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{CustomModelData:101}},Tags:["re_button_2","random_event"],transformation:{translation:[0f,0f,0f],left_rotation:[0f,-0.707f,0f,0.707f],scale:[1f,1f,1f],right_rotation:[0f,0f,0f,1f]}}
#クリック判定を追加
execute at @e[type=marker,tag=re_button_2] align xyz align xyz positioned ~0.9 ~1.2 ~0.5 run summon minecraft:interaction ~ ~ ~ {Tags:["re_button_2","random_event"],width:0.5f,height:0.65f}



#execute align xyz run summon marker ~ ~ ~ {Tags:["random_event","re_button_1"]}
#execute align xyz run summon marker ~ ~ ~ {Tags:["random_event","re_button_2"]}
#execute align xyz run summon marker ~ ~ ~ {Tags:["random_event","spawner"]}

#west
#土台
#execute align xyz run tp @e[type=minecraft:item_display,limit=1,sort=nearest] ~0.5 ~ ~0.5 90 0
#ボタン
#execute align xyz run tp @e[type=minecraft:block_display,limit=1,sort=nearest] ~1 ~ ~ 90 0