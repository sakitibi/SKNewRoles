#全員が投票していたら会議時間をスキップ
execute unless entity @a[team=!Tenkai,scores={can_vote=0}] if score GameManager meeting_timer matches 2.. run scoreboard players set GameManager meeting_timer 1

#会議時間の管理
scoreboard players remove GameManager meeting_timer 1
#ボスバーに反映
execute store result bossbar time_bossbar value run scoreboard players get GameManager meeting_timer

#投票を反映
execute if score GameManager meeting_timer matches 0 run function werewolf:.system/vote/vote_result
execute if score GameManager meeting_timer matches 0 run effect give @a[team=!Tenkai,tag=hang] glowing 10 0 true

#吊られる人をtp
execute if score GameManager meeting_timer matches -199..0 at @e[sort=nearest,limit=1,type=marker,tag=hang] run tp @a[team=!Tenkai,tag=hang] ~ ~ ~

#会議を終了
execute if score GameManager meeting_timer matches ..-100 unless entity @a[team=!Tenkai,tag=hang] run function werewolf:.system/vote/.end
execute if score GameManager meeting_timer matches ..-200 run function werewolf:.system/vote/.end

# インベントリ関連
        #持ち物所持上限を制限する
            execute as @a[predicate=!werewolf:have_item/ban_slot,scores={time_since_death=4..}] run function werewolf:.system/ban_slot
        #スキルを設定する
            execute as @a[predicate=!werewolf:have_item/role_skill] run function werewolf:skill/.switch_skill/.set_skill
        #役職本を設置する
            execute as @a[predicate=!werewolf:have_item/role_book] run function werewolf:role/.set_role_book

        #初日はスキルを封印
            #execute if data storage sys: {time_text:'{"text":"\\uF804\\uF804\\uF804\\uF804\\uF804\\uF804初日の昼時間\\uF804\\uF804\\uF804\\uF804\\uF804\\uF804","color":"white"}'} run function werewolf:skill/.switch_skill/.set_skill_first_day
        #初日の夜以降
            #execute unless data storage sys: {time_text:'{"text":"\\uF804\\uF804\\uF804\\uF804\\uF804\\uF804初日の昼時間\\uF804\\uF804\\uF804\\uF804\\uF804\\uF804","color":"white"}'} run function werewolf:skill/.switch_skill/.set_skill_second_day_onwards
