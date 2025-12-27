import { world, system } from "@minecraft/server";
import { INTERVAL_SEC, name } from "./definition";

system.runInterval(() => {
    const players = world.getAllPlayers();
    for (const player of players) {
        let dimension = player.dimension.id
        for (let i = 0; i < name.length; i++) {
            world.getDimension(dimension).runCommandAsync(`effect @a[name=${name[i]}] weakness 1 2 true`);
            world.getDimension(dimension).runCommandAsync(`effect @a[name=${name[i]}] slowness 1 2 true`);
        }
    }
}, INTERVAL_SEC);