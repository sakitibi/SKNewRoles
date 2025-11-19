# 共通
#イベントデータをリセット
data remove storage sys: random_event
#イベント詳細をリセット
data modify storage sys: random_event.title set value ''
data modify storage sys: random_event.content.1 set value ''
data modify storage sys: random_event.content.2 set value ''
data modify storage sys: random_event.content.3 set value ''
#制限時間をリセット
execute if data storage sys: {game_phase:9} run scoreboard players reset GameManager event_timer

#個別処理
function werewolf:random_event/event_reset_2