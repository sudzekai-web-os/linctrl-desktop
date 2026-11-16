cmake_minimum_required(VERSION 3.16)

project(linctrl VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Network)

qt_standard_project_setup(REQUIRES 6.10)

# Поддержка QML Language Server
set(QT_QML_GENERATE_QMLLS_INI ON)

if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/importedcontent/CMakeLists.txt")
    add_subdirectory(importedcontent)
endif()

# Исполняемый файл
qt_add_executable(applinctrl
    main.cpp
)

# Путь к заголовочным файлам
target_compile_definitions(applinctrl PRIVATE
    $<$<CONFIG:Debug>:QT_QML_DEBUG>
)

target_include_directories(applinctrl PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# QML-модуль
file(GLOB STYLE_FILES CONFIGURE_DEPENDS RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "styles/*.json")

set_source_files_properties(
    qml/state/ServerCatalog.qml
    qml/state/AccountSession.qml
    qml/state/StartupFlow.qml
    qml/state/SignInState.qml
    qml/state/ApiClient.qml
    qml/state/Session.qml
    qml/state/Plugins.qml
    qml/state/Theme.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(applinctrl
    URI linctrl
    VERSION 1.0

    RESOURCES
        ${STYLE_FILES}
        qml/fonts/Inter-Regular.ttf
        qml/fonts/Inter-Medium.ttf
        qml/fonts/Inter-Bold.ttf
        qml/fonts/Inter-SemiBold.ttf

    QML_FILES
        qml/Main.qml
        qml/state/ServerCatalog.qml
        qml/state/AccountSession.qml
        qml/state/StartupFlow.qml
        qml/state/SignInState.qml
        qml/state/ApiClient.qml
        qml/state/Session.qml
        qml/state/ServerCatalogLogic.js
        qml/state/AccountLogic.js
        qml/state/SignInLogic.js
        qml/state/ResponseEnvelope.js
        qml/state/PluginRequest.qml
        qml/state/Plugins.qml
        qml/state/PluginLogic.js
        qml/state/Theme.qml
        qml/state/ThemeLogic.js
        qml/layouts/MainLayout.qml
        qml/layouts/WorkspaceSidebar.qml
        qml/layouts/PluginPage.qml
        qml/layouts/WindowButtons.qml
        qml/layouts/TitleBar.qml
        qml/views/HomePage.qml
        qml/views/SettingsPage.qml
        qml/views/StartupPage.qml
        qml/views/ServerSelectionForm.qml
        qml/views/SignInForm.qml
        qml/views/AddServerDialog.qml
        qml/elements/TextLink.qml
        qml/views/ProfilePage.qml
        qml/views/PluginsPage.qml
        qml/elements/AppField.qml
        qml/elements/WindowResizeArea.qml
        qml/elements/AppMenuItem.qml
        qml/elements/AppComboBox.qml
        qml/elements/NavigationCard.qml
        qml/elements/AppText.qml
        qml/elements/AppCard.qml
        qml/elements/ResizableSplit.qml
        qml/elements/AppDialog.qml
        qml/elements/AppIconButton.qml
        qml/elements/SectionHeading.qml
        qml/elements/ThemeOption.qml
        # icons
        qml/icons/FullscreenIcon.qml
        qml/icons/FullscreenExitIcon.qml
        qml/icons/DashIcon.qml
        qml/icons/XIcon.qml
        # elements
        qml/elements/DefaultButton.qml

    SOURCES
        include/WindowChrome.h
        src/window/WindowChrome.cpp
        include/AppData.h
        src/AppData.cpp
        include/SessionVault.h
        src/SessionVault.cpp
        include/DesktopNetwork.h
        src/DesktopNetwork.cpp
        include/ResponseEnvelope.h
        src/ResponseEnvelope.cpp
        include/ApiResponse.h
        src/ApiResponse.cpp
        include/LoginResponse.h
        src/LoginResponse.cpp
        include/DesktopStorage.h
        src/DesktopStorage.cpp
        include/DesktopFiles.h
        src/DesktopFiles.cpp
        include/PluginFiles.h
        src/PluginFiles.cpp
        include/ServerAddress.h
        src/ServerAddress.cpp
        include/NetworkSession.h
        src/NetworkSession.cpp
        include/ThemeFiles.h
        src/ThemeFiles.cpp
        include/PluginCatalog.h
        src/PluginCatalog.cpp
        include/PluginLoader.h
        src/PluginLoader.cpp
        include/PluginDataFiles.h
        src/PluginDataFiles.cpp
        include/PluginPaths.h
        src/PluginPaths.cpp
    )

set_target_properties(applinctrl PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING
        ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(applinctrl
    PRIVATE Qt6::Quick Qt6::Network
)

if(WIN32)
    target_link_libraries(applinctrl PRIVATE comctl32 crypt32)
endif()

install(TARGETS applinctrl
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
