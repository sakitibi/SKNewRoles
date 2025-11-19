#アナウンス

#イベント失敗のペナルティ
tellraw @a {"interpret":true,"nbt":"hit_the_target.announce.failed.2","storage":"wolf_data:"}
execute at @e[type=marker,tag=spawner] run loot spawn ~ ~ ~ loot werewolf:mob_spawn/randam_event_9

#ランダムにモブをスポーン
execute at @e[type=minecraft:item,nbt={Item:{tag:{Tags:["random_spawn","skeleton_lv1"]}}}] run summon skeleton ~ ~1 ~ {CustomName:"\"スケルトン Lv.1\"",CustomNameVisible:1,Health:3,Attributes:[{Name:generic.maxHealth,Base:2},{Name:generic.attackDamage,Base:1}],DeathLootTable:"werewolf:death_loot_table/emerald_1_4",Tags:["event_skeleton","event"],PersistenceRequired:true}
execute at @e[type=minecraft:item,nbt={Item:{tag:{Tags:["random_spawn","skeleton_lv2"]}}}] run summon skeleton ~ ~1 ~ {CustomName:"\"スケルトン Lv.2\"",CustomNameVisible:1,Health:4,Attributes:[{Name:generic.maxHealth,Base:3},{Name:generic.attackDamage,Base:1.5}],DeathLootTable:"werewolf:death_loot_table/emerald_1_3",Tags:["event_skeleton","event"],PersistenceRequired:true}
execute at @e[type=minecraft:item,nbt={Item:{tag:{Tags:["random_spawn","skeleton_lv3"]}}}] run summon skeleton ~ ~1 ~ {CustomName:"\"スケルトン Lv.3\"",CustomNameVisible:1,Health:6,Attributes:[{Name:generic.maxHealth,Base:4},{Name:generic.attackDamage,Base:2}],DeathLootTable:"werewolf:death_loot_table/emerald_1_2",Tags:["event_skeleton","event"],PersistenceRequired:true}
#スポーンの演出
execute at @e[type=minecraft:item,nbt={Item:{tag:{Tags:["random_spawn"]}}}] run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a

#スポーン場所の目印アイテムを削除
kill @e[type=minecraft:item,nbt={Item:{tag:{Tags:["random_spawn"]}}}]

schedule function werewolf:random_event/hit_the_target/.end 50s