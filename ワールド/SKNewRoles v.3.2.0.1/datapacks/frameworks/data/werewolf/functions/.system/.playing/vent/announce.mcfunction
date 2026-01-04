#ポンコツ狼無し
execute unless score ポンコツ Role_count matches 1.. as @a[tag=can_use_vent] at @s if entity @e[distance=..1,tag=vent] run title @s actionbar [{"text":"転移の炎に入る (役職本を持って\uE500長押し)"}]
execute if score ポンコツ Role_count matches 1.. if data storage sys: {ponkotsu_mode:1} as @a[tag=can_use_vent] at @s if entity @e[distance=..1,tag=vent] run title @s actionbar [{"text":"転移の炎に入る (役職本を持って\uE500長押し)"}]
execute unless score ポンコツ Role_count matches 1.. as @a[tag=!can_use_vent] at @s if entity @e[distance=..1,tag=vent] run title @s actionbar [{"text":"転移の炎 (あなたには使えない)"}]
execute if score ポンコツ Role_count matches 1.. if data storage sys: {ponkotsu_mode:1} as @a[tag=!can_use_vent] at @s if entity @e[distance=..1,tag=vent] run title @s actionbar [{"text":"転移の炎 (あなたには使えない)"}]
#ポンコツ狼あり
execute if score ポンコツ Role_count matches 1.. if data storage sys: {ponkotsu_mode:0} as @a at @s if entity @e[distance=..1,tag=vent] run title @s actionbar [{"text":"転移の炎 (今は封印されている)"}]