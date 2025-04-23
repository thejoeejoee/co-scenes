#include <iostream>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>
#include <QQmlContext>
#include <QSurfaceFormat>
#include <QOpenGLContext>
#include <QOffscreenSurface>
#include <QQuickRenderControl>
#include <QQmlComponent>
#include <QQuickWindow>
#include <QQuickGraphicsDevice>
#include <QOpenGLFramebufferObject>
#include <QQuickRenderTarget>
#include <QBuffer>
#include <QApplication>
#include <QLabel>
#include <QOffscreenSurface>
#include <QOpenGLContext>
#include <QOpenGLFramebufferObject>
#include <QOpenGLFunctions>
#include <QQmlComponent>
#include <QQmlEngine>
#include <QQuickGraphicsDevice>
#include <QQuickItem>
#include <QQuickRenderControl>
#include <QQuickRenderTarget>
#include <QQuickWindow>
#include <QBuffer>
#include <QSurfaceFormat>


#include "ndi.h"

int main(int argc, char **argv) {
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    const auto monospace = QFontDatabase::systemFont(QFontDatabase::FixedFont);
    engine.rootContext()->setContextProperty("monospace", monospace);

    engine.loadFromModule("co-scenes-headless", "Main");

    QSurfaceFormat format;
    format.setMajorVersion(4);
    format.setMinorVersion(6);

    QOpenGLContext gl_ctx;
    gl_ctx.setFormat(format);
    gl_ctx.create();
    if (!gl_ctx.isValid()) {
        return 1;
    }

    QOffscreenSurface surface;
    surface.setFormat(format);
    surface.create();
    if (!surface.isValid()) {
        return 1;
    }

    gl_ctx.makeCurrent(&surface);

    QQmlComponent component{&engine};

    // Create a QQuickWindow that will render the scene to a custom fb
    QQuickRenderControl control;
    QQuickWindow window{&control};
    window.setGraphicsDevice(QQuickGraphicsDevice::fromOpenGLContext(&gl_ctx));

    if (!control.initialize()) {
        qInfo() << "Failed to initialize QQuickRenderControl";
        return 0;
    }

    const auto width = 800;
    const auto height = 600;

    // Viewport size
    const QSize fb_size{width, height};

    // A custom framebuffer for rendering.
    const QOpenGLFramebufferObject fb{
        fb_size,
        QOpenGLFramebufferObject::CombinedDepthStencil
    };

    // Set the custom framebuffer's texture as the render target for the
    // Qt Quick window.
    auto tg = QQuickRenderTarget::fromOpenGLTexture(fb.texture(), fb.size());
    window.setRenderTarget(tg);

    auto ndi = Ndi::create(width, height);

    QObject::connect(
        &control, &QQuickRenderControl::sceneChanged, &control,
        [&] {
            control.polishItems();
            control.beginFrame();
            control.sync();
            control.render();
            control.endFrame();
            std::cout << "frame";
            qInfo() << "Sending frame";

            QByteArray bytes;
            QBuffer buffer(&bytes);
            buffer.open(QIODevice::WriteOnly);
            fb.toImage().save(&buffer, "PNG");
            buffer.close();

            auto *data = static_cast<unsigned char *>(malloc(bytes.size()));
            memcpy(data, bytes.data(), bytes.size());

            ndi->send(data);
        },
        Qt::QueuedConnection);

    // Reparent the loaded component to the quick window.
    QObject::connect(&component, &QQmlComponent::statusChanged, [&] {
        QObject *rootObject = component.create();
        if (component.isError()) {
            QList<QQmlError> errorList = component.errors();
            foreach(const QQmlError &error, errorList)
                qWarning() << error.url() << error.line() << error;
            return;
        }
        auto rootItem = qobject_cast<QQuickItem *>(rootObject);
        if (!rootItem) {
            qWarning("run: Not a QQuickItem");
            delete rootObject;
            return;
        }

        rootItem->setParentItem(window.contentItem());
    });

    // Load qml.
    // component.loadUrl(QUrl::fromLocalFile("main.qml"));

    return QGuiApplication::exec();
}
