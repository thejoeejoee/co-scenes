# ČO Scenes

Standalone Qt/QML application for livestream infographics used for orienteering events. The application is designed to be used with a custom QML component that renders the scene into a framebuffer object (FBO) and then displays it on the screen.

Runs in debug windowed mode, or in headless mode rendering stream as NDI output.

## Build

```bash
cmake -B build -S .
cmake --build build --parallel
```

##

```shell title="MacOS"
open co-scenes-debug.app
```

```shell title="Linux"
./build/co-scenes-debug
```