# クエストを強制終了
#イベント詳細をリセット
data modify storage sys: random_event.title set value ''
data modify storage sys: random_event.content.1 set value ''
data modify storage sys: random_event.content.2 set value ''
data modify storage sys: random_event.content.3 set value ''
data modify storage sys: random_event.content.4 set value ''
data modify storage sys: random_event.bar set value '[{"text":"","font":"quest_bar"}]'
#ボスバー名を更新
bossbar set time_bossbar name [{"interpret":true,"nbt":"bossbar_text","storage":"sys:"}]

data modify storage sys: random_event.1.active set value 9
data modify storage sys: random_event.2.active set value 9
data modify storage sys: random_event.3.active set value 9
data modify storage sys: random_event.4.active set value 9
data modify storage sys: random_event.5.active set value 9
data modify storage sys: random_event.6.active set value 9
data modify storage sys: random_event.7.active set value 9
data modify storage sys: random_event.8.active set value 9
data modify storage sys: random_event.9.active set value 9
data modify storage sys: random_event.10.active set value 9
data modify storage sys: random_event.11.active set value 9
data modify storage sys: random_event.12.active set value 9
data modify storage sys: random_event.13.active set value 9
data modify storage sys: random_event.14.active set value 9

function werewolf:random_event/event_reset_2

# 全員にアナウンス
tellraw @a {"text":"オポチュニストの鶴の一声でクエストが完了した。","color":"white"}
execute as @a at @s run playsound minecraft:whistle master @s