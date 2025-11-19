playsound minecraft:ui.button.click master @s ~ ~100 ~ 1 1 0.3

execute if entity @a[tag=team_kyouyuu,tag=!ex_shinigami,distance=0.01..] run tellraw @s[team=Kyouyuu] [{"text":"もう一人の共有者は… "},{"selector":"@a[tag=team_kyouyuu,tag=!ex_shinigami,distance=0.01..]"},{"text":" のようだ。"}]
execute unless entity @a[tag=team_kyouyuu,tag=!ex_shinigami,distance=0.01..] run tellraw @s[team=Kyouyuu] [{"text":"あなた以外に共有者は居ないようだ…"}]