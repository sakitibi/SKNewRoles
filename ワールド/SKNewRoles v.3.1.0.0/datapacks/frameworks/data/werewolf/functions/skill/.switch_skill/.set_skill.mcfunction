# スロット情報記録
data modify storage sys: return_item set from entity @s Inventory[{Slot:8b}]
# アイテム返却
execute as @s at @s run function werewolf:.system/inventory_menu/return_item
# 念のためのストレージリセット
data remove storage sys: return_item

# スキルアイテムクリア
clear @s carrot_on_a_stick{Tags:["role_skill","no_drop"]}
#clear @s crossbow{Tags:["role_skill","no_drop"]}

# 役職スキルをセット
    # 狼陣営
        execute if entity @s[team=Jinrou,scores={skill_mode=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_slash_skill/
        execute if entity @s[team=Jinrou,scores={skill_mode=1}] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_roar_skill/
        execute if entity @s[team=Asasine] run loot replace entity @s hotbar.8 loot werewolf:skill/asasine_skill/
        execute if entity @s[team=Witch,scores={skill_mode=1}] run loot replace entity @s hotbar.8 loot werewolf:skill/witch_roar_skill/
        execute if entity @s[team=Witch,scores={skill_mode=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/witch_slash_skill/
        execute if entity @s[team=Rimokon,scores={skill_mode=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/rimokon_slash_skill/
        execute if entity @s[team=Rimokon,scores={skill_mode=1}] run loot replace entity @s hotbar.8 loot werewolf:skill/rimokon_marking_skill/
        execute if entity @s[team=Rimokon,scores={skill_mode=2}] run loot replace entity @s hotbar.8 loot werewolf:skill/rimokon_operation_skill/
        execute if entity @s[team=Doublekiller,scores={skill_mode=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/doublekiller_mainslash_skill/
        execute if entity @s[team=Doublekiller,scores={skill_mode=1}] run loot replace entity @s hotbar.8 loot werewolf:skill/doublekiller_subslash_skill/
        execute if entity @s[team=Evilguesser] run loot replace entity @s hotbar.8 loot werewolf:skill/evilguesser_skill/
        execute if entity @s[team=Sniper] run loot replace entity @s hotbar.8 loot werewolf:skill/sniper_skill/
        execute if entity @s[team=Evilseer,scores={skill_mode=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/evilseer_slash_skill/
        execute if entity @s[team=Evilseer,scores={skill_mode=1}] run loot replace entity @s hotbar.8 loot werewolf:skill/evilseer_sidekick_skill/
        execute if entity @s[team=Comuner] run loot replace entity @s hotbar.8 loot werewolf:skill/comuner_skill/
        execute if entity @s[team=Serialkiller] run loot replace entity @s hotbar.8 loot werewolf:skill/serialkiller_skill/
        execute if entity @s[team=Wanashi] run loot replace entity @s hotbar.8 loot werewolf:skill/wanashi_skill/
        execute if entity @s[team=Madseer] run loot replace entity @s hotbar.8 loot werewolf:skill/madseer_skill/
    #村陣営
        execute if entity @s[team=Uranai] run loot replace entity @s hotbar.8 loot werewolf:skill/uranai_skill/
        execute if entity @s[team=Reinou] run loot replace entity @s hotbar.8 loot werewolf:skill/reinou_skill/
        execute if entity @s[team=Kishi] run loot replace entity @s hotbar.8 loot werewolf:skill/kishi_skill/
        execute if entity @s[team=Hoankan] run loot replace entity @s hotbar.8 loot werewolf:skill/hoankan_skill/
        execute if entity @s[team=Niceteleporter] run loot replace entity @s hotbar.8 loot werewolf:skill/niceteleporter_skill/
        execute if entity @s[team=Sakenomikoto] run loot replace entity @s hotbar.8 loot werewolf:skill/sakenomikoto_skill/
        execute if entity @s[team=Saibankan] run loot replace entity @s hotbar.8 loot werewolf:skill/saibankan_skill/
        execute if entity @s[team=Hanazonogirl] run loot replace entity @s hotbar.8 loot werewolf:skill/hanazonogirl_skill/
        execute if entity @s[team=Forest] run loot replace entity @s hotbar.8 loot werewolf:skill/forest_skill/
    #第三陣営
        execute if entity @s[team=Youko] run loot replace entity @s hotbar.8 loot werewolf:skill/youko_skill/
        execute if entity @s[team=Shinigami] run loot replace entity @s hotbar.8 loot werewolf:skill/shinigami_skill/
        execute if entity @s[team=Cupid] run loot replace entity @s hotbar.8 loot werewolf:skill/cupid_skill/
        execute if entity @s[team=Jackal,scores={skill_mode=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/jackal_slash_skill/
        execute if entity @s[team=Jackal,scores={skill_mode=1}] run loot replace entity @s hotbar.8 loot werewolf:skill/jackal_sidekick_skill/

#ポンコツ用
    execute if entity @s[team=Ponkotsu,tag=jinrou_dummy,scores={skill_mode=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_slash_skill/
    execute if entity @s[team=Ponkotsu,tag=jinrou_dummy,scores={skill_mode=1}] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_roar_skill/
    execute if entity @s[team=Ponkotsu,tag=wanashi_dummy] run loot replace entity @s hotbar.8 loot werewolf:skill/wanashi_skill/
    execute if entity @s[team=Ponkotsu,tag=uranai_dummy] run loot replace entity @s hotbar.8 loot werewolf:skill/uranai_skill/
    execute if entity @s[team=Ponkotsu,tag=reinou_dummy] run loot replace entity @s hotbar.8 loot werewolf:skill/reinou_skill/
    execute if entity @s[team=Ponkotsu,tag=kishi_dummy] run loot replace entity @s hotbar.8 loot werewolf:skill/kishi_skill/
    execute if entity @s[team=Ponkotsu,tag=hoankan_dummy] run loot replace entity @s hotbar.8 loot werewolf:skill/hoankan_skill/
    execute if entity @s[team=Ponkotsu,tag=ojousama_dummy] run loot replace entity @s hotbar.8 loot werewolf:skill/ojousama_skill/
    execute if entity @s[team=Ponkotsu,tag=saibankan_dummy] run loot replace entity @s hotbar.8 loot werewolf:skill/saibankan_skill/
    execute if entity @s[team=Ponkotsu,tag=ex_shinigami] run item replace entity @s hotbar.8 with minecraft:carrot_on_a_stick{Tags:["role_skill","no_drop"],display:{Name:'{"text":"スキル無し","italic":false,"color":"white"}'},Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}],CustomModelData:9999,HideFlags:63}

# スキル無し用
execute if entity @s[tag=player,team=!Jinrou,team=!Asasine,team=!Wanashi,team=!Uranai,team=!Reinou,team=!Kishi,team=!Hoankan,team=!Ojousama,team=!Saibankan,team=!Niceteleporter,team=!Satsumatoimo,team=!Sakenomikoto,team=!Ponkotsu,team=!Youko,team=!Shinigami,team=!Cupid,team=!Jackal,team=!Sidekick,team=!Seer,team=!Madseer,team=!Evilseer,team=!Witch,team=!Rimokon,team=!Doublekiller,team=!Jackal,team=!Evilguesser,team=!Sniper,team=!Comuner,team=!Serialkiller] run item replace entity @s hotbar.8 with minecraft:carrot_on_a_stick{Tags:["role_skill","no_drop"],display:{Name:'{"text":"スキル無し","italic":false,"color":"white"}'},Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}],CustomModelData:9999,HideFlags:63}