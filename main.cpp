#include "AppData.h"
#include "DesktopFiles.h"
#include <QQmlContext>

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>
#include <QFont>
#include <QDebug>
#include <QDir>
#include <QLockFile>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    const int result = QFontDatabase::addApplicationFont(
        ":/qt/qml/linctrl/qml/fonts/Inter-Regular.ttf");

    if (result < 0)
        throw std::runtime_error("Failed to load font");

    QFontDatabase::addApplicationFont(
        ":/qt/qml/linctrl/qml/fonts/Inter-Medium.ttf");

    QFontDatabase::addApplicationFont(
        ":/qt/qml/linctrl/qml/fonts/Inter-Bold.ttf");

    QFontDatabase::addApplicationFont(
        ":/qt/qml/linctrl/qml/fonts/Inter-SemiBold.ttf");


    app.setFont(QFont("Inter", 10));

    QCoreApplication::setOrganizationName("LinCtrl");
    QCoreApplication::setApplicationName("LinCtrl");

    if (!QDir().mkpath(AppData::directory()))
    {
        qCritical() << "Cannot create app data directory";
        return 1;
    }

    QLockFile sessionLock(QDir(AppData::directory()).filePath("session.lock"));
    sessionLock.setStaleLockTime(0);
    if (!sessionLock.tryLock())
    {
        qCritical() << "Another LinCtrl session is active or the data directory is not writable";
        return 1;
    }

    DesktopFiles files;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("DesktopFiles", &files);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []()
        { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

        engine.loadFromModule("linctrl", "Main");

    return QGuiApplication::exec();
}
