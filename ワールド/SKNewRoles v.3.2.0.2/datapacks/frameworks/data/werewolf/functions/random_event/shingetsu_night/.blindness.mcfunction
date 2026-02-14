execute as @a[tag=no_jinrou] run schedule function werewolf:.system/.playing/blindness 1t append false
#イベント詳細を削除
data modify storage sys: random_event.title set value ''
data modify storage sys: random_event.content.1 set value ''
data modify storage sys: random_event.content.2 set value ''
data modify storage sys: random_event.content.3 set value ''
#ボスバー名を更新
bossbar set time_bossbar name [{"interpret":true,"nbt":"time_text","storage":"sys:"},{"interpret":true,"nbt":"random_event.title","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.1","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.2","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.3","storage":"sys:"}]
