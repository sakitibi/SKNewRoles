scoreboard objectives add sorceress dummy
execute if data storage anattribute: {anattribute: true} run scoreboard players random GameManager sorceress 0 4
execute if data storage anattribute: {anattribute: false} run scoreboard players set GameManager sorceress 0
# 村人からWitchにシフト(必ず一人選出)
#アーマースタンドから選択
#execute if score Witch Role_count matches 1 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=1] add selected
execute if score Witch Role_count matches 1 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!non_player,tag=!selected,sort=random,limit=1] add selected
#execute if score Witch Role_count matches 2 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=2] add selected
execute if score Witch Role_count matches 2 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!non_player,tag=!selected,sort=random,limit=1] add selected
execute if score Witch Role_count matches 2 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=1] add selected
#execute if score Witch Role_count matches 3 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=3] add selected
execute if score Witch Role_count matches 3 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!non_player,tag=!selected,sort=random,limit=1] add selected
execute if score Witch Role_count matches 3 run tag @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!selected,sort=random,limit=2] add selected
#各アーマースタンドから最も近いプレイヤーを役職変更
execute as @e[team=Mura,type=armor_stand,tag=player_dummy,tag=!non_player,tag=selected] at @s run team join Witch @a[team=Mura,limit=1,sort=nearest]
#使い終わったアーマースタンドをキル
kill @e[type=armor_stand,tag=player_dummy,tag=selected]
# 各属性持ちの魔女
execute if score GameManager sorceress matches 4 run tag @r[team=Witch] add Warlock
execute if score GameManager sorceress matches 3 run tag @r[team=Witch] add Sorceress
execute if score GameManager sorceress matches 2 run tag @r[team=Witch] add Enchantress
tag @a[team=Witch,tag=!Sorceress,tag=!Enchantress,tag=!Warlock] add CommonWitchness # どの属性でも無い普通の魔女
# FFを有効化
team modify Witch friendlyFire true
# ネームタグ不可視
team modify Witch nametagVisibility never
# 透明化不可視
team modify Witch seeFriendlyInvisibles false
# 死亡ログ非表示
team modify Witch deathMessageVisibility never
# 結果出力用の役職タグを付与
tag @a[team=Witch,tag=Warlock,tag=!Sorceress,tag=!Enchantress] add team_warlock
tag @a[team=Witch,tag=!Sorceress,tag=!Enchantress,tag=!Warlock] add team_witch
tag @a[team=Witch,tag=Sorceress,tag=!Enchantress,tag=!Warlock] add team_sorceress
tag @a[team=Witch,tag=Enchantress,tag=!Sorceress,tag=!Warlock] add team_enchantress
# 陣営タグを付与
tag @a[team=Witch] add camp_red
tag @a[tag=team_sorceress] remove team_witch
tag @a[tag=team_enchantress] remove team_witch
tag @a[tag=team_warlock] remove team_witch