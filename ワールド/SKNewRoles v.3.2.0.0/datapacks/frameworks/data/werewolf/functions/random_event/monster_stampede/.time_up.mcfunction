#アナウンス

#イベント失敗のペナルティ
tellraw @a {"interpret":true,"nbt":"monster_stampede.announce.failed.2","storage":"wolf_data:"}
execute at @e[type=marker,tag=spawner] run loot spawn ~ ~ ~ loot werewolf:mob_spawn/randam_event_1

#ランダムにモブをスポーン
execute at @e[type=minecraft:item,nbt={Item:{tag:{Tags:["random_spawn","zombie_lv1"]}}}] run summon zombie ~ ~1 ~ {CustomName:"\"ゾンビ Lv.1\"",CustomNameVisible:1,Health:3,Attributes:[{Name:generic.maxHealth,Base:2},{Name:generic.attackDamage,Base:1}],DeathLootTable:"werewolf:death_loot_table/emerald_1_4",Tags:["event_zombie","event"],PersistenceRequired:true}
execute at @e[type=minecraft:item,nbt={Item:{tag:{Tags:["random_spawn","zombie_lv2"]}}}] run summon zombie ~ ~1 ~ {CustomName:"\"ゾンビ Lv.2\"",CustomNameVisible:1,Health:4,Attributes:[{Name:generic.maxHealth,Base:3},{Name:generic.attackDamage,Base:1.5}],DeathLootTable:"werewolf:death_loot_table/emerald_1_3",Tags:["event_zombie","event"],PersistenceRequired:true}
execute at @e[type=minecraft:item,nbt={Item:{tag:{Tags:["random_spawn","zombie_lv3"]}}}] run summon zombie ~ ~1 ~ {CustomName:"\"ゾンビ Lv.3\"",CustomNameVisible:1,Health:6,Attributes:[{Name:generic.maxHealth,Base:4},{Name:generic.attackDamage,Base:2}],DeathLootTable:"werewolf:death_loot_table/emerald_1_2",Tags:["event_zombie","event"],PersistenceRequired:true}
execute at @e[type=minecraft:item,nbt={Item:{tag:{Tags:["random_spawn","witch_lv1"]}}}] run summon witch ~ ~1 ~ {CustomName:"\"Witch Lv.1\"",CustomNameVisible:1,Health:100,Attributes:[{Name:generic.maxHealth,Base:2},{Name:generic.attackDamage,Base:10}],DeathLootTable:"werewolf:death_loot_table/emerald_1_4",Tags:["event_witch","event"],PersistenceRequired:true}
execute at @e[type=minecraft:item,nbt={Item:{tag:{Tags:["random_spawn","witch_lv2"]}}}] run summon witch ~ ~1 ~ {CustomName:"\"Witch Lv.2\"",CustomNameVisible:1,Health:150,Attributes:[{Name:generic.maxHealth,Base:3},{Name:generic.attackDamage,Base:15}],DeathLootTable:"werewolf:death_loot_table/emerald_1_3",Tags:["event_witch","event"],PersistenceRequired:true}
execute at @e[type=minecraft:item,nbt={Item:{tag:{Tags:["random_spawn","witch_lv3"]}}}] run summon witch ~ ~1 ~ {CustomName:"\"witch Lv.3\"",CustomNameVisible:1,Health:200,Attributes:[{Name:generic.maxHealth,Base:4},{Name:generic.attackDamage,Base:20}],DeathLootTable:"werewolf:death_loot_table/emerald_1_2",Tags:["event_witch","event"],PersistenceRequired:true}
#スポーンの演出
execute at @e[type=minecraft:item,nbt={Item:{tag:{Tags:["random_spawn"]}}}] run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a
#スポーン場所の目印アイテムを削除
kill @e[type=minecraft:item,nbt={Item:{tag:{Tags:["random_spawn"]}}}]

schedule function werewolf:random_event/monster_stampede/.end 50s

data modify storage sys: monster_stampede set value 1