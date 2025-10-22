    # 軸のマーカーを召喚
        execute align xyz positioned ~ ~ ~ run summon marker ~ ~-30 ~ {Tags:["amc_sarch_main"]}
    # サーチ用マーカー設置のためのスコアボード
        scoreboard objectives add amc_summon dummy
        scoreboard players set AMC_Manager amc_summon 127
        scoreboard objectives add amc_y dummy
        scoreboard players set AMC_Manager amc_y 130
    # サーチ用マーカー召喚
        function Adv_Map_Creator_data:amc/sarch_block/summon_marker
        function Adv_Map_Creator_data:amc/sarch_block/work
    # サーチ用マーカーをy軸方向に移動しながらサーチ
        function Adv_Map_Creator_data:amc/sarch_block/move_marker

    # おかたづけ
        kill @e[type=marker,tag=amc_sarch_main]
        kill @e[type=marker,tag=amc_sarcher]

    # アナウンス
        tellraw @s "処理が完了しました"
















