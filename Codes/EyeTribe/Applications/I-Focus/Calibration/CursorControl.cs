using System;
using System.Windows.Forms;
using TETCSharpClient;
using TETCSharpClient.Data;


namespace Calibration
{
	public class CursorControl : IGazeListener
    {
        #region Get/Set

        public static bool Enabled { get; set; }
        public static bool ScrollEnabled { get; set; }
		public static bool Smooth { get; set; }
		public Screen ActiveScreen { get; set; }
        private ScrollRegion topReg { get; set; }
        private ScrollRegion bottomReg { get; set; }
        private ScrollRegion leftReg { get; set; }
        private ScrollRegion rightReg { get; set; }

        #endregion
        
        #region Constuctor

        public CursorControl() : this(Screen.PrimaryScreen, false, false, true) 
        { }

		public CursorControl(Screen screen, bool enabled, bool scrollEnabled, bool smooth)
        {
            GazeManager.Instance.Activate(GazeManager.ApiVersion.VERSION_1_0, GazeManager.ClientMode.Push);
            GazeManager.Instance.AddGazeListener(this);
            ActiveScreen = screen;
			Enabled = enabled;
            ScrollEnabled = scrollEnabled;
		    Smooth = smooth;

            /*-------Scrolling Stuff------*/
            //Size of the scroll area, in percent
            int regWidth = 30;
            int regHeight = 10;
            int bottomPadd = 15;

            int screenHeight = screen.Bounds.Height;
            int screenWidth = screen.Bounds.Width;

            //Create Scroll Regions
            topReg = new ScrollRegion(toPercent(screenWidth, (100 - regWidth) / 2), 0, screenWidth - toPercent(screenWidth, (100 - regWidth) / 2), toPercent(screenHeight, regHeight));
            bottomReg = new ScrollRegion(toPercent(screenWidth, (100 - regWidth) / 2), screenHeight - toPercent(screenHeight, bottomPadd + (100 - regHeight) / 2), screenWidth - toPercent(screenWidth, (100 - regWidth) / 2), screenHeight - toPercent(screenHeight, bottomPadd));
            leftReg = new ScrollRegion(0, toPercent(screenHeight, (100 - regHeight) / 2), toPercent(screenWidth, regWidth), screenHeight - toPercent(screenHeight, (100 - regHeight) / 2));
            rightReg = new ScrollRegion(screenWidth - toPercent(screenHeight, regWidth), toPercent(screenHeight, (100 - regHeight) / 2), screenWidth, screenHeight - toPercent(screenHeight, (100 - regHeight) / 2));
        }

        private int toPercent(int n,int perc){
            return (n*perc)/100;
        }

        #endregion

        #region Public interface methods

        public void OnGazeUpdate(GazeData gazeData)
        {
            if (!Enabled && !ScrollEnabled) return; 

            // start or stop tracking lost animation
	        if ((gazeData.State & GazeData.STATE_TRACKING_GAZE) == 0 && (gazeData.State & GazeData.STATE_TRACKING_PRESENCE) == 0) return;
	        
			// tracking coordinates
			var x = ActiveScreen.Bounds.X;
	        var y = ActiveScreen.Bounds.Y;
	        var gX = Smooth ? gazeData.SmoothedCoordinates.X : gazeData.RawCoordinates.X;
			var gY = Smooth ? gazeData.SmoothedCoordinates.Y : gazeData.RawCoordinates.Y;
			var screenX = (int)Math.Round(x + gX, 0);
			var screenY = (int)Math.Round(y + gY, 0);

			// return in case of 0,0 
			if (screenX < 0 && screenY < 0) return;
            //Console.WriteLine("{0},{0}",screenX,screenY);

            if(Enabled){
			    NativeMethods.SetCursorPos(screenX, screenY);

                //*
                System.Drawing.Point cursorCoord;
                NativeMethods.GetCursorPos(out cursorCoord);
                if(cursorCoord.X != screenX && cursorCoord.Y != screenY){
                    Console.WriteLine("Cursor Disabled!");
                    Enabled = false;
                }//*/
            }
            
            if(ScrollEnabled){
                if (topReg.InRegion(screenX, screenY))
                {
                    Console.WriteLine("Scroll Up!");
                }
                else if (bottomReg.InRegion(screenX, screenY))
                {
                    Console.WriteLine("Scroll Down!");
                }
                else if (leftReg.InRegion(screenX, screenY))
                {
                    Console.WriteLine("Scroll Left!");
                }
                else if (rightReg.InRegion(screenX, screenY))
                {
                    Console.WriteLine("Scroll Right!");
                }
            }
        }
        #endregion

        #region CursorControl Native
        public class NativeMethods  
        {  
            [System.Runtime.InteropServices.DllImportAttribute("user32.dll", EntryPoint = "SetCursorPos")]
            [return: System.Runtime.InteropServices.MarshalAsAttribute(System.Runtime.InteropServices.UnmanagedType.Bool)]  

            public static extern bool SetCursorPos(int x, int y);

            [System.Runtime.InteropServices.DllImport("user32.dll")]
            public static extern bool GetCursorPos(out System.Drawing.Point point);
        }
        #endregion

    }
}