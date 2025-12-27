import { system } from "@minecraft/server";
import { name } from "../definition";
import { CustomCommandOrigin } from "@minecraft/server";
import { world } from "@minecraft/server";

export const sdaSleepHypnosys = (origin:CustomCommandOrigin) => {
    if(Number(origin.sourceEntity?.getDynamicProperty("mp")) < 30){
        origin.sourceEntity?.runCommandAsync(`tellraw @s {"rawtext":[{"text":"魔力が足りません!"}]}`);
        return;
    }
    system.runTimeout(async() => {
        for(let i = 0;i < name.length;i++){
            system.runTimeout(async() => {
                const players = world.getAllPlayers();
                for(let j = 0;j < players.length;j++){
                    if(players[j].name === name[i]){
                        players[j].setDynamicProperty("sleep_level", 1);
                    } else {
                        continue;
                    }
                }
                origin.sourceEntity?.runCommandAsync(`tellraw @s {"rawtext":[{"text":"§9ヒェーッヒェッヒェッヒェッ、${name[i]}\nにかけた催眠術が効いてきたぜ\nこれで${name[i]}を眠らせることが出来たぜ"}]}`);
            }, 600);
            origin.sourceEntity?.runCommandAsync(`tellraw @s {"rawtext":[{"text":"§9ヒェーッヒェッヒェッヒェッ、${name[i]}\nに見つからないように催眠術をかけたぜ"}]}`);
        }
    })
}

export const sdaDevilSleepHypnosys = (origin:CustomCommandOrigin) => {
    if(Number(origin.sourceEntity?.getDynamicProperty("mp")) < 50){
        origin.sourceEntity?.runCommandAsync(`tellraw @s {"rawtext":[{"text":"魔力が足りません!"}]}`);
        return;
    }
    system.runTimeout(async() => {
        for(let i = 0;i < name.length;i++){
            system.runTimeout(async() => {
                const players = world.getAllPlayers();
                for(let j = 0;j < players.length;j++){
                    if(players[j].name === name[i]){
                        players[j].setDynamicProperty("sleep_level", 2);
                        setTimeout(async() => {
                            players[j].setDynamicProperty("sleep_level", 4);
                            setTimeout(async() => {
                                players[j].setDynamicProperty("sleep_level", 6);
                                await origin.sourceEntity?.runCommandAsync(`tellraw @s {"rawtext":[{"text":"§9ヒェーッヒェッヒェッヒェッ、${name[i]}\nにかけた悪魔の催眠術で${name[i]}は深く眠ったぜ\nこれで${name[i]}を眠らせ放題\nヒェーッヒェッヒェッヒェッ、"}]}`);
                            }, 1200);
                            await origin.sourceEntity?.runCommandAsync(`tellraw @s {"rawtext":[{"text":"§9ヒェーッヒェッヒェッヒェッ、${name[i]}\nにかけた悪魔の催眠術がかなり効いてきたぜ\nあと少しで${name[i]}は深く眠るぜ"}]}`);
                        }, 1200);
                    } else {
                        continue;
                    }
                }
                await origin.sourceEntity?.runCommandAsync(`tellraw @s {"rawtext":[{"text":"§9ヒェーッヒェッヒェッヒェッ、${name[i]}\nにかけた悪魔の催眠術が少しずつ効いてきたぜ\nこれで${name[i]}を徐々に眠らせてやるぜ"}]}`);
            }, 600);
            await origin.sourceEntity?.runCommandAsync(`tellraw @s {"rawtext":[{"text":"§9ヒェーッヒェッヒェッヒェッ、${name[i]}\nに見つからないように悪魔の催眠術をかけたぜ"}]}`);
        }
    })
}