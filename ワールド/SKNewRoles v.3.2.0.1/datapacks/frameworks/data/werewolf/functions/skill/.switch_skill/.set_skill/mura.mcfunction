execute if entity @s[team=Uranai] run loot replace entity @s hotbar.8 loot werewolf:skill/uranai_skill/
execute if entity @s[team=Reinou] run loot replace entity @s hotbar.8 loot werewolf:skill/reinou_skill/
execute if entity @s[team=Kishi] run loot replace entity @s hotbar.8 loot werewolf:skill/kishi_skill/
execute if entity @s[team=Hoankan] run loot replace entity @s hotbar.8 loot werewolf:skill/hoankan_skill/
execute if entity @s[team=Niceteleporter] run loot replace entity @s hotbar.8 loot werewolf:skill/niceteleporter_skill/
execute if entity @s[team=Sakenomikoto] run loot replace entity @s hotbar.8 loot werewolf:skill/sakenomikoto_skill/
execute if entity @s[team=Saibankan] run loot replace entity @s hotbar.8 loot werewolf:skill/saibankan_skill/
execute if entity @s[team=Hanazonogirl] run loot replace entity @s hotbar.8 loot werewolf:skill/hanazonogirl_skill/
execute if entity @s[team=Forest] run loot replace entity @s hotbar.8 loot werewolf:skill/forest_skill/
execute if entity @s[team=Snowgirl] run loot replace entity @s hotbar.8 loot werewolf:skill/snowgirl_skill/

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