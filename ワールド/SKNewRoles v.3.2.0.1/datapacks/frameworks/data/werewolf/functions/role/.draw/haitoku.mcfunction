#乱数の偏り防止のための処理-3

# 村人から背徳者にシフト(妖狐がいる場合のみ選出)
execute if score 背徳者 Role_count matches 1 if entity @a[tag=team_youko] run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=1] add selected
execute if score 背徳者 Role_count matches 2 if entity @a[tag=team_youko] run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=2] add selected
execute if score 背徳者 Role_count matches 3 if entity @a[tag=team_youko] run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=3] add selected
#各アーマースタンドから最も近いプレイヤーを役職変更
execute as @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!non_player,tag=selected] at @s run team join Haitoku @a[team=Mura,limit=1,sort=nearest]
#使い終わったアーマースタンドをキル
kill @e[type=armor_stand,tag=player_dummy,tag=selected]

# FFを有効化
team modify Haitoku friendlyFire true
# ネームタグ不可視
team modify Haitoku nametagVisibility never
# 透明化不可視
team modify Haitoku seeFriendlyInvisibles false
# 死亡ログ非表示
team modify Haitoku deathMessageVisibility never
# 結果出力用の役職タグを付与
tag @a[team=Haitoku] add team_haitoku
# 陣営タグを付与
tag @a[team=Haitoku] add camp_pink