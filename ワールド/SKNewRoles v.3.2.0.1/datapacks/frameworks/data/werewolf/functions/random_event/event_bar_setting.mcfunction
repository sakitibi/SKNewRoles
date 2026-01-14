#クエストバーの更新タイミングを計算
scoreboard players operation GameManager event_timer_divide = GameManager event_timer_countdown
scoreboard players operation GameManager event_timer_divide /= GameManager .36
scoreboard players operation GameManager event_timer_update = GameManager event_timer_divide
#クエストバーの状態を設定
data modify storage sys: random_event.bar set value '[{"text":"\\uF811\\uE001\\uF810","font":"quest_bar"}]'
#ボスバー名を更新
bossbar set time_bossbar name [{"interpret":true,"nbt":"bossbar_text","storage":"sys:"}]