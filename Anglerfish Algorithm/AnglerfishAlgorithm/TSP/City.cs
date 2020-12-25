using System;
using System.Collections.Generic;
using System.Drawing;

namespace AnglerfishAlgorithm.TSP
{
    public class City
    {
        public City(double x, double y)
        {
            Location = new PointF((float)x, (float)y);
        }

        public PointF Location { get; set; }

        public List<double> Distances { get; set; }

        private List<int> closeCities = new List<int>();
        
        public List<int> CloseCities
        {
            get
            {
                return closeCities;
            }
        }

        public void FindClosestCities(int numberOfCloseCities)
        {
            double shortestDistance;
            int shortestCity = 0;
            double[] dist = new double[Distances.Count];
            Distances.CopyTo(dist);

            if (numberOfCloseCities > Distances.Count - 1)
            {
                numberOfCloseCities = Distances.Count - 1;
            }

            closeCities.Clear();

            for (int i = 0; i < numberOfCloseCities; i++)
            {
                shortestDistance = Double.MaxValue;
                for (int cityNum = 0; cityNum < Distances.Count; cityNum++)
                {
                    if (dist[cityNum] < shortestDistance)
                    {
                        shortestDistance = dist[cityNum];
                        shortestCity = cityNum;
                    }
                }
                closeCities.Add(shortestCity);
                dist[shortestCity] = Double.MaxValue;
            }
        }
    }
}
