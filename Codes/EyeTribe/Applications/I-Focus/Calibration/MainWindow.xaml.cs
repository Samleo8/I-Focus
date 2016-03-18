using System;
using System.Text;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Forms;
using System.Windows.Input;

using System.ComponentModel;
using System.Windows.Interop;

using System.Diagnostics;
using System.Runtime.InteropServices;

using TETControls.Calibration;
using TETCSharpClient.Data;
using TETControls;
using TETCSharpClient;

using MessageBox = System.Windows.MessageBox;
using MessageBoxButtons = System.Windows.MessageBoxButton;

namespace Calibration
{
    public partial class MainWindow
    {
        public int calPoints = 12; //9, 12, 16
        public CursorControl cs;
        public MouseHook mHook;
        public MainWindow()
        {
            Debug.Print("\n\n\n\n\n\n\n--------------STARTING APP DEBUG--------------\n");
            //Create a client for the eye tracker
            checkConnection();

            if (GazeManager.Instance.IsCalibrated)
            {
                // Get the latest successful calibration from the EyeTribe server
                RatingText.Text = RatingFunction(GazeManager.Instance.LastCalibrationResult);
                btnCalibrate.Content = "Re-Calibrate";

                createCursorControl();
            }
            activateHotKey();
        }

        private void checkConnection()
        {
            GazeManager.Instance.Activate(GazeManager.ApiVersion.VERSION_1_0, GazeManager.ClientMode.Push);
            InitializeComponent();

            if (!GazeManager.Instance.IsConnected)
            {
                MessageBoxResult dr = confirm("EyeTribe Server has not been started!\nDo you want the program to START the EyeTribe Server?\n\nCancel to check connection again.", "EyeTribe Server", true);

                if (dr == MessageBoxResult.Yes)
                {
                    System.Diagnostics.Process.Start(@"C:\Program Files (x86)\EyeTribe\Server\EyeTribe.exe");
                    wait(3.5);
                    checkConnection();
                    return;
                }
                else if (dr == MessageBoxResult.No)
                {
                    Close();
                }
                else if (dr == MessageBoxResult.Cancel)
                {
                    GazeManager.Instance.Activate(GazeManager.ApiVersion.VERSION_1_0, GazeManager.ClientMode.Push);
                    InitializeComponent();
                    if (!GazeManager.Instance.IsConnected) Close();
                }
            }
        }

        #region Calibration Events
        private void CalibrateClicked(object sender, RoutedEventArgs e)
        {
            btnCalibrate.Content = "Re-Calibrate";
            Calibrate();
        }

        private void Calibrate()
        {
            //Run the calibration on 'this' monitor
            var ActiveScreen = Screen.FromHandle(new WindowInteropHelper(this).Handle);

            // Initialize and start the calibration
            CalibrationRunner calRunner = new CalibrationRunner(ActiveScreen, ActiveScreen.Bounds.Size, calPoints);

            var isCalibrated = calRunner.Start();
            if (!isCalibrated) return;

            // Show the rating of last accepted current calibration
            RatingText.Text = RatingFunction(GazeManager.Instance.LastCalibrationResult);
            createCursorControl();
        }
        #endregion

        #region Cursor Control
        private void createCursorControl()
        {
            try
            {
                cs = new CursorControl();
            }
            catch (Exception)
            {
                alert("ERROR: Unable to Control Cursor!", "ERROR Message");
                Close();
            }
            btnCursor.Content = "Turn ON Cursor Control";

            //*
            try
            {
                mh = new MouseHook();
                mh.MouseMovement += new MouseHookEventHandler(mh_MouseMovement);
                mh.StartMouseHook();
            }
            catch (Exception)
            {
                alert("WARNING: Unable to use mouse movement to stop eye-tracking!","WARNING Message");
            }
        }

        void mh_MouseMovement(object sender, MouseHookEventArgs e)
        {
            if (CursorControl.Enabled) return;
            else CursorControl.Enabled = false;
        }

        private void CursorControlClicked(object sender, RoutedEventArgs e)
        {
            if (!GazeManager.Instance.IsCalibrated)
            {
                alert("EyeTracker is not yet Calibrated!");
                return;
            }

            ToggleCursorControl();
        }

        private void ToggleSmooth(object sender, RoutedEventArgs e)
        {
            if (!GazeManager.Instance.IsCalibrated)
            {
                return;
            }

            if (CursorControl.Smooth)
            {
                CursorControl.Smooth = false;
            }
            else
            {
                CursorControl.Smooth = true;
            }//*/
        }

        private void ToggleCursorControl()
        {
            //alert(CursorControl.Enabled.ToString());
            if (CursorControl.Enabled)
            {
                CursorControl.Enabled = false;
                btnCursor.Content = "Turn ON Cursor Control";
            }
            else
            {
                CursorControl.Enabled = true;
                btnCursor.Content = "Turn OFF Cursor Control";//*/
            }
        }
        #endregion

        #region Calibration Points Set
        private void ClickCalPt1(object sender, RoutedEventArgs e)
        {
            calPoints = 9;
        }
        private void ClickCalPt2(object sender, RoutedEventArgs e)
        {
            calPoints = 12;
        }
        private void ClickCalPt3(object sender, RoutedEventArgs e)
        {
            calPoints = 16;
        }
        #endregion

        //*
        #region Hotkey Function
        private void OnHotKeyHandler(HotKey hotKey)
        {
            ToggleCursorControl();
        }

        private void activateHotKey()
        {
            HotKey hk = new HotKey(Key.Space, KeyModifier.Shift | KeyModifier.Ctrl, OnHotKeyHandler);
            String hkFull;
            if (!hk.working)
            {
                hotkeyTxt.Text = "Hotkey: Unavailable";
                alert("Hotkey for toggling mouse control does not work!");
            }
            else
            {
                hkFull = hk.KeyModifiers.ToString().Replace(",", " +") + " + " + hk.Key.ToString();
                Debug.Print("Hotkey Registered Successfully: " + hkFull);
                hotkeyTxt.Text = "Hotkey: " + hkFull;
            }
        }
        #endregion
        //*/

        #region Other Functions
        public void alert(String msg)
        {
            MessageBox.Show(msg);
            Debug.Print(msg);
        }
        public void alert(String msg, String caption)
        {
            MessageBox.Show(msg, caption);
            Debug.Print(msg);
        }
        public MessageBoxResult confirm(String msg)
        {
            return confirm(msg, "Confirmation Box", false);
        }
        public MessageBoxResult confirm(String msg, String caption)
        {
            return confirm(msg, caption, false);
        }
        public MessageBoxResult confirm(String msg, String caption, bool haveCancel)
        {
            return MessageBox.Show(msg, caption, haveCancel ? MessageBoxButtons.YesNoCancel : MessageBoxButtons.YesNo);
        }
        private void wait(double timeSec)
        {
            System.Threading.Thread.Sleep((int)timeSec * 1000);
        }
        private void wait(int timeSec)
        {
            System.Threading.Thread.Sleep(timeSec * 1000);
        }

        private void CloseWindow(object sender, RoutedEventArgs e)
        {
            Close();
        }
        private void RestartWindow(object sender, RoutedEventArgs e)
        {
            string path = System.IO.Path.GetDirectoryName(
                System.Windows.Forms.Application.ExecutablePath
            );
            System.Diagnostics.Process.Start(path+"\\Calibration.exe");
            Close();
        }

        private void WindowClosed(object sender, EventArgs e)
        {
            GazeManager.Instance.Deactivate();
        }
        #endregion

        #region Rating Function
        public string RatingFunction(CalibrationResult result)
        {
            var accuracy = result.AverageErrorDegree;
            var acc = " ("+Math.Round(accuracy, 2).ToString()+")";

            if (accuracy < 0.2)
            {
                return "Calibration Quality: PERFECT"+acc;
            }
            if (accuracy < 0.5)
            {
                return "Calibration Quality: VERY GOOD" + acc;
            }
            if (accuracy < 0.7)
            {
                return "Calibration Quality: GOOD"+acc;
            }
            if (accuracy < 1)
            {
                return "Calibration Quality: MODERATE"+acc;
            }
            if (accuracy < 1.5)
            {
                return "Calibration Quality: POOR"+acc;
            }
            return "Calibration Quality: REDO"+acc;
        }

        #endregion
    }
}