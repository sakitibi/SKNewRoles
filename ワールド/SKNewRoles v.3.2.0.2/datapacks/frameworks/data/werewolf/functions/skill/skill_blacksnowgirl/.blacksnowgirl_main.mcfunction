#通常
    execute unless entity @a[tag=BlacksnowgirlSorceress] run effect give @s[tag=no_jinrou] slowness 20 255 true
    execute unless entity @a[tag=BlacksnowgirlSorceress] run effect give @s[tag=no_jinrou] poison 20 0 true
    execute unless entity @a[tag=BlacksnowgirlSorceress] run effect give @s[tag=no_jinrou] mining_fatigue 20 255 true
    execute unless entity @a[tag=BlacksnowgirlSorceress] run effect give @s[tag=no_jinrou] blindness 20 255 true
    execute unless entity @a[tag=BlacksnowgirlSorceress] run effect give @s[tag=no_jinrou] weakness 20 255 true
#強化版
    execute if entity @a[tag=BlacksnowgirlSorceress] run effect give @s[tag=no_jinrou] slowness 30 255 true
    execute if entity @a[tag=BlacksnowgirlSorceress] run effect give @s[tag=no_jinrou] poison 30 0 true
    execute if entity @a[tag=BlacksnowgirlSorceress] run effect give @s[tag=no_jinrou] mining_fatigue 30 255 true
    execute if entity @a[tag=BlacksnowgirlSorceress] run effect give @s[tag=no_jinrou] blindness 30 255 true
    execute if entity @a[tag=BlacksnowgirlSorceress] run effect give @s[tag=no_jinrou] weakness 30 255 true

#メッセージ(魔女弱体化時にヒント表示)
    execute if data storage sys: {witch_weakness:true} unless entity @a[tag=BlacksnowgirlSorceress] run tellraw @s[tag=no_jinrou] [{"text":"あなたは氷の魔法少女に凍結された!","color":"aqua"}]
    execute if data storage sys: {witch_weakness:true} if entity @a[tag=BlacksnowgirlSorceress] run tellraw @s[tag=no_jinrou] [{"text":"あなたは雪女に凍結された!","color":"aqua"}]
    execute unless data storage sys: {witch_weakness:true} run tellraw @s[tag=no_jinrou] [{"text":"あなたは雪女に凍結された!","color":"aqua"}]