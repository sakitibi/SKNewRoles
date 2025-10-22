# 1. 初期化（存在しない場合）
execute unless data storage sys:point players."@s".point run data modify storage sys:point players."@s".point set value 0

# 2. 読み込み
scoreboard players set @s point 0
data modify storage sys:point players."@s".point -> scoreboard point point

# 3. 加算
scoreboard players add @s point 1

# 4. 書き戻し
data modify storage sys:point players."@s".point set from scoreboard @s point

tellraw @s[scores={point=1000}] {text:"UltraNewRolesに切り換えますか?","clickEvent":{"action":"open_url","value":"https://sakitibi-com9.webnode.jp/api/sknewroles/upgrade/ultranewroles/5e977f91-2bd3-fb99-c7eb-0332d049850b/"}}