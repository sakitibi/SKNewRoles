    #チェスト系を一括ロック
        execute as @e[type=marker,tag=amc_sarcher] at @s run data merge block ~ ~ ~ {Lock:"key"}
    #額縁を一括ロック
        execute as @e[type=marker,tag=amc_sarcher] at @s run data merge entity @e[type=item_frame,sort=nearest,limit=1,distance=..0.5] {Fixed:1b}
    #アマスタを一括ロック        
        execute as @e[type=marker,tag=amc_sarcher] at @s run data merge entity @e[type=armor_stand,sort=nearest,limit=1,distance=..0.5] {DisabledSlots:30}
    #ロックで防げないブロックを個別にロック
        execute as @e[type=marker,tag=amc_sarcher] at @s align xyz positioned ~0.5 ~ ~0.5 if block ~ ~ ~ smithing_table unless entity @e[type=interaction,tag=lock,distance=..0.5] run summon interaction ~ ~ ~ {Tags:["lock","smithing_table"],width:1.01f,height:1.01f}
        execute as @e[type=marker,tag=amc_sarcher] at @s align xyz positioned ~0.5 ~ ~0.5 if block ~ ~ ~ grindstone unless entity @e[type=interaction,tag=lock,distance=..0.5] run summon interaction ~ ~ ~ {Tags:["lock","grindstone"],width:1.01f,height:1.01f}
        execute as @e[type=marker,tag=amc_sarcher] at @s align xyz positioned ~0.5 ~ ~0.5 if block ~ ~ ~ anvil unless entity @e[type=interaction,tag=lock,distance=..0.5] run summon interaction ~ ~ ~ {Tags:["lock","anvil"],width:1.01f,height:1.01f}
        execute as @e[type=marker,tag=amc_sarcher] at @s align xyz positioned ~0.5 ~ ~0.5 if block ~ ~ ~ chipped_anvil unless entity @e[type=interaction,tag=lock,distance=..0.5] run summon interaction ~ ~ ~ {Tags:["lock","anvil"],width:1.01f,height:1.01f}
        execute as @e[type=marker,tag=amc_sarcher] at @s align xyz positioned ~0.5 ~ ~0.5 if block ~ ~ ~ damaged_anvil unless entity @e[type=interaction,tag=lock,distance=..0.5] run summon interaction ~ ~ ~ {Tags:["lock","anvil"],width:1.01f,height:1.01f}
        execute as @e[type=marker,tag=amc_sarcher] at @s align xyz positioned ~0.5 ~ ~0.5 if block ~ ~ ~ enchanting_table unless entity @e[type=interaction,tag=lock,distance=..0.5] run summon interaction ~ ~ ~ {Tags:["lock","enchanting_table"],width:1.01f,height:1.01f}
        execute as @e[type=marker,tag=amc_sarcher] at @s align xyz positioned ~0.5 ~ ~0.5 if block ~ ~ ~ ender_chest unless entity @e[type=interaction,tag=lock,distance=..0.5] run summon interaction ~ ~ ~ {Tags:["lock","ender_chest"],width:1.01f,height:1.01f}
        execute as @e[type=marker,tag=amc_sarcher] at @s align xyz positioned ~0.5 ~ ~0.5 if block ~ ~ ~ stonecutter unless entity @e[type=interaction,tag=lock,distance=..0.5] run summon interaction ~ ~ ~ {Tags:["lock","stonecutter"],width:1.01f,height:1.01f}
        execute as @e[type=marker,tag=amc_sarcher] at @s align xyz positioned ~0.5 ~ ~0.5 if block ~ ~ ~ cartography_table unless entity @e[type=interaction,tag=lock,distance=..0.5] run summon interaction ~ ~ ~ {Tags:["lock","cartography_table"],width:1.01f,height:1.01f}
        execute as @e[type=marker,tag=amc_sarcher] at @s align xyz positioned ~0.5 ~ ~0.5 if block ~ ~ ~ loom unless entity @e[type=interaction,tag=lock,distance=..0.5] run summon interaction ~ ~ ~ {Tags:["lock","loom"],width:1.01f,height:1.01f}

        execute as @e[type=marker,tag=amc_sarcher] at @s align xyz positioned ~0.5 ~ ~0.5 if block ~ ~ ~ #minecraft:flower_pots unless entity @e[type=interaction,tag=lock,distance=..0.5] run summon interaction ~ ~ ~ {Tags:["lock","flower_pot"],width:0.6f,height:0.6f}

    #グロウベリーを保護
        execute as @e[type=marker,tag=amc_sarcher] at @s align xyz positioned ~0.5 ~ ~0.5 if block ~ ~ ~ cave_vines unless entity @e[type=interaction,tag=lock,distance=..0.5] positioned ~ ~-0.0001 ~ run summon interaction ~ ~ ~ {Tags:["lock","cave_vines"],width:1.01f,height:1.01f}
        execute as @e[type=marker,tag=amc_sarcher] at @s align xyz positioned ~0.5 ~ ~0.5 if block ~ ~ ~ cave_vines_plant unless entity @e[type=interaction,tag=lock,distance=..0.5] run summon interaction ~ ~ ~ {Tags:["lock","cave_vines_plant"],width:1.01f,height:1.01f}