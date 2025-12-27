execute as @a[predicate=werewolf:have_item/smoke_bomb,predicate=werewolf:is_sneaking] run item modify entity @s weapon.mainhand werewolf:item/smoke_bomb/set_smoke_bomb_charged
execute as @a[predicate=werewolf:have_item/smoke_bomb_charged,predicate=!werewolf:is_sneaking] run item modify entity @s weapon.mainhand werewolf:item/smoke_bomb/set_smoke_bomb
execute as @e[type=snowball,nbt={Item:{tag:{Tags:["smoke_bomb"]}}}] at @s run function werewolf:item/smoke_bomb/summon
execute as @e[type=snowball,nbt={Item:{tag:{Tags:["smoke_bomb_charged"]}}}] at @s run function werewolf:item/smoke_bomb/summon_charged
execute as @e[type=item,tag=smoke_bomb] at @s run function werewolf:item/smoke_bomb/bounce
execute as @e[type=item,tag=smoke_bomb] at @s run function werewolf:item/smoke_bomb/explosion