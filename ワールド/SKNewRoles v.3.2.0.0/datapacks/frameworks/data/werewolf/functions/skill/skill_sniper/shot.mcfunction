#アイテムを持っていれば持ち替え
execute as @a[scores={sniper_skill_cooltime=..0},predicate=werewolf:have_skill/sniper_skill] run loot replace entity @s weapon.mainhand loot werewolf:skill/sniper_skill/cooltime
#スキル発動のためのスコアボード開放
scoreboard players add @s charge_roar 0
#クールタイム設定
scoreboard players set @s skill_sniper_cooltime 600