# クエストジャンル
#一般
data modify storage wolf_data: quest_type.1 set value '{"text":"\\uF831\\uE001\\uF830","font":"quest_title"}'
data modify storage wolf_data: quest_announce.1 set value '[{"text":"=a-b-c-d-e-f-g-=","color":"#4e5c24","font":"announce"}]'
#村長
data modify storage wolf_data: quest_type.2 set value '{"text":"\\uF831\\uE002\\uF830","font":"quest_title"}'
#妨害
data modify storage wolf_data: quest_type.3 set value '{"text":"\\uF831\\uE003\\uF830","font":"quest_title"}'
data modify storage wolf_data: quest_announce.3 set value '[{"text":"=h-i-j-k-l-m-n-=","color":"#4e5c24","font":"announce"}]'

#共通
data modify storage wolf_data: quest_success set value '[{"text":"=\\uE300-\\uE301-\\uE302-\\uE303-\\uE304-\\uE305-\\uE306-=","color":"#4e5c24","font":"announce"}]'
data modify storage wolf_data: quest_failed set value '[{"text":"=\\uE307-\\uE308-\\uE309-\\uE30A-\\uE30B-\\uE30C-\\uE30D-=","color":"#4e5c24","font":"announce"}]'


# クエスト詳細表示用
#酸性雨
data modify storage wolf_data: acid_rain.title set value '[{"interpret":true,"nbt":"quest_type.3","storage":"wolf_data:"},{"text":"酸性雨\\uF806\\uF806\\uF806","font":"quest_title"}]'
data modify storage wolf_data: acid_rain.content.1 set value '[{"text":"目標: 30秒間雨を耐え凌ぐ\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_content1"}]'
data modify storage wolf_data: acid_rain.content.2 set value '[{"text":"報酬:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content2"}]'
data modify storage wolf_data: acid_rain.content.3 set value '[{"text":"失敗:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content3"}]'
data modify storage wolf_data: acid_rain.announce.start.1 set value '[{"text":"[システムアナウンス] クエスト発生: 酸性雨"}]'
data modify storage wolf_data: acid_rain.announce.start.2 set value '[{"text":"[システムアナウンス] 大気が不安定だ… すぐに雨が降るだろう"}]'
data modify storage wolf_data: acid_rain.announce.end.1 set value '[{"text":"[システムアナウンス] クエスト終了: 雨が降り止んだ"}]'
#data modify storage wolf_data: acid_rain.announce.end.2 set value '[{"text":""}]'
#data modify storage wolf_data: acid_rain.announce.success.1 set value '[{"text":""}]'
#data modify storage wolf_data: acid_rain.announce.success.2 set value '[{"text":""}]'
#data modify storage wolf_data: acid_rain.announce.failed.1 set value '[{"text":""}]'
#data modify storage wolf_data: acid_rain.announce.failed.2 set value '[{"text":""}]'

#パンの納品
data modify storage wolf_data: delivery_bread.title set value '[{"interpret":true,"nbt":"quest_type.3","storage":"wolf_data:"},{"text":"食料不足\\uF806\\uF806\\uF806\\uF806","font":"quest_title"}]'
data modify storage wolf_data: delivery_bread.content.1 set value '[{"text":"目標: パン10個の納品\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_content1"}]'
data modify storage wolf_data: delivery_bread.content.2 set value '[{"text":"報酬:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content2"}]'
data modify storage wolf_data: delivery_bread.content.3 set value '[{"text":"失敗: 空腹(村/第三陣営)\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803","font":"quest_content3"}]'
data modify storage wolf_data: delivery_bread.announce.start.1 set value '[{"text":"[システムアナウンス] クエスト発生: 食料不足"}]'
data modify storage wolf_data: delivery_bread.announce.start.2 set value '[{"text":"[システムアナウンス] 納品BOXにパンを10個納品しろ"}]'
#data modify storage wolf_data: delivery_bread.announce.end.1 set value '[{"text":""}]'
#data modify storage wolf_data: delivery_bread.announce.end.2 set value '[{"text":""}]'
data modify storage wolf_data: delivery_bread.announce.success.1 set value '[{"text":"[システムアナウンス] クエスト達成: 食料は無事確保された"}]'
#data modify storage wolf_data: delivery_bread.announce.success.2 set value '[{"text":""}]'
data modify storage wolf_data: delivery_bread.announce.failed.1 set value '[{"text":"[システムアナウンス] クエスト失敗: 今夜はごはん抜きになりそうだ…"}]'
data modify storage wolf_data: delivery_bread.announce.failed.2 set value '[{"text":"[システムアナウンス] ペナルティ発生: お腹が空いた…"}]'

#鮭
data modify storage wolf_data: falling_salmon.title set value '[{"interpret":true,"nbt":"quest_type.1","storage":"wolf_data:"},{"text":"飛来する鮭\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_title"}]'
data modify storage wolf_data: falling_salmon.content.1 set value '[{"text":"目的:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content1"}]'
data modify storage wolf_data: falling_salmon.content.2 set value '[{"text":"報酬:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content2"}]'
data modify storage wolf_data: falling_salmon.content.3 set value '[{"text":"失敗:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content3"}]'
data modify storage wolf_data: falling_salmon.announce.start.1 set value '[{"text":"[システムアナウンス] クエスト発生: 飛来する鮭"}]'
data modify storage wolf_data: falling_salmon.announce.start.2 set value '[{"text":"[システムアナウンス] 多数の鮭が空から降ってくる…"}]'
data modify storage wolf_data: falling_salmon.announce.end.1 set value '[{"text":"[システムアナウンス] クエスト終了: 鮭達は海へ帰っていった…"}]'
#data modify storage wolf_data: falling_salmon.announce.end.2 set value '[{"text":""}]'
#data modify storage wolf_data: falling_salmon.announce.success.1 set value '[{"text":""}]'
#data modify storage wolf_data: falling_salmon.announce.success.2 set value '[{"text":""}]'
#data modify storage wolf_data: falling_salmon.announce.failed.1 set value '[{"text":""}]'
#data modify storage wolf_data: falling_salmon.announce.failed.2 set value '[{"text":""}]'

#門封鎖
data modify storage wolf_data: monster_stampede.title set value '[{"interpret":true,"nbt":"quest_type.3","storage":"wolf_data:"},{"text":"村を封鎖せよ\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_title"}]'
data modify storage wolf_data: monster_stampede.content.1 set value '[{"text":"目標: 2人で門を封鎖する\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803","font":"quest_content1"}]'
data modify storage wolf_data: monster_stampede.content.2 set value '[{"text":"報酬:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content2"}]'
data modify storage wolf_data: monster_stampede.content.3 set value '[{"text":"失敗: モンスターの襲来\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_content3"}]'
data modify storage wolf_data: monster_stampede.announce.start.1 set value '[{"text":"[システムアナウンス] クエスト発生: 村を封鎖せよ"}]'
data modify storage wolf_data: monster_stampede.announce.start.2 set value '[{"text":"[システムアナウンス] 2人で門を封鎖してモンスターの侵入を阻止しろ"}]'
#data modify storage wolf_data: monster_stampede.announce.end.1 set value '[{"text":""}]'
data modify storage wolf_data: monster_stampede.announce.end.2 set value '[{"text":"[システムアナウンス] ペナルティ終了: モンスター達が去っていく…"}]'
data modify storage wolf_data: monster_stampede.announce.success.1 set value '[{"text":"[システムアナウンス] クエスト達成: モンスターの襲来を阻止した"}]'
#data modify storage wolf_data: monster_stampede.announce.success.2 set value '[{"text":""}]'
data modify storage wolf_data: monster_stampede.announce.failed.1 set value '[{"text":"[システムアナウンス] クエスト失敗: 今夜のモンスター襲来に備えろ"}]'
data modify storage wolf_data: monster_stampede.announce.failed.2 set value '[{"text":"[システムアナウンス] ペナルティ発生: モンスターの大群が押し寄せる…"}]'

#ウーパールーパー
data modify storage wolf_data: poison_axolotl.title set value '[{"interpret":true,"nbt":"quest_type.1","storage":"wolf_data:"},{"text":"色が異なる水の妖精\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_title"}]'
data modify storage wolf_data: poison_axolotl.content.1 set value '[{"text":"目標: 青いウーパールーパーの保護\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_content1"}]'
data modify storage wolf_data: poison_axolotl.content.2 set value '[{"text":"報酬: 最大体力の増加\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_content2"}]'
data modify storage wolf_data: poison_axolotl.content.3 set value '[{"text":"失敗:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content3"}]'
data modify storage wolf_data: poison_axolotl.announce.start.1 set value '[{"text":"[システムアナウンス] クエスト発生: 色が異なる水の妖精"}]'
data modify storage wolf_data: poison_axolotl.announce.start.2 set value '[{"text":"[システムアナウンス] 青色のウーパールーパーを保護しろ"}]'
#data modify storage wolf_data: poison_axolotl.announce.end.1 set value '[{"text":""}]'
#data modify storage wolf_data: poison_axolotl.announce.end.2 set value '[{"text":""}]'
data modify storage wolf_data: poison_axolotl.announce.success.1 set value '[{"text":"[システムアナウンス] クエスト達成: ウーパールーパー達は無事に住処へ帰っていった"}]'
#data modify storage wolf_data: poison_axolotl.announce.success.2 set value '[{"text":""}]'
data modify storage wolf_data: poison_axolotl.announce.failed.1 set value '[{"text":"[システムアナウンス] クエスト失敗: ウーパールーパー達はひっそりと居なくなった…"}]'
#data modify storage wolf_data: poison_axolotl.announce.failed.2 set value '[{"text":""}]'

#テレポート
data modify storage wolf_data: random_teleport.title set value '[{"interpret":true,"nbt":"quest_type.3","storage":"wolf_data:"},{"text":"集団テレポート\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_title"}]'
data modify storage wolf_data: random_teleport.content.1 set value '[{"text":"目標:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content1"}]'
data modify storage wolf_data: random_teleport.content.2 set value '[{"text":"報酬:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content2"}]'
data modify storage wolf_data: random_teleport.content.3 set value '[{"text":"失敗:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content3"}]'
data modify storage wolf_data: random_teleport.announce.start.1 set value '[{"text":"[システムアナウンス] クエスト発生: 集団テレポート"}]'
data modify storage wolf_data: random_teleport.announce.start.2 set value '[{"text":"[システムアナウンス] 皆の場所がランダムで入れ替わる…"}]'
data modify storage wolf_data: random_teleport.announce.end.1 set value '[{"text":"[システムアナウンス] クエスト終了: 皆の位置が入れ替わった…"}]'
#data modify storage wolf_data: random_teleport.announce.end.2 set value '[{"text":""}]'
#data modify storage wolf_data: random_teleport.announce.success.1 set value '[{"text":""}]'
#data modify storage wolf_data: random_teleport.announce.success.2 set value '[{"text":""}]'
#data modify storage wolf_data: random_teleport.announce.failed.1 set value '[{"text":""}]'
#data modify storage wolf_data: random_teleport.announce.failed.2 set value '[{"text":""}]'

#迷いオオカミ
data modify storage wolf_data: stray_wolf.title set value '[{"interpret":true,"nbt":"quest_type.1","storage":"wolf_data:"},{"text":"迷子のオオカミ\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_title"}]'
data modify storage wolf_data: stray_wolf.content.1 set value '[{"text":"目標: 子供のオオカミの保護\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_content1"}]'
data modify storage wolf_data: stray_wolf.content.2 set value '[{"text":"報酬: 移動速度の上昇\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_content2"}]'
data modify storage wolf_data: stray_wolf.content.3 set value '[{"text":"失敗:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content3"}]'
data modify storage wolf_data: stray_wolf.announce.start.1 set value '[{"text":"[システムアナウンス] クエスト発生: 迷いオオカミ"}]'
data modify storage wolf_data: stray_wolf.announce.start.2 set value '[{"text":"[システムアナウンス] どこかに子供のオオカミが迷い込んでいる…"}]'
#data modify storage wolf_data: stray_wolf.announce.end.1 set value '[{"text":""}]'
#data modify storage wolf_data: stray_wolf.announce.end.2 set value '[{"text":""}]'
data modify storage wolf_data: stray_wolf.announce.success.1 set value '[{"text":"[システムアナウンス] クエスト達成: オオカミは誰かと行動を共にするようだ"}]'
#data modify storage wolf_data: stray_wolf.announce.success.2 set value '[{"text":""}]'
data modify storage wolf_data: stray_wolf.announce.failed.1 set value '[{"text":"[システムアナウンス] クエスト失敗: オオカミは一匹寂しく立ち去った…"}]'
#data modify storage wolf_data: stray_wolf.announce.failed.2 set value '[{"text":""}]'

#リンゴの納品
data modify storage wolf_data: delivery_apple.title set value '[{"interpret":true,"nbt":"quest_type.3","storage":"wolf_data:"},{"text":"赤い果実の収穫期\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_title"}]'
data modify storage wolf_data: delivery_apple.content.1 set value '[{"text":"目標: リンゴ10個の納品\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_content1"}]'
data modify storage wolf_data: delivery_apple.content.2 set value '[{"text":"報酬:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content2"}]'
data modify storage wolf_data: delivery_apple.content.3 set value '[{"text":"失敗: 空腹(村/第三陣営)\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803","font":"quest_content3"}]'
data modify storage wolf_data: delivery_apple.announce.start.1 set value '[{"text":"[システムアナウンス] クエスト発生: 赤い果実の収穫期"}]'
data modify storage wolf_data: delivery_apple.announce.start.2 set value '[{"text":"[システムアナウンス] 納品BOXにリンゴを10個納品しろ"}]'
#data modify storage wolf_data: delivery_apple.announce.end.1 set value '[{"text":""}]'
#data modify storage wolf_data: delivery_apple.announce.end.2 set value '[{"text":""}]'
data modify storage wolf_data: delivery_apple.announce.success.1 set value '[{"text":"[システムアナウンス] クエスト達成: 収穫完了"}]'
#data modify storage wolf_data: delivery_apple.announce.success.2 set value '[{"text":""}]'
data modify storage wolf_data: delivery_apple.announce.failed.1 set value '[{"text":"[システムアナウンス] クエスト失敗: 収穫期は過ぎてしまった…"}]'
data modify storage wolf_data: delivery_apple.announce.failed.2 set value '[{"text":"[システムアナウンス] ペナルティ発生: お腹がすいた…"}]'

#的当て
data modify storage wolf_data: hit_the_target.title set value '[{"interpret":true,"nbt":"quest_type.3","storage":"wolf_data:"},{"text":"偵察部隊を撃墜せよ\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_title"}]'
data modify storage wolf_data: hit_the_target.content.1 set value '[{"text":"目標: 全てのファントムを倒す\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_content1"}]'
data modify storage wolf_data: hit_the_target.content.2 set value '[{"text":"報酬:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content2"}]'
data modify storage wolf_data: hit_the_target.content.3 set value '[{"text":"失敗: モンスターの襲来\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_content3"}]'
data modify storage wolf_data: hit_the_target.announce.start.1 set value '[{"text":"[システムアナウンス] クエスト発生: 偵察部隊を撃墜せよ"}]'
data modify storage wolf_data: hit_the_target.announce.start.2 set value '[{"text":"[システムアナウンス] 全てのファントムを矢で射抜け"}]'
#data modify storage wolf_data: hit_the_target.announce.end.1 set value '[{"text":""}]'
data modify storage wolf_data: hit_the_target.announce.end.2 set value '[{"text":"[システムアナウンス] ペナルティ終了: モンスター達が去っていく…"}]'
data modify storage wolf_data: hit_the_target.announce.success.1 set value '[{"text":"[システムアナウンス] クエスト達成: 全ての偵察部隊を撃退した"}]'
#data modify storage wolf_data: hit_the_target.announce.success.2 set value '[{"text":""}]'
data modify storage wolf_data: hit_the_target.announce.failed.1 set value '[{"text":"[システムアナウンス] クエスト失敗: 今夜のモンスター襲来に備えろ"}]'
data modify storage wolf_data: hit_the_target.announce.failed.2 set value '[{"text":"[システムアナウンス] ペナルティ発生: モンスターの大群が押し寄せる…"}]'

#村長の隠された財産
data modify storage wolf_data: hidden_property.title set value '[{"interpret":true,"nbt":"quest_type.1","storage":"wolf_data:"},{"text":"村長の隠された財産\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_title"}]'
data modify storage wolf_data: hidden_property.content.1 set value '[{"text":"目標: 村長の家の財産を探す\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_content1"}]'
data modify storage wolf_data: hidden_property.content.2 set value '[{"text":"報酬:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content2"}]'
data modify storage wolf_data: hidden_property.content.3 set value '[{"text":"失敗:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content3"}]'
data modify storage wolf_data: hidden_property.announce.start.1 set value '[{"text":"[システムアナウンス] クエスト発生: 村長の隠し財産"}]'
data modify storage wolf_data: hidden_property.announce.start.2 set value '[{"text":"[システムアナウンス] 村長の隠し財産があらわになった…"}]'
data modify storage wolf_data: hidden_property.announce.end.1 set value '[{"text":"[システムアナウンス] クエスト終了: 村長は宝を再度隠したようだ…"}]'
#data modify storage wolf_data: hidden_property.announce.end.2 set value '[{"text":""}]'
#data modify storage wolf_data: hidden_property.announce.success.1 set value '[{"text":""}]'
#data modify storage wolf_data: hidden_property.announce.success.2 set value '[{"text":""}]'
#data modify storage wolf_data: hidden_property.announce.failed.1 set value '[{"text":""}]'
#data modify storage wolf_data: hidden_property.announce.failed.2 set value '[{"text":""}]'

#古代の潜窟
data modify storage wolf_data: ancient_hidden_room.title set value '[{"interpret":true,"nbt":"quest_type.1","storage":"wolf_data:"},{"text":"古代の潜窟\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_title"}]'
data modify storage wolf_data: ancient_hidden_room.content.1 set value '[{"text":"目標: 2人で隠された部屋を開ける\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803","font":"quest_content1"}]'
data modify storage wolf_data: ancient_hidden_room.content.2 set value '[{"text":"報酬:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content2"}]'
data modify storage wolf_data: ancient_hidden_room.content.3 set value '[{"text":"失敗:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content3"}]'
data modify storage wolf_data: ancient_hidden_room.announce.start.1 set value '[{"text":"[システムアナウンス] クエスト発生: 古代の潜窟"}]'
data modify storage wolf_data: ancient_hidden_room.announce.start.2 set value '[{"text":"[システムアナウンス] どこからか不思議な力を感じる…"}]'
#data modify storage wolf_data: ancient_hidden_room.announce.end.1 set value '[{"text":""}]'
#data modify storage wolf_data: ancient_hidden_room.announce.end.2 set value '[{"text":""}]'
data modify storage wolf_data: ancient_hidden_room.announce.success.1 set value '[{"text":"[システムアナウンス] クエスト達成: どこかの扉が開いたようだ…"}]'
#data modify storage wolf_data: ancient_hidden_room.announce.success.2 set value '[{"text":""}]'
data modify storage wolf_data: ancient_hidden_room.announce.failed.1 set value '[{"text":"[システムアナウンス] クエスト失敗: 不思議な力は消え去ったようだ…"}]'
#data modify storage wolf_data: ancient_hidden_room.announce.failed.2 set value '[{"text":""}]'




#テンプレート
#画面左アナウンス
#data modify storage wolf_data: x.title set value '[{"interpret":true,"nbt":"quest_type.x","storage":"wolf_data:"},{"text":"","font":"quest_title"}]'
#data modify storage wolf_data: x.content.1 set value '[{"text":"目標: \\uF806\\uF806\\uF806","font":"quest_content1"}]'
#data modify storage wolf_data: x.content.2 set value '[{"text":"報酬:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content2"}]'
#data modify storage wolf_data: x.content.3 set value '[{"text":"失敗:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content3"}]'
#チャットアナウンス
#data modify storage wolf_data: x.announce.start.1 set value '[{"text":"[システムアナウンス] クエスト発生:"}]'
#data modify storage wolf_data: x.announce.start.2 set value '[{"text":""}]'
#data modify storage wolf_data: x.announce.end.1 set value '[{"text":"[システムアナウンス] クエスト終了:"}]'
#data modify storage wolf_data: x.announce.end.2 set value '[{"text":"[システムアナウンス] ペナルティ終了:"}]'
#data modify storage wolf_data: x.announce.success.1 set value '[{"text":"[システムアナウンス] クエスト達成:"}]'
#data modify storage wolf_data: x.announce.success.2 set value '[{"text":""}]'
#data modify storage wolf_data: x.announce.failed.1 set value '[{"text":"[システムアナウンス] クエスト失敗:"}]'
#data modify storage wolf_data: x.announce.failed.2 set value '[{"text":"[システムアナウンス] ペナルティ発生:"}]'