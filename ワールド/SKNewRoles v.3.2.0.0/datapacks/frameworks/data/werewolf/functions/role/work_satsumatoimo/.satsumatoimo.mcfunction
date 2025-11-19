scoreboard players set @a[team=Satsumatoimo,scores={satsumatoimo_role=0}] satsumatoimo_role 1
scoreboard players set @a[team=Satsumatoimo,scores={satsumatoimo_role=1}] satsumatoimo_role 0

#タグをリセット
tag @a[team=Satsumatoimo] remove camp_green
tag @a[team=Satsumatoimo] remove camp_red

#タグを付与
tag @a[team=Satsumatoimo,scores={satsumatoimo_role=0}] add team_satsumatoimo_c
tag @a[team=Satsumatoimo,scores={satsumatoimo_role=1}] add team_satsumatoimo_m
tag @a[team=Satsumatoimo,scores={satsumatoimo_role=0}] add camp_green
tag @a[team=Satsumatoimo,scores={satsumatoimo_role=1}] add camp_red

#村/第三陣営=1 人狼陣営(狂人除く)=2
# ここは1固定
scoreboard players set @a[team=Satsumatoimo] role 1

#スキルと役職本リセット
item replace entity @a[team=Satsumatoimo] hotbar.7 with air
item replace entity @a[team=Satsumatoimo] hotbar.8 with air

title @a[team=Satsumatoimo] title {text:"陣営が変わったようだ！"}