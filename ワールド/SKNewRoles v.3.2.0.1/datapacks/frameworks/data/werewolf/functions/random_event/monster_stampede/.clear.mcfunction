#イベントの終了フラグ
data modify storage sys: random_event.1.active set value 0
#発光を消灯
execute at @e[type=marker,tag=re_button_1] align xyz run data merge entity @e[type=item_display,tag=re_button_1,sort=nearest,limit=1] {Glowing:false}
execute at @e[type=marker,tag=re_button_2] align xyz run data merge entity @e[type=item_display,tag=re_button_2,sort=nearest,limit=1] {Glowing:false}

function werewolf:random_event/monster_stampede/gate_anim/.close_main


#イベント詳細を削除
#data modify storage sys: random_event.title set value ''
#data modify storage sys: random_event.content.1 set value ''
#data modify storage sys: random_event.content.2 set value ''
#data modify storage sys: random_event.content.3 set value ''
#ボスバー名を更新
#bossbar set time_bossbar name [{"interpret":true,"nbt":"time_text","storage":"sys:"},{"interpret":true,"nbt":"random_event.title","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.1","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.2","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.3","storage":"sys:"}]
