#include "WindowChrome.h"

#include <QGuiApplication>

#ifdef Q_OS_WIN
#include <qt_windows.h>
#include <commctrl.h>
#include <windowsx.h>

namespace
{
    bool contains(const QQuickItem *item, const QPointF &point)
    {
        return item && item->isVisible() && item->contains(item->mapFromScene(point));
    }

    RECT &clientRect(const MSG &message)
    {
        if (message.wParam)
            return reinterpret_cast<NCCALCSIZE_PARAMS *>(message.lParam)->rgrc[0];

        return *reinterpret_cast<RECT *>(message.lParam);
    }
}
#endif

WindowChrome::~WindowChrome()
{
#ifdef Q_OS_WIN
    if (active())
        RemoveWindowSubclass(reinterpret_cast<HWND>(m_handle), windowProc, 0);
#endif
}

void WindowChrome::attach(QQuickWindow *window, QQuickItem *titleBar,
                          QQuickItem *buttons, QQuickItem *maximizeButton, QQuickItem *icon)
{
#ifdef Q_OS_WIN
    if (active() || !window || !maximizeButton || QGuiApplication::platformName() != "windows")
        return;

    m_handle = window->winId();
    if (!m_handle)
        return;

    m_window = window;
    m_titleBar = titleBar;
    m_buttons = buttons;
    m_maximizeButton = maximizeButton;
    m_icon = icon;

    const auto handle = reinterpret_cast<HWND>(m_handle);
    if (!SetWindowSubclass(handle, windowProc, 0, reinterpret_cast<DWORD_PTR>(this)))
    {
        m_handle = 0;
        return;
    }

    // Keep the Win32 frame styles for system commands, while providing our own client frame.
    const auto style = GetWindowLongPtrW(handle, GWL_STYLE);
    SetWindowLongPtrW(handle, GWL_STYLE, (style & ~WS_POPUP) | WS_OVERLAPPEDWINDOW);
    SetWindowPos(handle, nullptr, 0, 0, 0, 0,
                 SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_NOACTIVATE | SWP_FRAMECHANGED);
    emit activeChanged();
#else
    Q_UNUSED(window);
    Q_UNUSED(titleBar);
    Q_UNUSED(buttons);
    Q_UNUSED(maximizeButton);
    Q_UNUSED(icon);
#endif
}

#ifdef Q_OS_WIN
LRESULT CALLBACK WindowChrome::windowProc(HWND handle, UINT message, WPARAM wParam, LPARAM lParam,
                                          UINT_PTR id, DWORD_PTR data)
{
    auto chrome = reinterpret_cast<WindowChrome *>(data);
    if (message == WM_NCDESTROY)
    {
        RemoveWindowSubclass(handle, windowProc, id);
        chrome->m_handle = 0;
    }
    else if (chrome->m_window)
    {
        MSG event{handle, message, wParam, lParam};
        LRESULT result = 0;
        if (chrome->handleMessage(event, &result))
            return result;
    }

    return DefSubclassProc(handle, message, wParam, lParam);
}

bool WindowChrome::handleMessage(const MSG &event, LRESULT *result)
{
    const auto handle = event.hwnd;
    switch (event.message)
    {
    case WM_NCCALCSIZE:
        if (IsZoomed(handle))
        {
            auto &rect = clientRect(event);
            MONITORINFO monitor{sizeof(MONITORINFO)};
            if (GetMonitorInfoW(MonitorFromRect(&rect, MONITOR_DEFAULTTONEAREST), &monitor))
                IntersectRect(&rect, &rect, &monitor.rcWork);
        }
        *result = 0;
        return true;

    case WM_NCHITTEST:
        *result = hitTest(GET_X_LPARAM(event.lParam), GET_Y_LPARAM(event.lParam));
        return true;

    case WM_NCACTIVATE:
        *result = DefWindowProcW(handle, event.message, event.wParam, -1);
        return true;

    case WM_NCPAINT:
        *result = 0;
        return true;

    case WM_NCMOUSEMOVE:
    {
        setMaximizeHovered(event.wParam == HTMAXBUTTON);
        TRACKMOUSEEVENT tracking{sizeof(TRACKMOUSEEVENT), TME_LEAVE | TME_NONCLIENT, handle, 0};
        TrackMouseEvent(&tracking);
        break;
    }

    case WM_NCMOUSELEAVE:
        if (!m_maximizePressed)
            setMaximizeHovered(false);
        break;

    case WM_NCLBUTTONDOWN:
        if (event.wParam == HTMAXBUTTON)
        {
            m_maximizePressed = true;
            SetCapture(handle);
            setMaximizeHovered(true);
            *result = 0;
            return true;
        }
        break;

    case WM_MOUSEMOVE:
        if (m_maximizePressed)
        {
            POINT point{GET_X_LPARAM(event.lParam), GET_Y_LPARAM(event.lParam)};
            ClientToScreen(handle, &point);
            setMaximizeHovered(hitTest(point.x, point.y) == HTMAXBUTTON);
            *result = 0;
            return true;
        }
        break;

    case WM_LBUTTONUP:
    case WM_NCLBUTTONUP:
        if (m_maximizePressed)
        {
            POINT point{GET_X_LPARAM(event.lParam), GET_Y_LPARAM(event.lParam)};
            if (event.message == WM_LBUTTONUP)
                ClientToScreen(handle, &point);

            const bool clicked = hitTest(point.x, point.y) == HTMAXBUTTON;
            m_maximizePressed = false;
            if (GetCapture() == handle)
                ReleaseCapture();

            if (clicked)
                PostMessageW(handle, WM_SYSCOMMAND, IsZoomed(handle) ? SC_RESTORE : SC_MAXIMIZE, 0);

            setMaximizeHovered(false);
            *result = 0;
            return true;
        }
        break;

    case WM_CANCELMODE:
    case WM_CAPTURECHANGED:
        if (m_maximizePressed)
        {
            m_maximizePressed = false;
            setMaximizeHovered(false);
        }
        break;

    case WM_NCRBUTTONUP:
        if (event.wParam == HTCAPTION || event.wParam == HTSYSMENU)
        {
            showSystemMenu(GET_X_LPARAM(event.lParam), GET_Y_LPARAM(event.lParam));
            *result = 0;
            return true;
        }
        break;

    case WM_SYSKEYDOWN:
        if (event.wParam == VK_SPACE && (event.lParam & (1L << 29)))
        {
            const auto height = m_titleBar ? m_titleBar->height() : 0;
            POINT point{0, qRound(height * m_window->devicePixelRatio())};
            ClientToScreen(handle, &point);
            showSystemMenu(point.x, point.y);
            *result = 0;
            return true;
        }
        break;
    }
    return false;
}

qintptr WindowChrome::hitTest(int screenX, int screenY) const
{
    const auto handle = reinterpret_cast<HWND>(m_handle);
    if (m_window->visibility() == QWindow::FullScreen)
        return HTCLIENT;

    POINT pixel{screenX, screenY};
    ScreenToClient(handle, &pixel);
    const auto scale = m_window->devicePixelRatio();
    const QPointF point(pixel.x / scale, pixel.y / scale);

    if (!IsZoomed(handle))
    {
        RECT rect{};
        GetClientRect(handle, &rect);
        const auto dpi = GetDpiForWindow(handle);
        const int padding = GetSystemMetricsForDpi(SM_CXPADDEDBORDER, dpi);
        const int width = GetSystemMetricsForDpi(SM_CXSIZEFRAME, dpi) + padding;
        const int height = GetSystemMetricsForDpi(SM_CYSIZEFRAME, dpi) + padding;
        const bool left = pixel.x < width;
        const bool right = pixel.x >= rect.right - width;
        const bool top = pixel.y < height;
        const bool bottom = pixel.y >= rect.bottom - height;

        if (top)
            return left ? HTTOPLEFT : right ? HTTOPRIGHT : HTTOP;
        if (bottom)
            return left ? HTBOTTOMLEFT : right ? HTBOTTOMRIGHT : HTBOTTOM;
        if (left)
            return HTLEFT;
        if (right)
            return HTRIGHT;
    }

    if (contains(m_maximizeButton, point))
        return HTMAXBUTTON;
    if (contains(m_buttons, point))
        return HTCLIENT;
    if (contains(m_icon, point))
        return HTSYSMENU;

    return contains(m_titleBar, point) ? HTCAPTION : HTCLIENT;
}

void WindowChrome::setMaximizeHovered(bool hovered)
{
    if (m_maximizeHovered == hovered)
        return;

    m_maximizeHovered = hovered;
    emit maximizeHoveredChanged();
}

void WindowChrome::showSystemMenu(int screenX, int screenY) const
{
    const auto handle = reinterpret_cast<HWND>(m_handle);
    const auto menu = GetSystemMenu(handle, FALSE);
    if (!menu)
        return;

    const bool maximized = IsZoomed(handle);
    const auto enable = [menu](UINT command, bool enabled) {
        EnableMenuItem(menu, command, MF_BYCOMMAND | (enabled ? MF_ENABLED : MF_GRAYED));
    };
    enable(SC_RESTORE, maximized);
    enable(SC_MOVE, !maximized);
    enable(SC_SIZE, !maximized);
    enable(SC_MAXIMIZE, !maximized);

    const auto command = TrackPopupMenu(menu, TPM_RETURNCMD | TPM_RIGHTBUTTON | TPM_NONOTIFY,
                                        screenX, screenY, 0, handle, nullptr);
    if (command)
        PostMessageW(handle, WM_SYSCOMMAND, command, 0);
}
#endif
