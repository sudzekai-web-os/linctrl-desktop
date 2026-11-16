#pragma once

#include <QObject>
#include <QPointer>
#include <QQuickItem>
#include <QQuickWindow>
#include <qqmlintegration.h>

#ifdef Q_OS_WIN
#include <qt_windows.h>
#endif

class WindowChrome : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(bool active READ active NOTIFY activeChanged)
    Q_PROPERTY(bool maximizeHovered READ maximizeHovered NOTIFY maximizeHoveredChanged)

public:
    using QObject::QObject;
    ~WindowChrome() override;

    bool active() const { return m_handle != 0; }
    bool maximizeHovered() const { return m_maximizeHovered; }

    Q_INVOKABLE void attach(QQuickWindow *window, QQuickItem *titleBar,
                            QQuickItem *buttons, QQuickItem *maximizeButton, QQuickItem *icon);

signals:
    void activeChanged();
    void maximizeHoveredChanged();

private:
#ifdef Q_OS_WIN
    static LRESULT CALLBACK windowProc(HWND handle, UINT message, WPARAM wParam, LPARAM lParam,
                                       UINT_PTR id, DWORD_PTR data);
    bool handleMessage(const MSG &event, LRESULT *result);
    qintptr hitTest(int screenX, int screenY) const;
    void setMaximizeHovered(bool hovered);
    void showSystemMenu(int screenX, int screenY) const;
#endif

    quintptr m_handle = 0;
    QPointer<QQuickWindow> m_window;
    QPointer<QQuickItem> m_titleBar;
    QPointer<QQuickItem> m_buttons;
    QPointer<QQuickItem> m_maximizeButton;
    QPointer<QQuickItem> m_icon;
    bool m_maximizeHovered = false;
    bool m_maximizePressed = false;
};
