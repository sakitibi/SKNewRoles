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
    schedule function werewolf:skill/.switch_skill/.set_skill/mura 1t append false
    schedule function werewolf:skill/.switch_skill/.set_skill/jinrou 1t append false
    schedule function werewolf:skill/.switch_skill/.set_skill/other 1t append false
# スキル無し用
execute if entity @s[tag=player,team=!Jinrou,team=!Asasine,team=!Wanashi,team=!Uranai,team=!Reinou,team=!Kishi,team=!Hoankan,team=!Ojousama,team=!Saibankan,team=!Niceteleporter,team=!Satsumatoimo,team=!Sakenomikoto,team=!Ponkotsu,team=!Youko,team=!Shinigami,team=!Cupid,team=!Jackal,team=!Sidekick,team=!Seer,team=!Madseer,team=!Evilseer,team=!Witch,team=!Rimokon,team=!Doublekiller,team=!Jackal,team=!Evilguesser,team=!Sniper,team=!Comuner,team=!Serialkiller] run item replace entity @s hotbar.8 with minecraft:carrot_on_a_stick{Tags:["role_skill","no_drop"],display:{Name:'{"text":"スキル無し","italic":false,"color":"white"}'},Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}],CustomModelData:9999,HideFlags:63}