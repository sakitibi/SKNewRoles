
scoreboard players set @a time_since_death 0
# ゲームモードを変更
gamemode adventure @a
# ゲームフェイズを変更
data modify storage sys: game_phase set value 1
# インベントリメニューのモードを変更
scoreboard players set @a inventory_menu 1
item replace entity @a armor.head with air
# エフェクトの無効化
effect clear @a
# 空腹を調節
effect give @a hunger 3 200 true