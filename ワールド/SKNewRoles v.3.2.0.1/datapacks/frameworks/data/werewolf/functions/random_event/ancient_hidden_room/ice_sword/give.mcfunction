kill @e[type=!marker,tag=ice_sword]
give @s wooden_sword{display:{Name:'{"text":"氷の剣","italic":false,"color":"white"}',Lore:['{"text":"[アイテム説明]","italic":false,"color":"gray"}','{"text": "すさまじい攻撃力を誇る氷剣","color": "gray","italic": false}','{"text": "使用または所有者の死亡で砕け散ってしまう","color": "gray","italic": false}']},AttributeModifiers:[{AttributeName:"generic.attack_damage",Name:"generic.attack_damage",Amount:999,Operation:0,UUID:[I;458711309,-74666547,-345998790,-556623094],Slot:"mainhand"}],HideFlags:63,Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}],CustomModelData:1,Tags:["ice_sword"]}

execute as @s at @s run playsound minecraft:pickup_sword master @a

advancement revoke @s only werewolf:random_event/event_11/give_ice_sword