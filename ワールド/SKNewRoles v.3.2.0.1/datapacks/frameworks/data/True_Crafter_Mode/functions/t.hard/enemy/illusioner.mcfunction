
#段差飛び越え
execute if entity @s[tag=ChuzOnGround] run function True_Crafter_Mode:t.hard/enemy/common/jump_gap/tick

#ドア破壊、ただしオプションで封じられてる場合を除く
execute if score #t.hard_Gamerule T.HardGamerule1 matches 1 run function True_Crafter_Mode:t.hard/enemy/common/break_door

#水の中ですいすい
execute if entity @a[distance=..30,tag=!T.HardException] if entity @s[nbt={HurtTime:0s}] if block ~ ~0.5 ~ #True_Crafter_Mode:t.hard/liquid run function True_Crafter_Mode:t.hard/enemy/common/swim