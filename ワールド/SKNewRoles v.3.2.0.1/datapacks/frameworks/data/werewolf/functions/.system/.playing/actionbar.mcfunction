#スキルのアナウンス表示
    schedule function werewolf:.system/.playing/skill/announces/mura 1t append false
    schedule function werewolf:.system/.playing/skill/announces/jinrou 1t append false
    schedule function werewolf:.system/.playing/skill/announces/other 1t append false
#墓のアナウンス表示
    execute if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 if data storage sys: {item_phase:0} as @a[predicate=werewolf:look_at/look_at_grave] run schedule function werewolf:.system/grave/grave_announce_meeting 1t append false
    execute if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 if data storage sys: {item_phase:1} as @a[predicate=werewolf:look_at/look_at_grave] run schedule function werewolf:.system/grave/grave_announce 1t append false
    execute if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 1 as @a[predicate=werewolf:look_at/look_at_grave] run schedule function werewolf:.system/grave/grave_announce 1t append false
    execute if data storage sys: meeting{active:0} unless data storage sys: random_event{title:''} as @a[predicate=werewolf:look_at/look_at_grave] run schedule function werewolf:.system/grave/grave_announce 1t append false
    execute if data storage sys: meeting{active:1} as @a[predicate=werewolf:look_at/look_at_grave] run schedule function werewolf:.system/grave/grave_announce 1t append true
#ベントアナウンス表示
    schedule function werewolf:.system/.playing/vent/announce 1t append false
# check_slabのアナウンス
    execute as @a[predicate=werewolf:look_at/look_at_check_slab] run schedule function werewolf:.system/surviver_check_stone_slab/check_slab_announce 1t append false
# 緊急会議ボタンのアナウンス
    execute if data storage sys: meeting{active:0} unless data storage sys: random_event{title:''} as @a[scores={meeting_button=0},predicate=werewolf:look_at/look_at_meeting_button] run title @s actionbar [{"text":"今は緊急会議を招集できない"}]
    execute if data storage sys: meeting{active:0} unless score GameManager can_convence matches 0 as @a[scores={meeting_button=0},predicate=werewolf:look_at/look_at_meeting_button] run title @s actionbar [{"text":"今は緊急会議を招集できない"}]
    execute if data storage sys: meeting{active:0} if data storage sys: {item_phase:1} as @a[scores={meeting_button=0},predicate=werewolf:look_at/look_at_meeting_button] run title @s actionbar [{"text":"今は緊急会議を招集できない"}]
    execute if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 if data storage sys: {item_phase:0} as @a[scores={meeting_button=0},predicate=werewolf:look_at/look_at_meeting_button] run title @s actionbar [{"text":"緊急会議を招集する (\uE501右クリック)"}]
    execute if data storage sys: meeting{active:0} as @a[scores={meeting_button=1},predicate=werewolf:look_at/look_at_meeting_button] run title @s actionbar [{"text":"あなたは既に緊急会議を招集している"}]