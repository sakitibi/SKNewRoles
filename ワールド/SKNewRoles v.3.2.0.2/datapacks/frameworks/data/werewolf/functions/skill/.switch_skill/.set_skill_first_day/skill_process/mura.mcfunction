#役職スキル処理
# 占い師
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/uranai_skill_cooltime,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# 霊能者
    execute as @a[predicate=werewolf:look_at/look_at_grave,predicate=werewolf:have_skill/reinou_skill_cooltime,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# 騎士
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/kishi_skill_cooltime,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# シェリフ
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/hoankan_skill_cooltime,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# ナイステレポーター
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/niceteleporter_skill_cooltime,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# さけのみこと
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/sakenomikoto_skill_cooltime,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# 花園の女の子
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/hanazonogirl_skill_cooltime,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# 森
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/forest_skill_cooltime,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# 裁判官
    execute as @a[predicate=werewolf:have_skill/saibankan_skill_cooltime,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# 雪女
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/snowgirl_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# タオル干し
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/taoruboshi_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}