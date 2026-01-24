#乱数の偏り防止のための処理-3

# 村人からイビルシーアにシフト(必ず一人選出)
#アーマースタンドから選択
#execute if score イビルシーア Role_count matches 1 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=1] add selected
execute if score イビルシーア Role_count matches 1 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!non_player,tag=!selected,sort=random,limit=1] add selected
#execute if score イビルシーア Role_count matches 2 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=2] add selected
execute if score イビルシーア Role_count matches 2 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!non_player,tag=!selected,sort=random,limit=1] add selected
execute if score イビルシーア Role_count matches 2 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=1] add selected
#execute if score イビルシーア Role_count matches 3 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=3] add selected
execute if score イビルシーア Role_count matches 3 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!non_player,tag=!selected,sort=random,limit=1] add selected
execute if score イビルシーア Role_count matches 3 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=2] add selected
#各アーマースタンドから最も近いプレイヤーを役職変更
execute as @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!non_player,tag=selected] at @s run team join Evilseer @a[team=Mura,limit=1,sort=nearest]
#使い終わったアーマースタンドをキル
kill @e[type=armor_stand,tag=player_dummy,tag=selected]

# FFを有効化
team modify Evilseer friendlyFire true
# ネームタグ不可視
team modify Evilseer nametagVisibility never
# 透明化不可視
team modify Evilseer seeFriendlyInvisibles false
# 死亡ログ非表示
team modify Evilseer deathMessageVisibility never
# 結果出力用の役職タグを付与
tag @a[team=Evilseer] add team_evilseer
# 陣営タグを付与
tag @a[team=Evilseer] add camp_red

execute if data storage seer_madness: {always:true} run scoreboard players set @a[team=Evilseer] seer_madness 1
execute if data storage seer_madness: {always:false} run scoreboard players set @a[team=Evilseer] seer_madness 0