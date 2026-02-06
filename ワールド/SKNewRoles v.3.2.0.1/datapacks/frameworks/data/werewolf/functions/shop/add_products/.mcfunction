    # 交易内容をリセット
        data remove entity @s Offers.Recipes


    #買取
    # エメラルド(オークの原木)
        data modify entity @s[tag=shop_1] Offers.Recipes append value {rewardExp:0b,maxUses:2147483647,xp:0,buy:{id:"minecraft:oak_log",Count:1b},sell:{id:"minecraft:emerald",Count:1b}}

    # エメラルド(鉄の原石)
        data modify entity @s[tag=shop_1] Offers.Recipes append value {rewardExp:0b,maxUses:2147483647,xp:0,buy:{id:"minecraft:raw_iron",Count:1b},sell:{id:"minecraft:emerald",Count:1b}}

    # エメラルド(小麦)
        data modify entity @s[tag=shop_1] Offers.Recipes append value {rewardExp:0b,maxUses:2147483647,xp:0,buy:{id:"minecraft:wheat",Count:5b},sell:{id:"minecraft:emerald",Count:1b}}

    # エメラルド(赤色のキノコ)
        data modify entity @s[tag=shop_1] Offers.Recipes append value {rewardExp:0b,maxUses:2147483647,xp:0,buy:{id:"minecraft:red_mushroom",Count:5b},sell:{id:"minecraft:emerald",Count:1b}}

    # エメラルド(茶色のキノコ)
        data modify entity @s[tag=shop_1] Offers.Recipes append value {rewardExp:0b,maxUses:2147483647,xp:0,buy:{id:"minecraft:brown_mushroom",Count:5b},sell:{id:"minecraft:emerald",Count:1b}}

    # キノコシチュー
        data modify entity @s[tag=shop_1] Offers.Recipes append value {rewardExp:0b,maxUses:2147483647,xp:0,buy:{id:"minecraft:red_mushroom",Count:2b},buyB:{id:"brown_mushroom",Count:2},sell:{id:"minecraft:mushroom_stew",Count:1b}}
    # パン
        schedule function werewolf:shop/add_products/bread 1t append false
    #ツール
    # 良い斧
        data modify entity @s[tag=shop_2] Offers.Recipes append value {rewardExp:0b,maxUses:2147483647,xp:0,buy:{id:"raw_iron",Count:3},buyB:{id:"oak_log",Count:1},sell:{id:"minecraft:stone_axe",Count:1b,tag:{display:{Name:'{"text":"良い斧","color":"white","italic":false}',Lore:['{"text":"[アイテム説明]","color":"gray","italic":false}','{"text":"性能は良いがすぐに壊れてしまう","color":"gray","italic":false}','{"text":"                               ","color":"gray","strikethrough":true,"italic":false}','{"translate":"採集可能: ","color":"gray","italic":false,"extra":[{"translate":"","color":"white","italic":false}]}']},Enchantments:[{id:vanishing_curse,lvl:1}],HideFlags:63,CustomModelData:0,Tags:["werewolf_axe","sample"]}}}
    # 良いツルハシ
        data modify entity @s[tag=shop_2] Offers.Recipes append value {rewardExp:0b,maxUses:2147483647,xp:0,buy:{id:"raw_iron",Count:3},buyB:{id:"oak_log",Count:1},sell:{id:"minecraft:stone_pickaxe",Count:1b,tag:{display:{Name:'{"text":"良いツルハシ","color":"white","italic":false}',Lore:['{"text":"[アイテム説明]","color":"gray","italic":false}','{"text":"性能は良いがすぐに壊れてしまう","color":"gray","italic":false}','{"text":"                               ","color":"gray","strikethrough":true,"italic":false}','{"translate":"採集可能: ","color":"gray","italic":false,"extra":[{"translate":"\\uE100","color":"white","italic":false}]}']},Enchantments:[{id:vanishing_curse,lvl:1}],HideFlags:63,CustomModelData:0,Tags:["werewolf_pickaxe","sample"]}}}

    # ボロい剣
        schedule function werewolf:shop/add_products/sword/tattered_sword 1t append false
    # 良い剣
        schedule function werewolf:shop/add_products/sword/sturdy_sword 1t append false
    # 頑丈な弓
    # 普通の弓矢
        schedule function werewolf:shop/add_products/arrow 1t append false
    # 最強の剣
        data modify entity @s[tag=shop_2] Offers.Recipes append value {rewardExp:0b,maxUses:2147483647,xp:0,buy:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{CustomModelData:11,display:{Name:'{"italic":false,"color":"white","text":"良い剣"}'}}},buyB:{id:"emerald",Count:10},sell:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{display:{Name:'{"text":"最強の剣(攻撃するとクールタイムが発生)","color":"white","italic":false}',Lore:['{"text":"[アイテム説明]","color":"gray","italic":false}','{"text":"すさまじい攻撃力を誇る剣","color":"gray","italic":false}','{"text":"相手を攻撃すると暫く使用できなくなる","color":"gray","italic":false}']},Enchantments:[{id:vanishing_curse,lvl:1}],HideFlags:63,CustomModelData:12,Tags:["strongest_sword","sample"]}}}

    # 最強のクロスボウ
        data modify entity @s[tag=shop_2] Offers.Recipes append value {rewardExp:0b,maxUses:2147483647,xp:0,buy:{id:"minecraft:emerald",Count:15b},sell:{id:"minecraft:crossbow",Count:1b,tag:{display:{Name:'{"text":"最強のクロスボウ(撃つとクールタイムが発生)","color":"white","italic":false}',Lore:['{"text":"[アイテム説明]","color":"gray","italic":false}','{"text":"すさまじい攻撃力を誇るクロスボウ","color":"gray","italic":false}','{"text":"矢を撃つと暫く使用できなくなる","color":"gray","italic":false}']},Enchantments:[{id:vanishing_curse,lvl:1}],HideFlags:63,CustomModelData:2,Tags:["strongest_crossbow","sample"]}}}

    # 頑丈な斧   
        data modify entity @s[tag=shop_2] Offers.Recipes append value {rewardExp:0b,maxUses:2147483647,xp:0,buy:{id:"minecraft:emerald",Count:1b},sell:{id:"minecraft:iron_axe",Count:1b,tag:{Unbreakable:1,CanDestroy:["oak_log"],display:{Name:'{"text":"予備の頑丈な斧","italic":false,"color":"white"}',Lore:['{"text":"[アイテム説明]","italic":false,"color":"gray"}','{"text": "いくら使っても壊れる気配のない斧","color": "gray","italic": false}','{"text": "攻撃するためのものではない","color": "gray","italic": false}','{"text": "                                  ","color": "gray","strikethrough": true}','{"translate": "採集可能: ","color": "gray","italic": false,"extra": [{"translate": "","color": "white","italic": false}]}']},AttributeModifiers:[{AttributeName:"generic.attack_damage",Name:"generic.attack_damage",Amount:-999,Operation:0,UUID:[I;386475636,-602544697,-872632307,-878740317],Slot:"mainhand"}],HideFlags:63,Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}]}}}
    # 頑丈なツルハシ   
        data modify entity @s[tag=shop_2] Offers.Recipes append value {rewardExp:0b,maxUses:2147483647,xp:0,buy:{id:"minecraft:emerald",Count:1b},sell:{id:"minecraft:iron_pickaxe",Count:1b,tag:{Unbreakable:1,CanDestroy:["iron_ore"],display:{Name:'{"text":"予備の頑丈なツルハシ","italic":false,"color":"white"}',Lore:['{"text":"[アイテム説明]","italic":false,"color":"gray"}','{"text": "いくら使っても壊れる気配のないツルハシ","color": "gray","italic": false}','{"text": "攻撃するためのものではない","color": "gray","italic": false}','{"text": "                                  ","color": "gray","strikethrough": true}','{"translate": "採集可能: ","color": "gray","italic": false,"extra": [{"translate": "\\uE100","color": "white","italic": false}]}']},AttributeModifiers:[{AttributeName:"generic.attack_damage",Name:"generic.attack_damage",Amount:-999,Operation:0,UUID:[I;985467286,-600986397,-872473827,-446866897],Slot:"mainhand"}],HideFlags:63,Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}]}}}
    # 特殊アイテム
    # 煙玉
        schedule function werewolf:shop/add_products/bombs/smoke_bomb 1t append false
    # 手投げ爆弾
        schedule function werewolf:shop/add_products/bombs/tnt_bomb 1t append false
    # 盲目付与ツール
        schedule function werewolf:shop/add_products/blindness_tool 1t append false
    # 容姿統一ツール
        schedule function werewolf:shop/add_products/same_look_tool 1t append false
    # 発光ツール
        schedule function werewolf:shop/add_products/glowing_tool 1t append false
    # テレポートツール
        schedule function werewolf:shop/add_products/teleport_tool 1t append false
    #ポーション
    # 透明化のポーション
        schedule function werewolf:shop/add_products/potions/invisibility 1t append false
    # 俊敏のポーション
        schedule function werewolf:shop/add_products/potions/speed 1t append false
    # 毒のスプラッシュポーション
        schedule function werewolf:shop/add_products/potions/poison_splash 1t append false
    # 鈍化のスプラッシュポーション
        schedule function werewolf:shop/add_products/potions/slowness_splash 1t append false
    # 再生のスプラッシュポーション
        schedule function werewolf:shop/add_products/potions/regeneration_splash 1t append false
    # テンプレ
    #data modify entity @s Offers.Recipes append value {rewardExp:0b,maxUses:2147483647,xp:0,buy:{id:"minecraft:emerald",Count:1b},sell:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{display:{Name:'{"text":"","color":"white","italic":false}',Lore:['{"text":"[アイテム説明]","color":"gray","italic":false}','{"text":"","color":"gray","italic":false}','{"text":"","color":"gray","italic":false}']},Enchantments:[{id:vanishing_curse,lvl:1}],HideFlags:63,CustomModelData:0,Tags:["","sample"]}}}
    #summon wandering_trader ~ ~ ~ {Silent:1b,Invulnerable:1b,NoAI:1b,Tags:["test"],CustomName:'{"text":"test"}',Offers:{Recipes:[]}}
    #execute align xyz run summon wandering_trader ~0.5 ~ ~0.5 {Silent:1b,Invulnerable:1b,NoAI:1b,Tags:["shop_1"],CustomName:'{"text":"買取/食料"}',CustomNameVisible:1,Offers:{Recipes:[]},Rotation:[0f,0f]}
    #execute align xyz run summon wandering_trader ~0.5 ~ ~0.5 {Silent:1b,Invulnerable:1b,NoAI:1b,Tags:["shop_2"],CustomName:'{"text":"武器/ツール"}',CustomNameVisible:1,Offers:{Recipes:[]},Rotation:[0f,0f]}
    #execute align xyz run summon wandering_trader ~0.5 ~ ~0.5 {Silent:1b,Invulnerable:1b,NoAI:1b,Tags:["shop_3"],CustomName:'{"text":"特殊アイテム"}',CustomNameVisible:1,Offers:{Recipes:[]},Rotation:[0f,0f]}
    #execute align xyz run summon wandering_trader ~0.5 ~ ~0.5 {Silent:1b,Invulnerable:1b,NoAI:1b,Tags:["shop_4"],CustomName:'{"text":"ポーション"}',CustomNameVisible:1,Offers:{Recipes:[]},Rotation:[0f,0f]}