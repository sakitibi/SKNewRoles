#アナウンス
tellraw @a {"interpret":true,"nbt":"delivery_emerald.announce.failed.2","storage":"wolf_data:"}
tellraw @s [{"text":"魔女「ヒェーッヒェッヒェッヒェッ、\n村人たちを催眠術で眠らして殺してやりますわ〜\nあなたは眠くな〜る\nあなたは眠くな〜る\nあなたは眠くな〜る\nあなたは眠くな〜る\nこれで眠らせたわ〜」","color":"dark_purple"}]
#イベント失敗のペナルティ
#魔女の催眠術(大量のデバフ,2分)
execute as @s[tag=!witch_curse_protected,team=Yakousei] run effect give @s night_vision 120 255 true
execute as @s[tag=!witch_curse_protected,team=!Hanazonogirl,team=!Yakousei] run effect give @s[tag=!camp_red] blindness 120 255 true
execute as @s[tag=!witch_curse_protected,team=!Hanazonogirl] run effect give @s[tag=!camp_red] slowness 120 255 true
execute as @s[tag=!witch_curse_protected,team=!Hanazonogirl] run effect give @s[tag=!camp_red] weakness 120 2 true
execute as @s[tag=!witch_curse_protected,team=!Hanazonogirl] run effect give @s[tag=!camp_red] miging_fatigue 120 255 true
effect give @a[team=Witch] speed 120 4 true
effect give @a[team=Witch] night_vision 120 255 true
execute as @s[tag=witch_curse_protected,team=Hanazonogirl] run tellraw @a {"interpret":true,"nbt":"delivery_emerald.announce.failed.3","storage":"wolf_data:"}
tag @s[tag=witch_curse_protected] remove witch_curse_protected