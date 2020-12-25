using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;


namespace AnglerfishAlgorithm.TSP
{
   
    public class Cities : List<City>
    {
        public void CalculateCityDistances(string type)
        {
            foreach (City city in this)
            {
                city.Distances = new List<double>();

                if (type == "GEO")
                {
                    double latFirst, longFirst;
                    double latSecond, longSecond;

                    double PI = 3.141592;
                    int deg;
                    double min, q1, q2, q3;
                    double RRR = 6378.388;
                    double d;

                    for (int i = 0; i < this.Count; i++)
                    {
                        deg = (int)(city.Location.X);
                        min = city.Location.X - deg;
                        latFirst = PI * (deg + 5 * min / 3) / 180;
                        deg = (int)city.Location.Y;
                        min = city.Location.Y - deg;
                        longFirst = PI * (deg + 5 * min / 3) / 180;

                        deg = (int)(this[i].Location.X);
                        min = this[i].Location.X - deg;
                        latSecond = PI * (deg + 5 * min / 3) / 180;
                        deg = (int)this[i].Location.Y;
                        min = this[i].Location.Y - deg;
                        longSecond = PI * (deg + 5 * min / 3) / 180;

                        q1 = Math.Cos(longFirst - longSecond);
                        q2 = Math.Cos(latFirst - latSecond);
                        q3 = Math.Cos(latFirst + latSecond);
                        d = (int)(RRR * Math.Acos(0.5 * ((1.0 + q1) * q2 - (1.0 - q1) * q3)) + 1.0);

                        city.Distances.Add(d);
                    }
                }
                else
                {

                    //eucl 2d
                    double dis = 0;
                    for (int i = 0; i < Count; i++)
                    {
                        dis = Math.Round((Math.Sqrt(Math.Pow(city.Location.X - this[i].Location.X, 2D) +
                               Math.Pow(city.Location.Y - this[i].Location.Y, 2D))), MidpointRounding.AwayFromZero);                        

                        city.Distances.Add(dis);
                    }
                }
            }


            foreach (City city in this)
            {
                city.FindClosestCities(10);
            }
        }

        public void OpenCityList(string fileName)
        {
            DataSet cityDS = new DataSet();
            
            try
            {
                Clear();

                cityDS.ReadXml(fileName);

                DataRowCollection cities = cityDS.Tables[0].Rows;

                foreach (DataRow city in cities)
                {
                    Add(new City(Convert.ToDouble(city["X"], CultureInfo.CurrentCulture), Convert.ToDouble(city["Y"], CultureInfo.CurrentCulture)));
                }
            }
            finally
            {
                cityDS.Dispose();
            }
        }
    }
}
