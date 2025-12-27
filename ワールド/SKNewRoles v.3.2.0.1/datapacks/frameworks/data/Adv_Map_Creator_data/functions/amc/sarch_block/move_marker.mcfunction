    # マーカーをy+1
        execute unless score AMC_Manager amc_y matches 0 as @e[type=marker,tag=amc_sarcher] at @s run tp @s ~ ~1 ~
        function Adv_Map_Creator_data:amc/sarch_block/work

        scoreboard players remove AMC_Manager amc_y 1
        
        execute unless score AMC_Manager amc_y matches 0 run function Adv_Map_Creator_data:amc/sarch_block/move_marker


        










