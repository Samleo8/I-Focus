using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.ComponentModel;

namespace Calibration
{
    public delegate void MouseHookEventHandler(object sender, MouseHookEventArgs e);

    public class MouseHookEventArgs : EventArgs
    {
        public int X { get; private set; }
        public int Y { get; private set; }
        public MouseHookEventArgs(int X, int Y)
        {
            this.X = X;
            this.Y = Y;
        }
    }

    public partial class MouseHook : IDisposable
    {
        private bool disposed = false;
        private IntPtr hHook = IntPtr.Zero;

        public event MouseHookEventHandler MouseMovement;

        ~MouseHook()
        {
            Dispose(false);
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        private void Dispose(bool disposing)
        {
            if (!disposed)
            {
                disposed = true;
                StopMouseHook(false);
            }
        }

        protected virtual void OnMouseMovement(MouseHookEventArgs e)
        {
            if (MouseMovement != null)
                MouseMovement(this, e);
        }

        private IntPtr mouseProc(int code, WM wParam, ref MSLLHOOKSTRUCT lParam)
        {
            // MSDN says only process msg if code >= 0, and filter for movement events
            if (code >= 0 && wParam == WM.MOUSEMOVE)
            {
                // Raise our mousemovement event
                OnMouseMovement(new MouseHookEventArgs(lParam.pt.x, lParam.pt.y));
            }

            return CallNextHookEx(IntPtr.Zero, code, wParam, ref lParam);

        }

        public void StartMouseHook()
        {
            // Insert global low-level mouse hook, tell Windows to call our mouseProc method
            hHook = SetWindowsHookEx(HookType.WH_MOUSE_LL, mouseProc, IntPtr.Zero, 0);
            if (hHook == IntPtr.Zero)
                throw new Win32Exception(Marshal.GetLastWin32Error());
        }

        public void StopMouseHook()
        {
            StopMouseHook(true);
        }

        private void StopMouseHook(bool ThrowExceptionOnError)
        {
            if (hHook != IntPtr.Zero)
            {
                bool success = UnhookWindowsHookEx(hHook);
                if (!success && ThrowExceptionOnError)
                    throw new Win32Exception(Marshal.GetLastWin32Error());
            }
        }
    }
}