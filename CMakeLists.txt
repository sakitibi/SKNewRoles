cmake_minimum_required(VERSION 3.16)

# プロジェクト名を設定
project(godot_player_extension)

# C++の標準規格をC++17に設定
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/bin")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/bin")

include(FetchContent)
FetchContent_Declare(
    godot-cpp
    GIT_REPOSITORY https://github.com/godotengine/godot-cpp.git
    GIT_TAG        godot-4.7-stable
)
FetchContent_MakeAvailable(godot-cpp)

# 環境変数のマクロ定義
if(DEFINED SUPABASE_URL)
    add_compile_definitions(DEFAULT_SUPABASE_URL="${SUPABASE_URL}")
endif()

if(DEFINED SUPABASE_ANON_KEY)
    add_compile_definitions(DEFAULT_SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}")
endif()

# コンパイル対象となる C++ ソースファイル
set(SOURCES
    src/register_types.cpp
    src/player.cpp
    src/grass_block.cpp
    src/lobby_manager.cpp
    src/RemotePlayer.cpp
    src/config_manager.cpp
    src/Game/RoleManager.cpp
    src/Game/chunk_manager.cpp
)

# 共有ライブラリとしてビルド
add_library(${PROJECT_NAME} SHARED ${SOURCES})

# godot-cpp とのリンク
target_link_libraries(${PROJECT_NAME} PRIVATE godot::cpp)

# インクルードパス設定
target_include_directories(${PROJECT_NAME} PRIVATE src)