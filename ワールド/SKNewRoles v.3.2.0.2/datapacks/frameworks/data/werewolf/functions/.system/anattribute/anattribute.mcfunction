scoreboard objectives add randomattribute dummy
scoreboard objectives add itemreset dummy
# anattributeがundefinedだった場合anattributeをtrueにする
execute unless data storage anattribute: {anattribute: true},{anattribute: false} run data modify anattribute: {anattribute: true}
execute if data storage anattribute: {anattribute: true} run function werewolf:.system/anattribute/anattributeexec