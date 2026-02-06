# 占い師
    #占い処理
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/uranai_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_uranai/.uranai_result
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/uranai_skill,scores={right_click=1..}] run function werewolf:skill/skill_uranai/.uranai_result
# 霊能者
    #霊能処理
    execute as @a[predicate=werewolf:look_at/look_at_grave,predicate=werewolf:have_skill/reinou_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_reinou/.reinou_result
    execute as @a[predicate=werewolf:look_at/look_at_grave,predicate=werewolf:have_skill/reinou_skill,scores={right_click=1..}] run function werewolf:skill/skill_reinou/.reinou_result
# 騎士
    #守護処理
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/kishi_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_kishi/.kishi_result
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/kishi_skill,scores={right_click=1..}] run function werewolf:skill/skill_kishi/.kishi_result
# シェリフ
    #シェリフ処理
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/hoankan_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_hoankan/.hoankan_result
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/hoankan_skill,scores={right_click=1..}] run function werewolf:skill/skill_hoankan/.hoankan_result
# 裁判官
    #裁判官処理
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/saibankan_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_saibankan/.saibankan_result
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/saibankan_skill,scores={right_click=1..}] run function werewolf:skill/skill_saibankan/.saibankan_result
    #裁判官補佐処理
    execute as @a[tag=saibankan_1,predicate=werewolf:look_at/look_at_meeting_button] run function werewolf:skill/skill_saibankan/.successor_result
# ナイステレポーター
    #ナイステレポーター処理
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/niceteleporter_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_niceteleporter/.niceteleporter_result
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/niceteleporter_skill,scores={right_click=1..}] run function werewolf:skill/skill_niceteleporter/.niceteleporter_result
# さけのみこと
    #さけのみこと処理
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/sakenomikoto_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_sakenomikoto/.sakenomikoto_result
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/sakenomikoto_skill,scores={right_click=1..}] run function werewolf:skill/skill_sakenomikoto/.sakenomikoto_result
# 花園の女の子
    #花園の女の子処理
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/hanazonogirl_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_hanazonogirl/.hanazonogirl_result
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/hanazonogirl_skill,scores={right_click=1..}] run function werewolf:skill/skill_hanazonogirl/.hanazonogirl_result
# 森
    #森処理
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/forest_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_forest/.forest_result
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/forest_skill,scores={right_click=1..}] run function werewolf:skill/skill_forest/.forest_result
# 雪女
    #雪女処理
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/snowgirl_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_snowgirl/.snowgirl_result
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/snowgirl_skill,scores={right_click=1..}] run function werewolf:skill/skill_snowgirl/.snowgirl_result