cmake_minimum_required(VERSION 3.16)

# プロジェクト名を設定
project(godot_player_extension)

# C++の標準規格をC++17に設定
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(GODOTCPP_API_VERSION "4.3" CACHE STRING "Godot API version")

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/bin")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/bin")

include(FetchContent)
FetchContent_Declare(
    godot-cpp
    GIT_REPOSITORY https://github.com/godotengine/godot-cpp.git
    GIT_TAG        master
)
FetchContent_MakeAvailable(godot-cpp)

# コンパイル対象となる C++ ソースファイル
set(SOURCES
    src/register_types.cpp
    src/player.cpp
    src/lobby_manager.cpp
    src/remote_player.cpp
    src/config_manager.cpp
    src/Blocks/falling_block.cpp
    src/Blocks/grass_block.cpp
    src/Blocks/block_registry.cpp
    src/Blocks/block_mesh_cache.cpp
    src/Game/world/cube_mesh_utils.cpp
    src/Game/world/mca_parser.cpp
    src/Game/world/chunk/chunk_block_editor.cpp
    src/Game/world/chunk/chunk_manager.cpp
    src/Game/world/chunk/chunk_mesh_builder.cpp
    src/Game/world/chunk/chunk_collision_builder.cpp
    src/Game/world/chunk/chunk_loader.cpp
    src/Game/world/chunk/chunk_spawner.cpp
    src/Game/world/chunk/chunk_veritier.cpp
    src/Game/world/chunk/builders/chunk_data_parser.cpp
    src/Game/world/chunk/builders/chunk_mesh_builder_new.cpp
    src/Game/world/chunk/builders/chunk_node_applier.cpp
    src/Game/role_manager.cpp
    src/Game/hud_manager.cpp
    src/Game/health_component.cpp
    src/Game/spectator_component.cpp
    src/Game/fall_damage_component.cpp
    src/Game/hotbar.cpp
)

# 共有ライブラリとしてビルド
add_library(${PROJECT_NAME} SHARED ${SOURCES})

if(SUPABASE_URL AND NOT "${SUPABASE_URL}" STREQUAL "")
    target_compile_definitions(${PROJECT_NAME} PRIVATE "DEFAULT_SUPABASE_URL=\"${SUPABASE_URL}\"")
endif()

if(SUPABASE_ANON_KEY AND NOT "${SUPABASE_ANON_KEY}" STREQUAL "")
    target_compile_definitions(${PROJECT_NAME} PRIVATE "DEFAULT_SUPABASE_ANON_KEY=\"${SUPABASE_ANON_KEY}\"")
endif()

# godot-cpp とのリンク
target_link_libraries(${PROJECT_NAME} PRIVATE godot::cpp)

target_include_directories(${PROJECT_NAME} PRIVATE src)