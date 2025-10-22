#通常
execute if entity @s[team=Reinou] if score @a[tag=10,limit=1] role matches 1 if entity @a[tag=10,team=Tenkai] run tellraw @s [{"selector":"@a[tag=10]","color":"green"},{"text":"は人狼ではなかったようだ。","color":"green"}]
execute if entity @s[team=Reinou] if score @a[tag=10,limit=1] role matches 2 if entity @a[tag=10,team=Tenkai] run tellraw @s [{"selector":"@a[tag=10]","color":"red"},{"text":"は人狼だったようだ。","color":"red"}]
execute if entity @s[team=Reinou] if entity @a[tag=10,tag=player] run tellraw @s [{"selector":"@a[tag=10]"},{"text":"はまだ生きているようだ。"}]
execute if entity @s[team=Reinou] unless entity @a[tag=10] run tellraw @s [{"text":"プレイヤーの検索に失敗しました。"}]
execute if entity @s[team=Reinou] unless entity @a[tag=10] run tellraw @s [{"text":"当該プレイヤーは現在ワールドに存在しません。"}]
#ポンコツ
execute if entity @s[team=Ponkotsu] if entity @a[tag=10] run tellraw @s [{"selector":"@a[tag=10]","color":"green"},{"text":"は人狼ではなかったようだ。","color":"green"}]
execute if entity @s[team=Ponkotsu] unless entity @a[tag=10] run tellraw @s [{"text":"プレイヤーの検索に失敗しました。"}]
execute if entity @s[team=Ponkotsu] unless entity @a[tag=10] run tellraw @s [{"text":"当該プレイヤーは現在ワールドに存在しません。"}]