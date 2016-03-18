using System;
using TETCSharpClient;
using TETCSharpClient.Data;
using TETCSharpClient.Reply;
//using TETWinControls;

namespace Calibration
{
	public partial class GazeDot : IGazeUpdateListener
	{
		public GazeDot()
		{
			InitializeComponent();
			GazeManager.Instance.AddGazeListener(this);
		}

		public void OnScreenIndexChanged(int number)
		{
		}

		public void OnCalibrationStateChanged(bool val)
		{
		}

		public void OnGazeUpdate(GazeData gazeData)
		{
			if (Dispatcher.CheckAccess() == false)
			{
				Dispatcher.BeginInvoke(new Action(() => OnGazeUpdate(gazeData)));
				return;
			}

			// Start or stop tracking lost animation
			if ((gazeData.State & GazeData.STATE_TRACKING_GAZE) == 0 &&
			    (gazeData.State & GazeData.STATE_TRACKING_PRESENCE) == 0) return;
			//Tracking coordinates
			var d = Utility.Instance.ScaleDpi;
			var x = Utility.Instance.RecordingPosition.X;
			var y = Utility.Instance.RecordingPosition.Y;

			//var gX = gazeData.RawCoordinates.X;
			//var gY = gazeData.RawCoordinates.Y;

			var gX = gazeData.SmoothedCoordinates.X;
			var gY = gazeData.SmoothedCoordinates.Y;

			Left = d*x + d*gX - Width/2;
			Top = d*y + d*gY - Height/2;

            /*
            //SELF ADDED
            var x = ActiveScreen.Bounds.X;
            var y = ActiveScreen.Bounds.Y;
            var screenX = (int)Math.Round(x + gX, 0);
            var screenY = (int)Math.Round(y + gY, 0);

            // return in case of 0,0 
            if (screenX == 0 && screenY == 0) return;

            NativeMethods.SetCursorPos(screenX, screenY);
            //*/
		}

        public class NativeMethods
        {
            [System.Runtime.InteropServices.DllImportAttribute("user32.dll", EntryPoint = "SetCursorPos")]
            [return: System.Runtime.InteropServices.MarshalAsAttribute(System.Runtime.InteropServices.UnmanagedType.Bool)]

            public static extern bool SetCursorPos(int x, int y);
        } 
	}
}
