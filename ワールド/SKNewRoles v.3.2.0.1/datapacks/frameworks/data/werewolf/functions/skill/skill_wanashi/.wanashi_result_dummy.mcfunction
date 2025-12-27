scoreboard players add @s skill_wanashi_cooltime 0
execute unless score @s skill_wanashi_cooltime matches 0 run tellraw @s {"text":"今はまだ使えない。"}

#罠の作成
    #使用するスコアボードを初期化
        scoreboard players reset GameManager reserve_1
        scoreboard players reset GameManager reserve_2
        scoreboard players reset GameManager reserve_3
    #使用するタグを初期化
        tag @e remove pitfall_dummy_owner
        tag @e remove this_pitfall_dummy

    #自分のUUID[0]を記録
    execute store result score @s owner run data get entity @s UUID[0]
    #自分にタグ付け
    tag @s add pitfall_dummy_owner
    #同じUUIDデータを持った落とし穴にタグ
    execute as @e[type=item,tag=pitfall_dummy] if score @s owner = @a[tag=pitfall_dummy_owner,limit=1] owner run tag @s add this_pitfall_dummy
    #念のため自分付けたタグ削除
    tag @s remove pitfall_dummy_owner

    #罠の設置数を検索
        execute if score @s skill_wanashi_cooltime matches 0 run execute store result score GameManager reserve_1 if entity @e[type=item,tag=pitfall_dummy,tag=this_pitfall_dummy] 
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
        execute if score @s skill_wanashi_cooltime matches 0 if score GameManager reserve_3 matches 1 run execute if score @s skill_wanashi_cooltime matches 0 at @s if score GameManager reserve_3 matches 1 run summon item ~ ~ ~ {Item:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{CustomModelData:99999}},Health:1s,PickupDelay:32767,Tags:["pitfall_dummy","no_collision","not_yet","inactive"],NoGravity:true,Age:-32768}
        execute if score @s skill_wanashi_cooltime matches 0 if score GameManager reserve_3 matches 1 run data modify entity @e[type=item,tag=pitfall_dummy,tag=not_yet,sort=nearest,limit=1] Thrower set from entity @s UUID
        execute if score @s skill_wanashi_cooltime matches 0 if score GameManager reserve_3 matches 1 run execute as @e[type=item,tag=pitfall_dummy,tag=not_yet,sort=nearest,limit=1] store result score @s owner run data get entity @s Thrower[0]
        execute if score @s skill_wanashi_cooltime matches 0 if score GameManager reserve_3 matches 1 run tag @e[type=item,tag=pitfall_dummy,tag=not_yet,sort=nearest,limit=1] remove not_yet
    #演出
        execute if score @s skill_wanashi_cooltime matches 0 if score GameManager reserve_3 matches 1 at @s run playsound minecraft:set_pitfall master @s
        
    #スキル使用でクールタイムスキルに持ち替え
        execute as @s[scores={skill_wanashi_cooltime=0}] if score GameManager reserve_3 matches 1 run loot replace entity @s weapon.mainhand loot werewolf:skill/wanashi_skill/cooltime
    #クールタイム設定
        execute if score @s skill_wanashi_cooltime matches 0 if score GameManager reserve_3 matches 1 run scoreboard players set @s skill_wanashi_cooltime 600

#念のためスコアボードを初期化
    scoreboard players reset GameManager reserve_1
    scoreboard players reset GameManager reserve_2
    scoreboard players reset GameManager reserve_3
#念のためタグを初期化        
    tag @e remove pitfall_dummy_owner
    tag @e remove this_pitfall_dummy