cmake_minimum_required(VERSION 3.16)

set(CMAKE_PREFIX_PATH "/Users/josef.kolar/Qt/6.9.0/macos/lib/cmake")

project(co-scenes VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
find_package(Qt6 REQUIRED COMPONENTS Core Quick Widgets)
qt_standard_project_setup(REQUIRES 6.9)

qt_add_executable(co-scenes-debug main.cpp)
qt_add_executable(co-scenes-headless headless.cpp src/ndi.cpp)

qt_add_qml_module(co-scenes-debug
        URI co-scenes
        VERSION 1.0
        QML_FILES
        qml/Main.qml
        qml/CO/BoxedText.qml
        qml/CO/Symbol.qml
        qml/CO/Control.qml
        qml/CO/Runner.qml
        qml/CO/DemoList.qml
        qml/CO/Results.qml
        qml/CO/AnchoredRectangle.qml
)

qt_add_resources(co-scenes-debug "assets"
        PREFIX "/"
        FILES
        assets/co-symbol.svg
        assets/co-control.svg
        assets/flag-0.svg
        assets/flag-1.svg
        assets/flag-2.svg
)
qt_add_resources(co-scenes-headless "assets"
        PREFIX "/"
        FILES
        assets/co-symbol.svg
        assets/co-control.svg
        assets/flag-0.svg
        assets/flag-1.svg
        assets/flag-2.svg
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(co-scenes-debug PROPERTIES
        #    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.co-scenes
        MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
        MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
        MACOSX_BUNDLE TRUE
        WIN32_EXECUTABLE TRUE
)

set_target_properties(co-scenes-headless PROPERTIES PREFIX "")
if (WIN32)
    set_target_properties(co-scenes-headless PROPERTIES SUFFIX ".dll")
elseif (APPLE)
    set_target_properties(co-scenes-headless PROPERTIES SUFFIX ".dylib")
elseif (UNIx)
    set_target_properties(co-scenes-headless PROPERTIES SUFFIX ".so")
endif ()

target_include_directories(co-scenes-headless PRIVATE src)
target_include_directories(co-scenes-headless PRIVATE ndisdk/include)
target_link_directories(co-scenes-headless PRIVATE ndisdk/lib)

target_link_libraries(co-scenes-debug PRIVATE Qt6::Quick)
target_link_libraries(co-scenes-headless PRIVATE Qt6::Quick Qt6::Core Qt6::Quick Qt6::Widgets ndi)

include(GNUInstallDirs)
install(TARGETS co-scenes-debug
        BUNDLE DESTINATION .
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
install(TARGETS co-scenes-headless
        BUNDLE DESTINATION .
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
