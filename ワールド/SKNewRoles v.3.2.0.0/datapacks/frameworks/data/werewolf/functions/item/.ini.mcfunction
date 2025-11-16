        #重複使用防止のアイテムフェイズを設定
            execute unless data storage sys: {item_phase:0} run data modify storage sys: item_phase set value 0
        #通常剣のクールタイム設定
        scoreboard objectives add swords_cooltime dummy

        #爆弾系の爆発までの時間を設定
        scoreboard objectives add explosion_timer dummy