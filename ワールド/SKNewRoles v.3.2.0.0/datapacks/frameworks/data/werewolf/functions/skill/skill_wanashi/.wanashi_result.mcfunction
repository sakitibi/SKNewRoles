scoreboard players add @s skill_wanashi_cooltime 0
execute unless score @s skill_wanashi_cooltime matches 0 run tellraw @s {"text":"今はまだ使えない。"}

#罠の作成
    #使用するスコアボードを初期化
        scoreboard players reset GameManager reserve_1
        scoreboard players reset GameManager reserve_2
        scoreboard players reset GameManager reserve_3
    #罠の設置数を検索
        execute if score @s skill_wanashi_cooltime matches 0 run execute store result score GameManager reserve_1 if entity @e[type=marker,tag=pitfall]
    #設置可能なら1を返す
        execute if score @s skill_wanashi_cooltime matches 0 run execute if score GameManager reserve_1 < GameManager pitfall_max_count run scoreboard players set GameManager reserve_2 1
#失敗
    #設置限界
        execute if score @s skill_wanashi_cooltime matches 0 unless score GameManager reserve_2 matches 1 run tellraw @s [{"text":"罠はこれ以上設置できない (現在の設置数:"},{"score":{"name":"GameManager","objective":"reserve_1"}},{"text":"個、設置可能数:"},{"score":{"name":"GameManager","objective":"pitfall_max_count"}},{"text":"個)"}]
    #空中判定
        execute if score @s skill_wanashi_cooltime matches 0 if score GameManager reserve_2 matches 1 if data entity @s {OnGround:0b} run tellraw @s "空中では罠を設置できない"
#成功
    #設置するなら1を返す
        execute if score @s skill_wanashi_cooltime matches 0 if score GameManager reserve_2 matches 1 if data entity @s {OnGround:1b} run scoreboard players set GameManager reserve_3 1
    #罠を設置する
        execute if score @s skill_wanashi_cooltime matches 0 if score GameManager reserve_3 matches 1 run scoreboard players add GameManager reserve_1 1
        execute if score @s skill_wanashi_cooltime matches 0 if score GameManager reserve_3 matches 1 run tellraw @s [{"text":"罠を設置した (現在の設置数:"},{"score":{"name":"GameManager","objective":"reserve_1"}},{"text":"個、同時設置可能数:"},{"score":{"name":"GameManager","objective":"pitfall_max_count"}},{"text":"個)"}]
        execute if score @s skill_wanashi_cooltime matches 0 at @s if score GameManager reserve_3 matches 1 run summon minecraft:marker ~ ~ ~ {Tags:["pitfall","inactive"]}
    #演出
        execute if score @s skill_wanashi_cooltime matches 0 if score GameManager reserve_3 matches 1 at @s run playsound minecraft:set_pitfall master @a[distance=..5]
        
    #スキル使用でクールタイムスキルに持ち替え
        execute as @s[scores={skill_wanashi_cooltime=0}] if score GameManager reserve_3 matches 1 run loot replace entity @s weapon.mainhand loot werewolf:skill/wanashi_skill/cooltime
    #クールタイム設定
        execute if score @s skill_wanashi_cooltime matches 0 if score GameManager reserve_3 matches 1 run scoreboard players set @s skill_wanashi_cooltime 600

#念のためスコアボードを初期化
    execute if score @s skill_wanashi_cooltime matches 0 run scoreboard players reset GameManager reserve_1
    execute if score @s skill_wanashi_cooltime matches 0 run scoreboard players reset GameManager reserve_2
    execute if score @s skill_wanashi_cooltime matches 0 run scoreboard players reset GameManager reserve_3