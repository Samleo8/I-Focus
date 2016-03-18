using System;
using System.Windows.Forms;
using TETCSharpClient;
using TETCSharpClient.Data;


namespace Calibration
{
	public class ScrollRegion
    {
        #region Get/Set

		public int x1 { get; set; }
        public int x2 { get; set; }
        public int y1 { get; set; }
        public int y2 { get; set; }

        #endregion
        
        #region Constuctor

        public ScrollRegion() : this(0,0,Screen.PrimaryScreen.Bounds.X,Screen.PrimaryScreen.Bounds.Y) 
        { }

        public ScrollRegion(int _x1, int _y1, int _x2, int _y2)
        {
            //Ensure parsed region is legitamate.
            x1 = Math.Min(_x1, _x2);
            x2 = Math.Max(_x1, _x2);
            y1 = Math.Min(_y1, _y2);
            y2 = Math.Max(_y1, _y2);
        }

        #endregion

        #region Region Check

        public Boolean InRegion(int x, int y)
        {
            return (x >= x1 && x <= x2 && y >= y1 && y <= y2);  
        }
        #endregion

    }
}