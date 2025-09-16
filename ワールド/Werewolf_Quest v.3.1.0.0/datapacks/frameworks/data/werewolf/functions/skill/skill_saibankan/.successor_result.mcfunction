# 緊急裁判ボタンのアナウンス
execute unless data storage sys: random_event{title:''} as @s[scores={meeting_button=0},predicate=werewolf:look_at/look_at_meeting_button] run title @s actionbar [{"text":"今は緊急裁判を招集できない"}]
execute if data storage sys: {item_phase:1} as @s[scores={meeting_button=0},predicate=werewolf:look_at/look_at_meeting_button] run title @s actionbar [{"text":"今は緊急裁判を招集できない"}]
execute if data storage sys: random_event{title:''} if data storage sys: {item_phase:0} as @s[scores={meeting_button=0},predicate=werewolf:look_at/look_at_meeting_button] run title @s actionbar [{"text":"緊急裁判を招集する (\uE501右クリック)"}]
execute as @s[scores={meeting_button=1},predicate=werewolf:look_at/look_at_meeting_button] run title @s actionbar [{"text":"あなたは既に緊急裁判を招集している"}]