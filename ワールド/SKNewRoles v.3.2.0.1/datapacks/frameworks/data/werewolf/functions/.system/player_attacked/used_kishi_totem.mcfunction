#騎士の護りの効果フラグを削除
execute as @a[scores={skill_kishi_protected=2}] run scoreboard players set @s skill_kishi_protected 0
execute as @a[scores={skill_kishi_protected=1}] run scoreboard players set @s skill_kishi_protected 2

advancement revoke @s only werewolf:used_item/kishi_totem