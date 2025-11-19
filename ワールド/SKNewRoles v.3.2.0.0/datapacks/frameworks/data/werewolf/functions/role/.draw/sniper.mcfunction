scoreboard objectives add sniper_attribute dummy
execute if data storage anattribute: {anattribute: true} run scoreboard players random GameManager sniper_attribute 0 2
execute if data storage anattribute: {anattribute: false} run scoreboard players set GameManager sniper_attribute 0
#乱数の偏り防止のための処理-3

# 村人からスナイパーにシフト(必ず一人選出)
#アーマースタンドから選択
#execute if score スナイパー Role_count matches 1 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=1] add selected
execute if score スナイパー Role_count matches 1 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!non_player,tag=!selected,sort=random,limit=1] add selected
#execute if score スナイパー Role_count matches 2 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=2] add selected
execute if score スナイパー Role_count matches 2 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!non_player,tag=!selected,sort=random,limit=1] add selected
execute if score スナイパー Role_count matches 2 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=1] add selected
#execute if score スナイパー Role_count matches 3 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=3] add selected
execute if score スナイパー Role_count matches 3 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!non_player,tag=!selected,sort=random,limit=1] add selected
execute if score スナイパー Role_count matches 3 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=2] add selected
#各アーマースタンドから最も近いプレイヤーを役職変更
execute as @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!non_player,tag=selected] at @s run team join Sniper @a[team=Mura,limit=1,sort=nearest]
#使い終わったアーマースタンドをキル
kill @e[type=armor_stand,tag=player_dummy,tag=selected]

# FFを有効化
team modify Sniper friendlyFire true
# ネームタグ不可視
team modify Sniper nametagVisibility never
# 透明化不可視
team modify Sniper seeFriendlyInvisibles false
# 死亡ログ非表示
team modify Sniper deathMessageVisibility never
# 結果出力用の役職タグを付与
execute if score GameManager sniper_attribute matches 2 run tag @a[team=Sniper] add poisoner
tag @a[team=Sniper] add team_sniper
# 陣営タグを付与
tag @a[team=Sniper] add camp_red