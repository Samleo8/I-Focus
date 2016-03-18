﻿using System;
using Newtonsoft.Json;

namespace TETCSharpClient.Data
{
    /// <summary>
    /// Contains tracking results of a single eye.
    /// </summary>
    public class Eye
    {
        /// <summary>
        /// Raw gaze coordinates in pixels
        /// </summary>
        [JsonProperty(PropertyName = Protocol.FRAME_RAW_COORDINATES)]
        public Point2D RawCoordinates { get; set; }

        /// <summary>
        /// Smoothed gaze coordinates in pixels
        /// </summary>
        [JsonProperty(PropertyName = Protocol.FRAME_AVERAGE_COORDINATES)]
        public Point2D SmoothedCoordinates { get; set; }

        /// <summary>
        /// Pupil center coordinates in normalized values
        /// </summary>
        [JsonProperty(PropertyName = Protocol.FRAME_PUPIL_CENTER)]
        public Point2D PupilCenterCoordinates { get; set; }

        /// <summary>
        /// Pupil size in normalized value
        /// </summary>
        [JsonProperty(PropertyName = Protocol.FRAME_PUPIL_SIZE)]
        public double PupilSize { get; set; }

        public Eye()
        {
            RawCoordinates = new Point2D();
            SmoothedCoordinates = new Point2D();
            PupilCenterCoordinates = new Point2D();
            PupilSize = 0d;
        }

        public Eye(Eye other)
        {
            if (null != other)
            {
                RawCoordinates = other.RawCoordinates.Clone();
                SmoothedCoordinates = other.SmoothedCoordinates.Clone();
                PupilCenterCoordinates = other.PupilCenterCoordinates.Clone();
                PupilSize = other.PupilSize;
            }
        }

        public Eye Clone()
        {
            return new Eye(this);
        }

        public override bool Equals(Object o)
        {
            var other = o as Eye;
            if (other != null)
            {
                return
                    RawCoordinates.Equals(other.RawCoordinates) &&
                    SmoothedCoordinates.Equals(other.SmoothedCoordinates) &&
                    PupilCenterCoordinates.Equals(other.PupilCenterCoordinates) &&
                    PupilSize == other.PupilSize;
            }

            return false;
        }
    }
}