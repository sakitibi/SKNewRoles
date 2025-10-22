# オポチュニスト
    #クールタイム設定
    execute as @a[scores={skill_ojousama_cooltime=1..},predicate=werewolf:set_skill/ojousama_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/ojousama_skill/cooltime
    execute as @a[scores={skill_ojousama_cooltime=0},predicate=werewolf:set_skill/ojousama_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/ojousama_skill/
# 妖狐
    execute as @a[team=Youko] run loot replace entity @s hotbar.8 loot werewolf:skill/youko_skill/cooltime
# 死神
    #クールタイム設定
    execute as @a[scores={skill_shinigami_cooltime=1..},predicate=werewolf:set_skill/shinigami_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/shinigami_skill/cooltime
    execute as @a[scores={skill_shinigami_cooltime=0},predicate=werewolf:set_skill/shinigami_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/shinigami_skill/
# キューピット
    #クールタイム設定
    execute as @a[predicate=werewolf:set_skill/cupid_skill_ban] if score GameManager lovers_full matches 0 run loot replace entity @s hotbar.8 loot werewolf:skill/cupid_skill/
    execute as @a[scores={skill_cupid_cooltime=1..}] if score GameManager lovers_full matches 0 run scoreboard players remove @s skill_cupid_cooltime 1
    execute as @a[scores={skill_cupid_cooltime=1..},predicate=werewolf:set_skill/cupid_skill] if score GameManager lovers_full matches 0 run loot replace entity @s hotbar.8 loot werewolf:skill/cupid_skill/cooltime
    execute as @a[scores={skill_cupid_cooltime=..0},predicate=werewolf:set_skill/cupid_skill_cooltime] if score GameManager lovers_full matches 0 run loot replace entity @s hotbar.8 loot werewolf:skill/cupid_skill/
    execute if score GameManager lovers_full matches 1 as @a[team=Cupid] run loot replace entity @s hotbar.8 loot werewolf:skill/cupid_skill/ban
# ジャッカル
    # キル
    execute as @a[team=Jackal,scores={skill_jackal_slash_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/jackal_slash_skill/
    execute as @a[team=Jackal,scores={skill_jackal_slash_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/jackal_slash_skill/cooltime
    # サイドキック
    execute as @a[team=Jackal,scores={skill_jackal_sidekick_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/jackal_sidekick_skill/
    execute as @a[team=Jackal,scores={skill_jackal_sidekick_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/jackal_sidekick_skill/cooltime