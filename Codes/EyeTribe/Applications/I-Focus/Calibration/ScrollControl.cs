using System;
using System.Windows.Forms;
using TETCSharpClient;
using TETCSharpClient.Data;

namespace Calibration
{
	public class ScrollControl : IGazeListener
    {
        #region Get/Set

		public Screen ActiveScreen { get; set; }
        private ScrollRegion topReg { get; set; }
        private ScrollRegion bottomReg { get; set; }
        private ScrollRegion leftReg { get; set; }
        private ScrollRegion rightReg { get; set; }
        public Boolean autoScroll { get; set; }
        public Boolean Smooth { get; set; }

        #endregion
        
        #region Constuctor

        public ScrollControl() : this(Screen.PrimaryScreen,true,true) 
        { }

		public ScrollControl(Screen screen,Boolean allowScroll,Boolean smooth)
        {
            GazeManager.Instance.Activate(GazeManager.ApiVersion.VERSION_1_0, GazeManager.ClientMode.Push);
            GazeManager.Instance.AddGazeListener(this);
            ActiveScreen = screen;
            autoScroll = allowScroll;
            Smooth = smooth;
            
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
            if (!autoScroll) return;

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
            if (screenX == 0 && screenY == 0) return;

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
        #endregion

        #region ScrollControl Native
        
        #endregion

    }
}