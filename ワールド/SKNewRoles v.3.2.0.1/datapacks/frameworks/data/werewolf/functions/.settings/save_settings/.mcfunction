#一度リストをリセット
data remove storage settings: roles


#Settings(ver)
data modify storage settings: roles append value '[{"text":"Settings ("},{"nbt":"version","storage":"sys:"},{"text":")"},{"text":"\\uF806\\uF806\\uF806\\uF806\\uF803"},{"nbt":"version","storage":"sys:","font":"settings_negative"}]'

#ゲーム時間
data modify storage settings: roles append value '[{"text":"#ゲーム時間\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803"}]'
#　初日の昼: x分
data modify storage settings: roles append value '[{"text":"  初日の昼: "},{"score":{"name":"GameManager","objective":"set_first_daytime_minutes"}},{"text":"分"},{"text":"\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"settings_negative"},{"score":{"name":"GameManager","objective":"set_first_daytime_minutes"},"font":"settings_negative"}]'
#　昼: x分
data modify storage settings: roles append value '[{"text":"  昼: "},{"score":{"name":"GameManager","objective":"set_daytime_minutes"}},{"text":"分","font":"settings4"},{"text":"\\uF806\\uF806\\uF806\\uF806","font":"settings_negative"},{"score":{"name":"GameManager","objective":"set_daytime_minutes"},"font":"settings_negative"}]'
#　夜: x分
data modify storage settings: roles append value '[{"text":"  夜: "},{"score":{"name":"GameManager","objective":"set_nighttime_minutes"}},{"text":"分"},{"text":"\\uF806\\uF806\\uF806\\uF806","font":"settings_negative"},{"score":{"name":"GameManager","objective":"set_nighttime_minutes"},"font":"settings_negative"}]'
#勝敗条件: x
execute if data storage judge_mode: {judge_mode:0} run data modify storage settings: roles append value '[{"text":"#勝利判定: "},{"text":"全滅"},{"text":"\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803","font":"settings_negative"}]'
execute if data storage judge_mode: {judge_mode:1} run data modify storage settings: roles append value '[{"text":"#勝利判定: "},{"text":"同数"},{"text":"\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803","font":"settings_negative"}]'
#ランダムイベント: x
execute if data storage sys: {event_active:0} run data modify storage settings: roles append value '[{"text":"#ランダムクエスト: "},{"text":"オン","color":"green"},{"text":"\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803","font":"settings_negative"}]'
execute if data storage sys: {event_active:1} run data modify storage settings: roles append value '[{"text":"#ランダムクエスト: "},{"text":"オフ","color":"red"},{"text":"\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803","font":"settings_negative"}]'
#採取ポイントの数: x
execute if data storage sys: {task_mode:9} run data modify storage settings: roles append value '[{"text":"#採取ポイントの数: "},{"text":"デフォルト","color":"green"},{"text":"\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803","font":"settings_negative"}]'
execute if data storage sys: {task_mode:0} run data modify storage settings: roles append value '[{"text":"#採取ポイントの数: "},{"text":"少ない","color":"green"},{"text":"\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803","font":"settings_negative"}]'
execute if data storage sys: {task_mode:1} run data modify storage settings: roles append value '[{"text":"#採取ポイントの数: "},{"text":"普通","color":"green"},{"text":"\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803","font":"settings_negative"}]'
execute if data storage sys: {task_mode:2} run data modify storage settings: roles append value '[{"text":"#採取ポイントの数: "},{"text":"多い","color":"green"},{"text":"\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803","font":"settings_negative"}]'
#タスク勝利: x
execute if data storage sys: task_win{active:0} run data modify storage settings: roles append value '[{"text":"#タスク勝利: "},{"text":"オン","color":"green"},{"text":"\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803","font":"settings_negative"}]'
execute if data storage sys: task_win{active:1} run data modify storage settings: roles append value '[{"text":"#タスク勝利: "},{"text":"オフ","color":"red"},{"text":"\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803","font":"settings_negative"}]'
#　納品数: x個
execute if data storage sys: task_win{active:0} run data modify storage settings: roles append value '[{"text":"  エメラルド納品数: "},{"nbt":"task_win.count","storage":"sys:"},{"text":"個"},{"text":"\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"settings_negative"},{"nbt":"task_win.count","storage":"sys:","font":"settings_negative"}]'
execute if data storage sys: task_win{active:1} run data modify storage settings: roles append value '[{"text":"  エメラルド納品数: "},{"text":"-個"},{"text":"\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803","font":"settings_negative"}]'
#緊急会議: x
execute if data storage sys: meeting{active:0} run data modify storage settings: roles append value '[{"text":"#緊急会議: "},{"text":"オン","color":"green"},{"text":"\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803","font":"settings_negative"}]'
execute if data storage sys: meeting{active:1} run data modify storage settings: roles append value '[{"text":"#緊急会議: "},{"text":"オフ","color":"red"},{"text":"\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803","font":"settings_negative"}]'
#　会議時間: x分
execute if data storage sys: meeting{active:0} run data modify storage settings: roles append value '[{"text":"  会議時間: "},{"score":{"name":"GameManager","objective":"set_meeting_time_minutes"}},{"text":"分"},{"text":"\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"settings_negative"},{"score":{"name":"GameManager","objective":"set_meeting_time_minutes"},"font":"settings_negative"}]'
execute if data storage sys: meeting{active:1} run data modify storage settings: roles append value '[{"text":"  会議時間: "},{"text":"-分"},{"text":"\\uF806\\uF806\\uF803\\uF806\\uF806\\uF806\\uF806\\uF806","font":"settings_negative"}]'

#役職スキル設定 [最大回数/回復日数]
data modify storage settings: roles append value '[{"text":"#役職スキル設定"},{"text":"\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803","font":"settings_negative"}]'

#役職をボスバーに記録
function werewolf:.settings/save_settings/bossbar_saved
function werewolf:.settings/save_settings/skill_limits
function werewolf:.settings/save_settings/bossbar_to_lists