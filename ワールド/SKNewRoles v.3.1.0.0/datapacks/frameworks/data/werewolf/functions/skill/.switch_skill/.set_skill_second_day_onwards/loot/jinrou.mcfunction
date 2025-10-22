# 人狼
    #スキルチェンジ
    execute as @a[team=Jinrou,predicate=werewolf:is_sneaking,scores={right_click=1..}] run item replace entity @s weapon.mainhand with air
    #ポンコツ用
    execute as @a[team=Ponkotsu,tag=jinrou_dummy,predicate=werewolf:is_sneaking,scores={right_click=1..}] run item replace entity @s weapon.mainhand with air

    #クールタイム設定
    #咆哮
    execute as @a[scores={skill_jinrou_roar_cooltime=1..}] run scoreboard players remove @s skill_jinrou_roar_cooltime 1
    execute as @a[scores={skill_jinrou_roar_cooltime=1..},predicate=werewolf:set_skill/jinrou_roar_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_roar_skill/cooltime
    execute if data storage sys: {time_phase:day} as @a[predicate=werewolf:set_skill/jinrou_roar_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_roar_skill/ban
    execute if data storage sys: {time_phase:day} as @a[predicate=werewolf:set_skill/jinrou_roar_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_roar_skill/ban
    execute if data storage sys: {time_phase:night} as @a[scores={skill_jinrou_roar_cooltime=..0},predicate=werewolf:set_skill/jinrou_roar_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_roar_skill/
    #execute if data storage sys: {time_phase:night} as @a[scores={skill_jinrou_roar_cooltime=1..},predicate=werewolf:set_skill/jinrou_roar_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_roar_skill/cooltime
    execute if data storage sys: {time_phase:night} as @a[scores={skill_jinrou_roar_cooltime=..0},predicate=werewolf:set_skill/jinrou_roar_skill_ban] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_roar_skill/
    #切り裂く
    execute as @a[scores={skill_jinrou_slash_cooltime=0},predicate=werewolf:set_skill/jinrou_slash_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_slash_skill/
    execute as @a[scores={skill_jinrou_slash_cooltime=1..},predicate=werewolf:set_skill/jinrou_slash_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_slash_skill/cooltime
# アサシン
    execute as @a[team=Asasine,scores={skill_jinrou_slash_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/asasine_skill/
    execute as @a[team=Asasine,scores={skill_jinrou_slash_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/asasine_skill/cooltime
# Witch
#スキルチェンジ
    execute as @a[team=Witch,predicate=werewolf:is_sneaking,scores={right_click=1..}] run item replace entity @s weapon.mainhand with air
#クールタイム設定
#ビーム
    execute as @a[scores={skill_witch_roar_cooltime=1..}] run scoreboard players remove @s skill_witch_roar_cooltime 1
    execute as @a[scores={skill_witch_roar_cooltime=1..},predicate=werewolf:set_skill/witch_roar_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/witch_roar_skill/cooltime
    execute if data storage sys: {time_phase:day} as @a[predicate=werewolf:set_skill/witch_roar_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/witch_roar_skill/ban
    execute if data storage sys: {time_phase:day} as @a[predicate=werewolf:set_skill/witch_roar_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/witch_roar_skill/ban
    execute if data storage sys: {time_phase:night} as @a[scores={skill_witch_roar_cooltime=..0},predicate=werewolf:set_skill/witch_roar_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/witch_roar_skill/
    #execute if data storage sys: {time_phase:night} as @a[scores={skill_witch_roar_cooltime=1..},predicate=werewolf:set_skill/witch_roar_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/witch_roar_skill/cooltime
    execute if data storage sys: {time_phase:night} as @a[scores={skill_witch_roar_cooltime=..0},predicate=werewolf:set_skill/witch_roar_skill_ban] run loot replace entity @s hotbar.8 loot werewolf:skill/witch_roar_skill/
# キル
    execute as @a[team=Witch,scores={skill_witch_slash_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/witch_slash_skill/
    execute as @a[team=Witch,scores={skill_witch_slash_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/witch_slash_skill/cooltime
# リモコン
    # キル
    execute as @a[team=Rimokon,scores={skill_rimokon_slash_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/rimokon_slash_skill/
    execute as @a[team=Rimokon,scores={skill_rimokon_slash_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/rimokon_slash_skill/cooltime
    # マーキング
    execute as @a[team=Rimokon,scores={skill_rimokon_marking_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/rimokon_marking_skill/
    execute as @a[team=Rimokon,scores={skill_rimokon_marking_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/rimokon_marking_skill/cooltime
    # 操作
    execute as @a[team=Rimokon,scores={skill_rimokon_operation_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/rimokon_operation_skill/
    execute as @a[team=Rimokon,scores={skill_rimokon_operation_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/rimokon_operation_skill/cooltime
# ダブルキラー
    # キル
    execute as @a[team=Doublekiller,scores={skill_doublekiller_mainslash_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/doublekiller_mainslash_skill/
    execute as @a[team=Doublekiller,scores={skill_doublekiller_mainslash_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/doublekiller_mainslash_skill/cooltime
    execute as @a[team=Doublekiller,scores={skill_doublekiller_subslash_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/doublekiller_subslash_skill/
    execute as @a[team=Doublekiller,scores={skill_doublekiller_subslash_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/doublekiller_subslash_skill/cooltime
# イビルゲッサー
    execute as @a[team=Evilguesser,scores={skill_evilguesser_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/evilguesser_skill/
    execute as @a[team=Evilguesser,scores={skill_evilguesser_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/evilguesser_skill/cooltime
# スナイパー
    #クールタイム設定
    execute as @a[predicate=werewolf:set_skill/sniper_skill_ban] run loot replace entity @s hotbar.8 loot werewolf:skill/sniper_skill/
    execute as @a[scores={skill_sniper_cooltime=1..}] run scoreboard players remove @s skill_sniper_cooltime 1
    execute as @a[scores={skill_sniper_cooltime=1..},predicate=werewolf:set_skill/sniper_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/sniper_skill/cooltime
    execute as @a[scores={skill_sniper_cooltime=..0},predicate=werewolf:set_skill/sniper_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/sniper_skill/
# イビルシーア
    #スキルチェンジ
        execute as @a[team=Evilseer,predicate=werewolf:is_sneaking,scores={right_click=1..}] run item replace entity @s weapon.mainhand with air
    # キル
        execute as @a[team=Evilseer,scores={skill_evilseer_slash_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/evilseer_slash_skill/
        execute as @a[team=Evilseer,scores={skill_evilseer_slash_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/evilseer_slash_skill/cooltime
    # サイドキック
        execute as @a[team=Evilseer,scores={skill_evilseer_sidekick_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/evilseer_sidekick_skill/
        execute as @a[team=Evilseer,scores={skill_evilseer_sidekick_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/evilseer_sidekick_skill/cooltime
# コミュナー
    execute as @a[team=Comuner,scores={skill_comuner_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/comuner_skill/
    execute as @a[team=Comuner,scores={skill_comuner_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/comuner_skill/cooltime
# シリアルキラー
    execute as @a[team=Serialkiller,scores={skill_serialkiller_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/serialkiller_skill/
    execute as @a[team=Serialkiller,scores={skill_serialkiller_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/serialkiller_skill/cooltime
# 罠師
    #クールタイム設定
    execute as @a[predicate=werewolf:set_skill/wanashi_skill_ban] run loot replace entity @s hotbar.8 loot werewolf:skill/wanashi_skill/
    execute as @a[scores={skill_wanashi_cooltime=1..}] run scoreboard players remove @s skill_wanashi_cooltime 1
    execute as @a[scores={skill_wanashi_cooltime=1..},predicate=werewolf:set_skill/wanashi_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/wanashi_skill/cooltime
    execute as @a[scores={skill_wanashi_cooltime=..0},predicate=werewolf:set_skill/wanashi_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/wanashi_skill/