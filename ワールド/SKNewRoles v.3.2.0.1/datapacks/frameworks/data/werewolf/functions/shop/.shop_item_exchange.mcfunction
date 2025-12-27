#盲目付与ツール
    execute as @s[predicate=werewolf:have_item/blindness_tool] run loot replace entity @s weapon.mainhand loot werewolf:item/special_tool/blindness_tool

#容姿統一ツール
    execute as @s[predicate=werewolf:have_item/same_look_tool] run loot replace entity @s weapon.mainhand loot werewolf:item/special_tool/same_look_tool

#発光ツール
    execute as @s[predicate=werewolf:have_item/glowing_tool] run loot replace entity @s weapon.mainhand loot werewolf:item/special_tool/glowing_tool

#テレポートツール
    execute as @s[predicate=werewolf:have_item/teleport_tool] run loot replace entity @s weapon.mainhand loot werewolf:item/special_tool/teleport_tool

#ボロい剣
    execute as @s[predicate=werewolf:have_item/nomal_sword] run loot replace entity @s weapon.mainhand loot werewolf:item/weapon/nomal_sword/

#良い剣
    execute as @s[predicate=werewolf:have_item/strong_sword] run loot replace entity @s weapon.mainhand loot werewolf:item/weapon/strong_sword/
