# スキルモード切り替え
    execute as @a[predicate=werewolf:have_item/role_skill,predicate=werewolf:is_sneaking,scores={right_click=1..,skill_mode=0}] run scoreboard players set @s skill_mode 1
    execute as @a[team=Rimokon,predicate=werewolf:have_item/role_skill,predicate=werewolf:is_sneaking,scores={right_click=1..,skill_mode=1}] run scoreboard players set @s skill_mode 2
    execute as @a[team=!Rimokon,predicate=werewolf:have_item/role_skill,predicate=werewolf:is_sneaking,scores={right_click=1..,skill_mode=1}] run scoreboard players set @s skill_mode 0
    execute as @a[predicate=werewolf:have_item/role_skill,predicate=werewolf:is_sneaking,scores={right_click=1..,skill_mode=2}] run scoreboard players set @s skill_mode 0

#初日はスキルを封印
    execute if data storage sys: {time_text:'{"text":"初日の昼時間","color":"white"}'} run function werewolf:skill/.s_skill/.set_skill_first_day
#初日の夜以降
    execute unless data storage sys: {time_text:'{"text":"初日の昼時間","color":"white"}'} run function werewolf:skill/.s_skill/.set_skill_second_day_onwards
# ポイゾナー時間差キル
    schedule function werewolf:.system/.playing/skill/poisoner_counter 1s append false
#罠の処理
    execute if entity @e[type=marker,tag=pitfall] run function werewolf:skill/skill_wanashi/trap
    execute as @a[scores={fall_into_a_pitfall=1..}] run function werewolf:skill/skill_wanashi/tp
    #ポンコツ
    execute if entity @e[type=item,tag=pitfall_dummy] run function werewolf:skill/skill_wanashi/trap_dummy