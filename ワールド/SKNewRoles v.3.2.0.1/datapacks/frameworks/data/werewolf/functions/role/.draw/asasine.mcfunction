# 村人から人狼にシフト(必ず一人選出)
#アーマースタンドから選択
execute if score アサシン Role_count matches 1 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=1] add selected
execute if score アサシン Role_count matches 2 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=2] add selected
execute if score アサシン Role_count matches 3 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=3] add selected
#各アーマースタンドから最も近いプレイヤーを役職変更
execute as @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!non_player,tag=selected] at @s run team join Asasine @a[team=Mura,limit=1,sort=nearest]
#使い終わったアーマースタンドをキル
kill @e[type=armor_stand,tag=player_dummy,tag=selected]

# FFを有効化
team modify Asasine friendlyFire true
# ネームタグ不可視
team modify Asasine nametagVisibility never
# 透明化不可視
team modify Asasine seeFriendlyInvisibles false
# 死亡ログ非表示
team modify Asasine deathMessageVisibility never
# 結果出力用の役職タグを付与
tag @a[team=Asasine] add team_asasine
# 陣営タグを付与
tag @a[team=Asasine] add camp_red