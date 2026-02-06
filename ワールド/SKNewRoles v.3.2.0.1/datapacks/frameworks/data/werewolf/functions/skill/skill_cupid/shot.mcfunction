#キューピットの矢処理
#アイテムを持っていれば持ち替え
execute as @a[scores={cupid_skill_cooltime=..0},predicate=werewolf:have_skill/cupid_skill] run loot replace entity @s weapon.mainhand loot werewolf:skill/cupid_skill/cooltime
#スキル発動のためのスコアボード開放
scoreboard players add @s charge_cupid_arrow 0
#クールタイム設定
scoreboard players set @s skill_cupid_cooltime 600