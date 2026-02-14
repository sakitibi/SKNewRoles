scoreboard objectives add marmade_attributes dummy
execute if data storage anattribute: {anattribute: true} run scoreboard players random GameManager marmade_attributes 0 4
execute if data storage anattribute: {anattribute: false} run scoreboard players set GameManager marmade_attributes 0
# 村人からマーメイドにシフト(必ず一人選出)
#アーマースタンドから選択
    execute if score マーメイド Role_count matches 1 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=1] add selected
    execute if score マーメイド Role_count matches 2 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=2] add selected
    execute if score マーメイド Role_count matches 3 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=3] add selected
#各アーマースタンドから最も近いプレイヤーを役職変更
    execute as @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!non_player,tag=selected] at @s run team join Marmade @a[team=Mura,limit=1,sort=nearest]
#使い終わったアーマースタンドをキル
    kill @e[type=armor_stand,tag=player_dummy,tag=selected]
# 各属性持ちのマーメイド
    execute if score GameManager marmade_attributes matches 2 run tag @r[team=Marmade] add SuperMarmade
# FFを有効化
    team modify Marmade friendlyFire true
# ネームタグ不可視
    team modify Marmade nametagVisibility never
# 透明化不可視
    team modify Marmade seeFriendlyInvisibles false
# 死亡ログ非表示
    team modify Marmade deathMessageVisibility never
# 結果出力用の役職タグを付与
    tag @a[team=Marmade] add team_marmade
# 陣営タグを付与
    tag @a[team=Marmade] add camp_green