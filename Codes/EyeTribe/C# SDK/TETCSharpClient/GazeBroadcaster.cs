﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading;
using TETCSharpClient.Data;

namespace TETCSharpClient
{
    /// <summary>
    /// Threaded broadcaster responsible for distributing GazeData update to all attached listeners.
    /// </summary>
    internal class GazeBroadcaster
    {
        private readonly WaitHandleWrap events;
        private readonly List<IGazeListener> gazeListeners;
        private readonly FixedSizeQueue<GazeData> queue;
        private Thread workerThread;

        public GazeBroadcaster(FixedSizeQueue<GazeData> queue, List<IGazeListener> gazeListeners, WaitHandleWrap events)
        {
            this.gazeListeners = gazeListeners;
            this.queue = queue;
            this.events = events;
        }

        public void Start()
        {
            lock (this)
            {
                var ts = new ThreadStart(Work);
                workerThread = new Thread(ts);
                workerThread.Start();
            }
        }

        public void Stop()
        {
            lock (this)
            {
                events.GetKillHandle().Close();
                events.GetUpdateHandle().Set();
                events.GetUpdateHandle().Close();
            }
        }

        private void Work()
        {
            try
            {
                //while thread not killed
                while (!events.GetKillHandle().WaitOne(0, false))
                {
                    //waiting for queue to populate
                    events.GetUpdateHandle().WaitOne();

                    GazeData gaze = null;

                    lock (((ICollection)queue).SyncRoot)
                    {
                        //Use latest in queue
                        if (queue.Count > 0)
                            gaze = queue.Last();  //.ToArray()[queue.Count - 1];  //.Last();
                    }

                    lock (((ICollection)gazeListeners).SyncRoot)
                    {
                        if (null != gaze)
                        {
                            foreach (IGazeListener listener in gazeListeners)
                            {
                                try
                                {
                                    listener.OnGazeUpdate(gaze);
                                }
                                catch (Exception e)
                                {
                                    Debug.WriteLine("Exception while calling IGazeListener.OnGazeUpdate() on listener " + listener + ": " + e.Message);
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception e)
            {
                Debug.WriteLine("Exception while running broadcaster: " + e.Message);
            }
            finally
            {
                Debug.WriteLine("Broadcaster closing down");
            }
        }
    }

    public class FixedSizeQueue<T> : Queue<T>
    {
        private int limit = -1;

        public int Limit
        {
            get { return limit; }
            set { limit = value; }
        }

        public FixedSizeQueue(int limit)
            : base(limit)
        {
            this.Limit = limit;
        }

        public new void Enqueue(T item)
        {
            while (this.Count >= this.Limit)
            {
                this.Dequeue();
            }
            base.Enqueue(item);
        }
    }
}
