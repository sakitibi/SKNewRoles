import { CustomCommandOrigin, system } from "@minecraft/server";
import { name } from "../definition";

export const sdaFatalPoison = (origin:CustomCommandOrigin) => {
    if(Number(origin.sourceEntity?.getDynamicProperty("mp")) < 20){
        origin.sourceEntity?.runCommandAsync(`tellraw @s {"rawtext":[{"text":"魔力が足りません!"}]}`);
        return;
    }
    system.runTimeout(async() => {
        for(let i = 0;i < name.length;i++){
            const result1 = await origin.sourceEntity?.runCommandAsync(`effect @a[name=${name[i]}] fatal_poison 30 0 true`);
            const result2 = await origin.sourceEntity?.runCommandAsync(`effect @a[name=${name[i]}] instant_damage 1 2 true`);
            const result3 = await origin.sourceEntity?.runCommandAsync(`effect @a[name=${name[i]}] blindness 30 255 true`);
            if(
                result1!.successCount > 0 &&
                result2!.successCount > 0 &&
                result3!.successCount > 0
            ){
                origin.sourceEntity?.runCommandAsync(`tellraw @s {"rawtext":[{"text":"§9ヒェーッヒェッヒェッヒェッ、${name[i]}\nに見つからないように魔の呪文をかけたぜ"}]}`);
            } else {
                origin.sourceEntity?.runCommandAsync(`tellraw @s {"rawtext":[{"text":"§9${name[i]}\nに魔の呪文が効かない!?"}]}`);
            }
        }
    })
}

export const sdaDevilFatalPoison = (origin:CustomCommandOrigin) => {
    if(Number(origin.sourceEntity?.getDynamicProperty("mp")) < 30){
        origin.sourceEntity?.runCommandAsync(`tellraw @s {"rawtext":[{"text":"魔力が足りません!"}]}`);
        return;
    }
    system.runTimeout(async() => {
        for(let i = 0;i < name.length;i++){
            system.runTimeout(async() => {
                const result1 = await origin.sourceEntity?.runCommandAsync(`effect @a[name=${name[i]}] fatal_poison 60 0 true`);
                const result2 = await origin.sourceEntity?.runCommandAsync(`effect @a[name=${name[i]}] instant_damage 1 3 true`);
                const result3 = await origin.sourceEntity?.runCommandAsync(`effect @a[name=${name[i]}] blindness 60 255 true`);
                if(
                    result1!.successCount > 0 &&
                    result2!.successCount > 0 &&
                    result3!.successCount > 0
                ){
                    origin.sourceEntity?.runCommandAsync(`tellraw @s {"rawtext":[{"text":"§9ヒェーッヒェッヒェッヒェッ、${name[i]}\nにかけた悪魔の呪文が効いてきたぜ"}]}`);
                } else {
                    origin.sourceEntity?.runCommandAsync(`tellraw @s {"rawtext":[{"text":"§9${name[i]}\nに悪魔の呪文が効かない!?"}]}`);
                }
            }, 600);
            origin.sourceEntity?.runCommandAsync(`tellraw @s {"rawtext":[{"text":"§9ヒェーッヒェッヒェッヒェッ、${name[i]}\nに見つからないように悪魔の呪文をかけたぜ"}]}`);
        }
    })
}