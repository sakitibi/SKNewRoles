#アイテムを持っていれば持ち替え
execute as @a[scores={witch_roar_skill_cooltime=..0},predicate=werewolf:have_skill/witch_roar_skill] run loot replace entity @s weapon.mainhand loot werewolf:skill/witch_roar_skill/cooltime
#スキル発動のためのスコアボード開放
scoreboard players add @s charge_roar 0
#クールタイム設定
scoreboard players set @s skill_witch_roar_cooltime 600