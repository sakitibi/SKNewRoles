execute as @a[predicate=werewolf:have_item/tnt_bomb,predicate=werewolf:is_sneaking] run item modify entity @s weapon.mainhand werewolf:item/tnt_bomb/set_tnt_bomb_charged
execute as @a[predicate=werewolf:have_item/tnt_bomb_charged,predicate=!werewolf:is_sneaking] run item modify entity @s weapon.mainhand werewolf:item/tnt_bomb/set_tnt_bomb
execute as @e[type=snowball,nbt={Item:{tag:{Tags:["tnt_bomb"]}}}] at @s run function werewolf:item/tnt_bomb/summon
execute as @e[type=snowball,nbt={Item:{tag:{Tags:["tnt_bomb_charged"]}}}] at @s run function werewolf:item/tnt_bomb/summon_charged
execute as @e[type=item,tag=tnt_bomb] at @s run function werewolf:item/tnt_bomb/bounce
execute as @e[type=item,tag=tnt_bomb] at @s run function werewolf:item/tnt_bomb/explosion