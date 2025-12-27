setblock ~ ~ ~ air destroy
execute align xyz positioned ~0.5 ~500.5 ~0.5 run kill @e[type=item_display,tag=select_block,distance=..0.5]
kill @s