using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading;
using System.Diagnostics;
using System.ComponentModel;
using System.IO;
using System.Windows;
using System.Windows.Forms;
using MessageBox = System.Windows.MessageBox;

using TETCSharpClient;
using TETCSharpClient.Data;
using TETCSharpClient.Reply;

namespace Calibration
{
    public class GazePoint : IGazeListener
    {
        public GazePoint()
        {
            // Connect client
            GazeManager.Instance.Activate(GazeManager.ApiVersion.VERSION_1_0, GazeManager.ClientMode.Push);

            // Register this class for events
            GazeManager.Instance.AddGazeListener(this);   
        }

        public void OnGazeUpdate(GazeData gazeData)
        {
            // start or stop tracking lost animation
            if ((gazeData.State & GazeData.STATE_TRACKING_GAZE) == 0 &&
                (gazeData.State & GazeData.STATE_TRACKING_PRESENCE) == 0) return;

            // tracking coordinates
            var x = ActiveScreen.Bounds.X;
            var y = ActiveScreen.Bounds.Y;
            var gX = Smooth ? gazeData.SmoothedCoordinates.X : gazeData.RawCoordinates.X;
            var gY = Smooth ? gazeData.SmoothedCoordinates.Y : gazeData.RawCoordinates.Y;
            var screenX = (int)Math.Round(x + gX, 0);
            var screenY = (int)Math.Round(y + gY, 0);

            // return in case of 0,0 
            if (screenX == 0 && screenY == 0) return;

            NativeMethods.SetCursorPos(screenX, screenY);
        }
    }
}
