playsound minecraft:ui.button.click master @s ~ ~100 ~ 1 1 0.3

execute if entity @a[tag=be_written_jackal,distance=0.01..] run tellraw @s [{"text":"今回のジャッカルは… "},{"selector":"@s"},{"text":", ","color":"gray"},{"selector":"@a[tag=be_written_jackal,distance=0.01..]"},{"text":" のようだ。"}]
execute unless entity @a[tag=be_written_jackal,distance=0.01..] run tellraw @s [{"text":"あなた以外にジャッカルは居ないようだ…"}]