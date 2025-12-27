import { system, CommandPermissionLevel, CustomCommandParamType } from "@minecraft/server";
import {
    sdaHelp,
    sdaTestfor,
    sdaWarp
} from "./cmd";
import {
    sdaFatalPoison,
    sdaDevilFatalPoison
} from "./cmd/poison";
import { world } from "@minecraft/server";
import { name } from "./definition";
import {
    sdaSleepHypnosys,
    sdaDevilSleepHypnosys
} from "./cmd/hypnosys";

system.runInterval(() => {
    const players = world.getAllPlayers();
    for(let i = 0;i < players.length;i++){
        let passed = [];
        for(let j = 0;j < name.length;j++){
            if(players[i].name !== name[j]){
                passed[j] = true;
            } else {
                passed[j] = false;
            }
        }
        if(passed.filter(data => data).length === name.length){
            if(typeof players[i].getDynamicProperty("mp") === "undefined"){
                players[i].setDynamicProperty("mp", 0);
            } else {
                continue;
            }
        } else {
            continue;
        }
    }
})

system.runInterval(() => {
    const players = world.getAllPlayers();
    for(let i = 0;i < players.length;i++){
        let passed = [];
        for(let j = 0;j < name.length;j++){
            if(players[i].name !== name[j]){
                passed[j] = true;
            } else {
                passed[j] = false;
            }
        }
        if(passed.filter(data => data).length === name.length){
            players[i].setDynamicProperty("mp", Number(players[i].getDynamicProperty("mp")) + 1);
            continue;
        } else {
            continue;
        }
    }
}, 30);

system.runInterval(() => {
    const players = world.getAllPlayers();
    for(let i = 0;i < players.length;i++){
        if(players[i].getDynamicProperty("sleep_level") === 1){
            players[i]?.runCommand(`effect @a[name=${players[i].name}] slowness 30 255 true`);
            players[i]?.runCommand(`effect @a[name=${players[i].name}] blindness 30 255 true`);
            players[i]?.runCommand(`effect @a[name=${players[i].name}] mining_fatigue 30 255 true`);
            players[i]?.runCommand(`effect @a[name=${players[i].name}] slow_falling 30 0 true`);
            players[i].setDynamicProperty("sleep_level", 0);
        } else if(players[i].getDynamicProperty("sleep_level") === 2){
            players[i]?.runCommand(`effect @a[name=${players[i].name}] slowness 60 1 true`);
            players[i]?.runCommand(`effect @a[name=${players[i].name}] mining_fatigue 60 0 true`);
            players[i].setDynamicProperty("sleep_level", 3);
        } else if(players[i].getDynamicProperty("sleep_level") === 4){
            players[i]?.runCommand(`effect @a[name=${players[i].name}] slowness 60 3 true`);
            players[i]?.runCommand(`effect @a[name=${players[i].name}] mining_fatigue 60 2 true`);
            players[i].setDynamicProperty("sleep_level", 5);
        } else if(players[i].getDynamicProperty("sleep_level") === 6){
            players[i]?.runCommand(`effect @a[name=${players[i].name}] slowness 300 255 true`);
            players[i]?.runCommand(`effect @a[name=${players[i].name}] blindness 300 255 true`);
            players[i]?.runCommand(`effect @a[name=${players[i].name}] mining_fatigue 300 255 true`);
            players[i]?.runCommand(`effect @a[name=${players[i].name}] slow_falling 300 0 true`);
            players[i].setDynamicProperty("sleep_level", 0);
        }
    }
})

system.beforeEvents.startup.subscribe(ev => {
    ev.customCommandRegistry.registerCommand({
        name: "sda:warp",
        description: "実行したら監視人物にワープ",
        permissionLevel: CommandPermissionLevel.Any,
        mandatoryParameters: [
            {
                name: "target",
                type: CustomCommandParamType.String
            }
        ],
        optionalParameters: [
            {
                name: "invisibility",
                type: CustomCommandParamType.Boolean
            }
        ]
    }, (origin, arg, arg2) => sdaWarp(origin, arg, arg2));

    ev.customCommandRegistry.registerCommand({
        name: "sda:help",
        description: "説明文を表示",
        permissionLevel: CommandPermissionLevel.Any,
        mandatoryParameters: [],
        optionalParameters: []
    }, (origin) => sdaHelp(origin));

    ev.customCommandRegistry.registerCommand({
        name: "sda:testfor",
        description: "監視人物がいるか検索",
        permissionLevel: CommandPermissionLevel.Any,
        mandatoryParameters: [],
        optionalParameters: []
    }, (origin) => sdaTestfor(origin));

    ev.customCommandRegistry.registerCommand({
        name: "sda:fp",
        description: "監視人物に毒の魔法をかける",
        permissionLevel: CommandPermissionLevel.Any,
        mandatoryParameters: [],
        optionalParameters: []
    }, (origin) => sdaFatalPoison(origin));

    ev.customCommandRegistry.registerCommand({
        name: "sda:devilfp",
        description: "監視人物に悪魔の毒の魔法をかける",
        permissionLevel: CommandPermissionLevel.Any,
        mandatoryParameters: [],
        optionalParameters: []
    }, (origin) => sdaDevilFatalPoison(origin));

    ev.customCommandRegistry.registerCommand({
        name: "sda:hypnosys",
        description: "監視人物に催眠術をかける",
        permissionLevel: CommandPermissionLevel.Any,
        mandatoryParameters: [],
        optionalParameters: []
    }, (origin) => sdaSleepHypnosys(origin));

    ev.customCommandRegistry.registerCommand({
        name: "sda:devilhypnosys",
        description: "監視人物に悪魔の催眠術をかける",
        permissionLevel: CommandPermissionLevel.Any,
        mandatoryParameters: [],
        optionalParameters: []
    }, (origin) => sdaDevilSleepHypnosys(origin));
});