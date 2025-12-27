#足元に耕地を設置
execute align xyz run setblock ~ ~-1 ~ barrier replace
execute align xyz run summon block_display ~ ~-1 ~ {block_state:{Name:"minecraft:farmland",Properties:{moisture:"7"}},Tags:["amc","farmland"]}