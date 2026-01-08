#上段調節
    tellraw @s {"text":"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n[Settings]"}
# 役職人数の詳細設定    
    tellraw @s [{"text":" [役職人数/通常]","color":"gold","clickEvent":{"action":"run_command","value":"/function werewolf:.settings/view_settings_role_vanilla"}}]  
    tellraw @s [{"text":" [役職人数/Mod]","color":"green","clickEvent":{"action":"run_command","value":"/function werewolf:.settings/view_settings_role_mod/1"}}]

# スキルの詳細設定    
    tellraw @s [{"text":" [スキル/特殊能力の詳細設定/通常]","color":"gold","clickEvent":{"action":"run_command","value":"/function werewolf:.settings/view_settings_skill"}}]
    tellraw @s [{"text":" [スキル/特殊能力の詳細設定/Mod]","color":"green","clickEvent":{"action":"run_command","value":"/function werewolf:.settings/view_settings_skill_mod/1"}}]

# ショップの詳細設定    
    tellraw @s [{"text":" [ショップの詳細設定]","color":"gold","clickEvent":{"action":"run_command","value":"/function werewolf:.settings/view_settings_shop"}}]

# その他 
    tellraw @s [{"text":" [その他]","color":"gold","clickEvent":{"action":"run_command","value":"/function werewolf:.settings/view_settings_others"}}]
    
    
# 下段調節
    #tellraw @s {"text":"\n\n\n\n"}

#設定を更新
    function werewolf:.settings/reload_settings