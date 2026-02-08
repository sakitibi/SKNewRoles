scoreboard objectives add blacksnowgirl_sorceress dummy # 黒雪少女版の強化属性
execute if data storage anattribute: {anattribute: true} run scoreboard players random GameManager blacksnowgirl_sorceress 0 4
execute if data storage anattribute: {anattribute: false} run scoreboard players set GameManager blacksnowgirl_sorceress 0
# 村人から黒雪少女にシフト(必ず一人選出)
#アーマースタンドから選択
    execute if score 黒雪少女 Role_count matches 1 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=1] add selected
    execute if score 黒雪少女 Role_count matches 2 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=2] add selected
    execute if score 黒雪少女 Role_count matches 3 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=3] add selected
#各アーマースタンドから最も近いプレイヤーを役職変更
    execute as @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!non_player,tag=selected] at @s run team join Blacksnowgirl @a[team=Mura,limit=1,sort=nearest]
#使い終わったアーマースタンドをキル
    kill @e[type=armor_stand,tag=player_dummy,tag=selected]
# 各属性持ちの黒雪少女
execute if score GameManager blacksnowgirl_sorceress matches 4 run tag @r[team=Blacksnowgirl] add BlacksnowgirlSorceress
# FFを有効化
    team modify Blacksnowgirl friendlyFire true
# ネームタグ不可視
    team modify Blacksnowgirl nametagVisibility never
# 透明化不可視
    team modify Blacksnowgirl seeFriendlyInvisibles false
# 死亡ログ非表示
    team modify Blacksnowgirl deathMessageVisibility never
# 結果出力用の役職タグを付与
    tag @a[team=Blacksnowgirl] add team_blacksnowgirl
# 陣営タグを付与
    tag @a[team=Blacksnowgirl] add camp_red