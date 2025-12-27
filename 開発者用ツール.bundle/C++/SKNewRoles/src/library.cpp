#include <dlfcn.h>
#include <iostream>
#include "library.hpp"

void libraryLoad() {
    // ライブラリをロード
    void* handle = dlopen("ワールド/SekaDynamicLinkLibrary/AssemblyC++.sdll", RTLD_LAZY);
    if (!handle) {
        std::cerr << "ライブラリのロードに失敗しました: " << dlerror() << std::endl;
        return;
    }

    // シンボルを取得
    typedef void (*FunctionType)();
    FunctionType func = (FunctionType)dlsym(handle, "main");
    if (!func) {
        std::cerr << "シンボルの取得に失敗しました: " << dlerror() << std::endl;
        dlclose(handle);
        return;
    }

    // 関数を呼び出し
    func();

    // ライブラリを閉じる
    dlclose(handle);
    return;
}
