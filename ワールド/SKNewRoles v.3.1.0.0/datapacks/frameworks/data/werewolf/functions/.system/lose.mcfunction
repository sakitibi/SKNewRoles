# 1. 初期化（存在しない場合）
execute unless data storage sys:point players."@s".point run data modify storage sys:point players."@s".point set value 0

# 2. 読み込み
scoreboard players set @s point 0
data modify storage sys:point players."@s".point -> scoreboard @s point

# 3. 減算
scoreboard players remove @s point 1
scoreboard players set @s[scores={point=..-1}] point 0

# 4. 書き戻し
data modify storage sys:point players."@s".point set from scoreboard @s point