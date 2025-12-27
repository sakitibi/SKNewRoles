#アナウンス
tellraw @a {"interpret":true,"nbt":"delivery_bread.announce.failed.2","storage":"wolf_data:"}

#イベント失敗のペナルティ
#満腹度-10(Level40で1秒につき満腹度1消費)
effect give @a[tag=!camp_red] hunger infinite 200 true