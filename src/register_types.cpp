#include <godot_cpp/core/defs.hpp>
#include <godot_cpp/godot.hpp>

#include "register_types.h"
#include "player.h"
#include "grass_block.h"
#include "lobby_manager.h"
#include "RemotePlayer.h"
#include "config_manager.h"
#include "Game/RoleManager.h"
#include "Game/chunk_manager.h"
#include "Game/hud_manager.h"

#ifndef GDEXTENSION_API_CC
#define GDEXTENSION_API_CC
#endif

using namespace godot;

void initialize_player_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }
    ClassDB::register_class<SNR2Player>();
    ClassDB::register_class<SNR2GrassBlock>();
    ClassDB::register_class<LobbyManager>();
    ClassDB::register_class<RemotePlayer>();
    ClassDB::register_class<RoleManager>();
    ClassDB::register_class<ConfigManager>();
    ClassDB::register_class<ChunkManager>();
    ClassDB::register_class<HUDManager>();
}

void uninitialize_player_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }
}

extern "C" {
    GDExtensionBool player_library_init(
        GDExtensionInterfaceGetProcAddress p_get_proc_address,
        const GDExtensionClassLibraryPtr p_library,
        GDExtensionInitialization *r_initialization
    ) {
        godot::GDExtensionBinding::InitObject init_obj(p_get_proc_address, p_library, r_initialization);

        init_obj.register_initializer(initialize_player_module);
        init_obj.register_terminator(uninitialize_player_module);
        init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

        return init_obj.init();
    }
}