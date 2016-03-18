using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net.Sockets;
using System.Threading;
using System.IO;

using TETCSharpClient;
using TETCSharpClient.Data;
using TETCSharpClient.Reply;

using Newtonsoft;
using Newtonsoft.Json.Linq;

namespace TestProject
{
    public class GazeInit
    {
        private TcpClient socket;
        private Thread incomingThread;
        private System.Timers.Timer timerHeartbeat;
        private Boolean isRunning;

        public bool Connect(string host, int port) {
            try
            {
               socket = new TcpClient(host, port);
            }
            catch (Exception ex)
            {
                Console.Out.WriteLine("Error connecting: " + ex.Message);
                return false;
            }

            // Send the obligatory connect request message
            string REQ_CONNECT = "{\"values\":{\"push\":true,\"version\":1},\"category\":\"tracker\",\"request\":\"set\"}"; 
            Send(REQ_CONNECT);

            // Lauch a seperate thread to parse incoming data
            incomingThread = new Thread(ListenerLoop);
            incomingThread.Start();

            // Start a timer that sends a heartbeat every 250ms.
            // The minimum interval required by the server can be read out 
            // in the response to the initial connect request.   

            string REQ_HEATBEAT = "{\"category\":\"heartbeat\",\"request\":null}";
            timerHeartbeat = new System.Timers.Timer(250);
            timerHeartbeat.Elapsed += delegate { Send(REQ_HEATBEAT); };
            timerHeartbeat.Start();

            return true;
        }

        private void Send(string message)
        {
            if (socket != null && socket.Connected)
            {
                StreamWriter writer = new StreamWriter(socket.GetStream());
                writer.WriteLine(message);
                writer.Flush();
            }
        }

        public event EventHandler<ReceivedDataEventArgs> OnData;

        private void ListenerLoop() {
            StreamReader reader = new StreamReader(socket.GetStream());
            isRunning = true;

            while (isRunning)
            {
               string response = string.Empty;

                try
                {
                    response = reader.ReadLine();

                    JObject jObject = JObject.Parse(response);

                    Packet p = new Packet();
                    p.RawData = response;

                    p.Category = (string)jObject["category"];
                    p.Request = (string)jObject["request"];
                    p.StatusCode = (string)jObject["statuscode"];

                    JToken values = jObject.GetValue("values");

                    if (values != null)
                    {
                        /* 
                          We can further parse the Key-Value pairs from the values here.
                          For example using a switch on the Category and/or Request 
                          to create Gaze Data or CalibrationResult objects and pass these 
                          via separate events.
                        */
                    }

                    // Raise event with the data
                    if(OnData != null)
                       OnData(this, new ReceivedDataEventArgs(p));
                }
                catch (Exception ex)
                {
                    Console.Out.WriteLine("Error while reading response: " + ex.Message);
                }
            }
        }
    }

    public class Packet {
        public string Time = DateTime.UtcNow.Ticks.ToString();
        public string Category = string.Empty;
        public string Request = string.Empty;
        public string StatusCode = string.Empty;
        public string Values = string.Empty;
        public string RawData = string.Empty;

        public Packet() { }
    }

    public class ReceivedDataEventArgs : EventArgs {
        private Packet packet;

        public ReceivedDataEventArgs(Packet _packet)
        {
            this.packet = _packet;
        }

        public Packet Packet
        {
            get { return packet; }
        }
    }
}
