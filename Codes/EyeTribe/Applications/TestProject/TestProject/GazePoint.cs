using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading;
using System.Diagnostics;
using System.ComponentModel;
using System.IO;

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
            double gX = gazeData.SmoothedCoordinates.X;
            double gY = gazeData.SmoothedCoordinates.Y;

            // Move point, do hit-testing, log coordinates etc.
            Console.Write(gX+" "+gY);
        }


    }
}
