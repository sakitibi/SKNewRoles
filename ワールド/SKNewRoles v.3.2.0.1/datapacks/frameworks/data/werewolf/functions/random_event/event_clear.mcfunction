#イベント詳細を削除
data modify storage sys: random_event.title set value ''
data modify storage sys: random_event.content.1 set value ''
data modify storage sys: random_event.content.2 set value ''
data modify storage sys: random_event.content.3 set value ''
#イベントバー情報を削除
data remove storage sys: random_event.bar
#ボスバー名を更新
bossbar set time_bossbar name [{"interpret":true,"nbt":"bossbar_text","storage":"sys:"}]
