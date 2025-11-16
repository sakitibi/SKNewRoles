#乱数の偏り防止のための処理-3

# 村人からサイドキックにシフト(妖狐がいる場合のみ選出)
execute if score サイドキック Role_count matches 1 if entity @a[tag=team_jackal] run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=1] add selected
execute if score サイドキック Role_count matches 2 if entity @a[tag=team_jackal] run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=2] add selected
execute if score サイドキック Role_count matches 3 if entity @a[tag=team_jackal] run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=3] add selected
#各アーマースタンドから最も近いプレイヤーを役職変更
execute as @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!non_player,tag=selected] at @s run team join Sidekick @a[team=Mura,limit=1,sort=nearest]
#使い終わったアーマースタンドをキル
kill @e[type=armor_stand,tag=player_dummy,tag=selected]

# FFを有効化
team modify Sidekick friendlyFire true
# ネームタグ不可視
team modify Sidekick nametagVisibility never
# 透明化不可視
team modify Sidekick seeFriendlyInvisibles false
# 死亡ログ非表示
team modify Sidekick deathMessageVisibility never
# 結果出力用の役職タグを付与
tag @a[team=Sidekick] add team_sidekick
# 陣営タグを付与
tag @a[team=Sidekick] add camp_pink