import { CustomCommandOrigin, system, world } from "@minecraft/server";
import { helpMessages } from "./definition";

export const sdaWarp = (origin:CustomCommandOrigin, arg:string, arg2:boolean) => {
    if(Number(origin.sourceEntity?.getDynamicProperty("mp")) < 10){
        origin.sourceEntity?.runCommandAsync(`tellraw @s {"rawtext":[{"text":"魔力が足りません!"}]}`);
        return;
    }
    system.runTimeout(() => {
        origin.sourceEntity?.runCommand(`tp @s @a[name=${String(arg)},c=1]`);
        if (arg2 === true) {
            origin.sourceEntity?.runCommand("effect @s invisibility 60 255 true");
        }
        origin.sourceEntity?.runCommandAsync(`tellraw @s {"rawtext":[{"text":"魔法で${String(arg)}にテレポートして\n透明人間になりました。"}]}`);
    })
}

export const sdaHelp = (origin:CustomCommandOrigin) => {
    system.runTimeout(() => {
        for(let i = 0;i < helpMessages.length;i++){
            origin.sourceEntity?.runCommandAsync(`tellraw @s {"rawtext":[{"text":${helpMessages[i]}}]}`);
        }
    })
}

export const sdaTestfor = (origin:CustomCommandOrigin) => {
    if(Number(origin.sourceEntity?.getDynamicProperty("mp")) < 5){
        origin.sourceEntity?.runCommandAsync(`tellraw @s {"rawtext":[{"text":"魔力が足りません!"}]}`);
        return;
    }
    system.runTimeout(() => {
        const players = world.getAllPlayers();
        const playerNames = players.map((data) => {
            return data.name;
        });
        for(const playerName of playerNames){
            if(playerName === "water_challenge"){
                origin.sourceEntity?.runCommandAsync('tellraw @s {"rawtext":[{"text":"すまない先生は存在します"}]}');
            }
            if(playerName === "NMNGyuri"){
                origin.sourceEntity?.runCommandAsync('tellraw @s {"rawtext":[{"text":"名前は長い方が有利は存在します"}]}');
            }
        }
    })
}