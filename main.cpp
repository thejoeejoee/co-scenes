#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>
#include <QQmlContext>

int main(int argc, char *argv[])
{
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

    engine.loadFromModule("co-scenes", "Main");

    return app.exec();
}
