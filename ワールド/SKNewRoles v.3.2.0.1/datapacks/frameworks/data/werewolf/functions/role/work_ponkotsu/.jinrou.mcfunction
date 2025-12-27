playsound minecraft:ui.button.click master @s ~ ~100 ~ 1 1 0.3

#使用するスコアボードを初期化
    scoreboard players reset GameManager reserve_1
    scoreboard players reset GameManager reserve_2
#スコアを0に
    scoreboard players add GameManager reserve_1 0
    scoreboard players add GameManager reserve_2 0
#人狼の人数を記録    
    execute store result score GameManager reserve_1 if entity @a[tag=team_jinrou,tag=!ex_shinigami]
    execute store result score GameManager reserve_2 if entity @a[tag=team_asasine,tag=!ex_shinigami]
    scoreboard players operation GameManager reserve_1 += GameManager reserve_2
#人数に対応して役職本の内容を決定
    #人狼が0人の場合(デバッグ用)
        execute if score GameManager reserve_1 matches 0 run tellraw @s [{"text":"あなた以外に人狼は居ないようだ…"}]
    #人狼が1人の場合
        execute if score GameManager reserve_1 matches 1 run tellraw @s [{"text":"以外に人狼は居ないようだ…"}]
    #人狼が2人の場合
        #自分がtag=1の場合
        execute if entity @s[tag=1] if score GameManager reserve_1 matches 2 run tellraw @s [{"text":"今回の人狼は… "},{"selector":"@s"},{"text":", ","color":"gray"},{"selector":"@a[tag=2]"},{"text":" のようだ。"}]
        #自分がtag=1以外の場合
        execute if entity @s[tag=!1] if score GameManager reserve_1 matches 2 run tellraw @s [{"text":"今回の人狼は… "},{"selector":"@s"},{"text":", ","color":"gray"},{"selector":"@a[tag=1]"},{"text":" のようだ。"}]
    #人狼が3人の場合
        #自分がtag=1の場合
        execute if entity @s[tag=1] if score GameManager reserve_1 matches 3 run tellraw @s [{"text":"今回の人狼は… "},{"selector":"@s"},{"text":", ","color":"gray"},{"selector":"@a[tag=2]"},{"text":", ","color":"gray"},{"selector":"@a[tag=3]"},{"text":" のようだ。"}]
        #自分がtag=2の場合
        execute if entity @s[tag=2] if score GameManager reserve_1 matches 3 run tellraw @s [{"text":"今回の人狼は… "},{"selector":"@s"},{"text":", ","color":"gray"},{"selector":"@a[tag=1]"},{"text":", ","color":"gray"},{"selector":"@a[tag=3]"},{"text":" のようだ。"}]
        #自分がtag=1とtag=2以外の場合
        execute if entity @s[tag=!1,tag=!2] if score GameManager reserve_1 matches 3 run tellraw @s [{"text":"今回の人狼は… "},{"selector":"@s"},{"text":", ","color":"gray"},{"selector":"@a[tag=1]"},{"text":", ","color":"gray"},{"selector":"@a[tag=2]"},{"text":" のようだ。"}]
#念のため使用したスコアボードを初期化
    scoreboard players reset GameManager reserve_1
    scoreboard players reset GameManager reserve_2