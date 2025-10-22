# 役職スキルをセット
execute as @a[team=Jinrou,scores={skill_mode=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_slash_skill/cooltime
execute as @a[team=Jinrou,scores={skill_mode=1}] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_roar_skill/ban
execute as @a[team=Asasine] run loot replace entity @s hotbar.8 loot werewolf:skill/asasine_skill/cooltime
execute as @a[team=Witch,scores={skill_mode=1}] run loot replace entity @s hotbar.8 loot werewolf:skill/witch_roar_skill/ban
execute as @a[team=Witch,scores={skill_mode=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/witch_slash_skill/cooltime
execute as @a[team=Rimokon,scores={skill_mode=1}] run loot replace entity @s hotbar.8 loot werewolf:skill/rimokon_marking_skill/cooltime
execute as @a[team=Rimokon,scores={skill_mode=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/rimokon_slash_skill/cooltime
execute as @a[team=Rimokon,scores={skill_mode=2}] run loot replace entity @s hotbar.8 loot werewolf:skill/rimokon_operation_skill/cooltime
execute as @a[team=Doublekiller,scores={skill_mode=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/doublekiller_mainslash_skill/cooltime
execute as @a[team=Doublekiller,scores={skill_mode=1}] run loot replace entity @s hotbar.8 loot werewolf:skill/doublekiller_subslash_skill/cooltime
execute as @a[team=Evilguesser] run loot replace entity @s hotbar.8 loot werewolf:skill/evilguesser_skill/cooltime
execute as @a[team=Sniper] run loot replace entity @s hotbar.8 loot werewolf:skill/sniper_skill/ban
execute as @a[team=Evilseer,scores={skill_mode=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/evilseer_slash_skill/cooltime
execute as @a[team=Evilseer,scores={skill_mode=1}] run loot replace entity @s hotbar.8 loot werewolf:skill/evilseer_sidekick_skill/cooltime
execute as @a[team=Comuner] run loot replace entity @s hotbar.8 loot werewolf:skill/comuner_skill/cooltime
execute as @a[team=Serialkiller] run loot replace entity @s hotbar.8 loot werewolf:skill/serialkiller_skill/cooltime

execute as @a[team=Madseer] run loot replace entity @s hotbar.8 loot werewolf:skill/madseer_skill/cooltime
execute as @a[team=Wanashi] run loot replace entity @s hotbar.8 loot werewolf:skill/wanashi_skill/ban

execute as @a[team=Uranai] run loot replace entity @s hotbar.8 loot werewolf:skill/uranai_skill/cooltime
execute as @a[team=Reinou] run loot replace entity @s hotbar.8 loot werewolf:skill/reinou_skill/cooltime
execute as @a[team=Kishi] run loot replace entity @s hotbar.8 loot werewolf:skill/kishi_skill/cooltime
execute as @a[team=Hoankan] run loot replace entity @s hotbar.8 loot werewolf:skill/hoankan_skill/cooltime
execute as @a[team=Ojousama] run loot replace entity @s hotbar.8 loot werewolf:skill/ojousama_skill/cooltime
execute as @a[team=Saibankan] run loot replace entity @s hotbar.8 loot werewolf:skill/saibankan_skill/cooltime
execute as @a[team=Niceteleporter] run loot replace entity @s hotbar.8 loot werewolf:skill/niceteleporter_skill/cooltime
execute as @a[team=Sakenomikoto] run loot replace entity @s hotbar.8 loot werewolf:skill/sakenomikoto_skill/cooltime
execute as @a[team=Hanazonogirl] run loot replace entity @s hotbar.8 loot werewolf:skill/hanazonogirl_skill/cooltime
execute as @a[team=Forest] run loot replace entity @s hotbar.8 loot werewolf:skill/forest_skill/cooltime

execute as @a[team=Shinigami] run loot replace entity @s hotbar.8 loot werewolf:skill/shinigami_skill/cooltime
execute as @a[team=Cupid] run loot replace entity @s hotbar.8 loot werewolf:skill/cupid_skill/ban
execute as @a[team=Jackal] run loot replace entity @s hotbar.8 loot werewolf:skill/jackal_skill/jackal_slash_skill/cooltime

# 役職スキルをセット(ポンコツ用)
execute as @a[team=Ponkotsu,tag=jinrou_dummy,scores={skill_mode=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_slash_skill/cooltime
execute as @a[team=Ponkotsu,tag=jinrou_dummy,scores={skill_mode=1}] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_roar_skill/ban
execute as @a[team=Ponkotsu,tag=wanashi_dummy] run loot replace entity @s hotbar.8 loot werewolf:skill/wanashi_skill/ban

execute as @a[team=Ponkotsu,tag=uranai_dummy] run loot replace entity @s hotbar.8 loot werewolf:skill/uranai_skill/cooltime
execute as @a[team=Ponkotsu,tag=reinou_dummy] run loot replace entity @s hotbar.8 loot werewolf:skill/reinou_skill/cooltime
execute as @a[team=Ponkotsu,tag=kishi_dummy] run loot replace entity @s hotbar.8 loot werewolf:skill/kishi_skill/cooltime
execute as @a[team=Ponkotsu,tag=hoankan_dummy] run loot replace entity @s hotbar.8 loot werewolf:skill/hoankan_skill/cooltime
execute as @a[team=Ponkotsu,tag=ojousama_dummy] run loot replace entity @s hotbar.8 loot werewolf:skill/ojousama_skill/cooltime
execute as @a[team=Ponkotsu,tag=saibankan_dummy] run loot replace entity @s hotbar.8 loot werewolf:skill/saibankan_skill/cooltime


#役職スキル処理
# 人狼
  #咆哮
    execute as @a[predicate=werewolf:have_skill/jinrou_roar_skill_ban,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run tellraw @s {"text":"今はまだ使えない。"}
  #切り裂き
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/jinrou_slash_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}         
# Witch
  #ビーム
    execute as @a[predicate=werewolf:have_skill/witch_roar_skill_ban,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run tellraw @s {"text":"今はまだ使えない。"}
  #切り裂き
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/witch_slash_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}      
# リモコン
  #マーキング
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/rimokon_marking_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
  #切り裂き
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/rimokon_slash_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
  #操作
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/rimokon_operation_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# ダブルキラー
  #キル
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/doublekiller_mainslash_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}  
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/doublekiller_subslash_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# イビルゲッサー
  execute as @a[predicate=werewolf:have_skill/evilguesser_skill_ban,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# イビルシーア
  #キル
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/evilseer_slash_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
  #サイドキック
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/evilseer_sidekick_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# コミュナー
  execute as @a[predicate=werewolf:have_skill/comuner_skill_ban,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# シリアルキラー
  execute as @a[predicate=werewolf:have_skill/serialkiller_skill_ban,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# 罠師
  execute as @a[predicate=werewolf:have_skill/wanashi_skill_ban,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# マッドシーア
  execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/madseer_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}

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

# オポチュニスト
  execute as @a[predicate=werewolf:have_skill/ojousama_skill_cooltime,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# 死神
  execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/shinigami_skill_cooltime,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# キューピット
  execute as @a[predicate=werewolf:have_skill/cupid_skill_ban,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# ジャッカル
  #キル
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/jackal_slash_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
  #サイドキック
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/jackal_sidekick_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}

#役職例外
# 妖狐
  #背徳者処理
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/youko_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_youko/.youko_result
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/youko_skill,scores={right_click=1..}] run function werewolf:skill/skill_youko/.youko_result
  #クールタイム設定
    execute as @a[scores={skill_youko_cooltime=1..},predicate=werewolf:set_skill/youko_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/youko_skill/cooltime
    execute as @a[scores={skill_youko_cooltime=0},predicate=werewolf:set_skill/youko_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/youko_skill/