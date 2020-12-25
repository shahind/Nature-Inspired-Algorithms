using System;
using System.Collections.Generic;
using System.Threading;
using System.Windows.Forms;
using AnglerfishAlgorithm.Population;
using AnglerfishAlgorithm.Population.Objects;
using AnglerfishAlgorithm.TSP;

namespace AnglerfishAlgorithm
{
    public partial class Form1 : Form
    {
        delegate void SetEventCallback(string text);
        bool exit_thread = false;
        private WaitCallback callBack;

        public Form1()
        {
            InitializeComponent();
        }

        #region Utility
        private void LogEvent(string str)
        {
            if (this.listEvent.InvokeRequired)
            {
                SetEventCallback d = new SetEventCallback(LogEvent);
                this.Invoke(d, new object[] { str });
            }
            else
            {
                string msg = String.Format("{0}: {1}",
                    System.DateTime.Now,
                    str);
                listEvent.Items.Add(msg);

                listEvent.SetSelected(listEvent.Items.Count - 1, true);
            }
        }

        static void Shuffle<T>(T[] array, Random _random)
        {
            int n = array.Length;
            for (int i = 0; i < n; i++)
            {
                int r = i + (int)(_random.NextDouble() * (n - i));
                T t = array[r];
                array[r] = array[i];
                array[i] = t;
            }
        }       
        
        private int[] RemoveIndices(int[] IndicesArray, int RemoveAt)
        {
            int[] newIndicesArray = new int[IndicesArray.Length - 1];

            int i = 0;
            int j = 0;
            while (i < IndicesArray.Length)
            {
                if (i != RemoveAt)
                {
                    newIndicesArray[j] = IndicesArray[i];
                    j++;
                }
                i++;
            }
            return newIndicesArray;
        }
        #endregion

        private void btnRun_Click(object sender, EventArgs e)
        {
            exit_thread = false;
            callBack = new WaitCallback(PooledThreadFunc);

            //A thread is created so the UI thread is not blocked
            ThreadPool.QueueUserWorkItem(callBack);
        }

        private void PooledThreadFunc(object state)
        {
            
            Random _random = new Random();
            try
            {
                LogEvent("Program started...");

                string fileName = "Cities.xml";//the coordinates are kept in this file
                string atype = "GEO";//GEO or EUCL is the distance calculation type
                if (rbEUCL.Checked) atype = "EUCL";

                int minus = 8;//this corresponds to max number of males that can attached to the female
                bool isNeighbour = false;//for candidate list selection
                int timeCycle = Convert.ToInt32(txtTimeCycle.Text);//how long the program should run
                int spawnnumber = Convert.ToInt32(txtSpawnNumber.Text);//spawn number setting
                int reductionnumber = Convert.ToInt32(txtReductionNumber.Text);//reduction number setting
                int currentTime = 0;

                Cities cityList = new Cities();
                cityList.OpenCityList(fileName);
                cityList.CalculateCityDistances(atype);//create the city list

                //create a default array that corresponds to the length of city list
                int[] start = new int[cityList.Count];
                for (int m = 0; m < cityList.Count; m++)
                {
                    start[m] = m;
                }

                //initialize the population
                var population = new List<Individual>();

                //initialize young males
                int malePopulationSize = 500;
                for (int k = 0; k < malePopulationSize; k++)
                {
                    int[] m = new int[1];//create an array with only 1 city
                    m[0] = _random.Next(0, cityList.Count);//choose a random number within the city list
                    population.Add(new Male(m));//add the male into the population
                }

                //initialize young females
                int femalePopulationSize = 100;
                for (int fem = 0; fem < femalePopulationSize; fem++)
                {
                    int[] f;
                    if (!isNeighbour)
                    {
                        Shuffle(start, _random);//shuffle the default array                        
                        int r = _random.Next(cityList.Count - minus, cityList.Count);//determine how many cities in this female
                        f = new int[r];//initialize the female array in r length
                        Array.Copy(start, 0, f, 0, r);//copy the first r length from the default array to the female array
                    }
                    #region For Candidate List Only, isNeighbour=true
                    else
                    {
                        //candidate list 
                        List<int> holdCities = new List<int>();
                        for (int k = 0; k < cityList.Count; k++)
                        {
                            holdCities.Add(k);
                        }

                        f = new int[cityList.Count];

                        //Generate a first element randomly
                        f[0] = _random.Next(0, cityList.Count);
                        holdCities.RemoveAt(holdCities.IndexOf(f[0]));

                        int selectedCloseCity = int.MaxValue;
                        int selectedCloseCityIndex = 0;
                        int flag;
                        int baseCityIndex = 0;

                        for (int j = 1; j < cityList.Count; j++)
                        {
                            flag = 20;//number of close cities X 2

                            while (!holdCities.Contains(selectedCloseCity) && flag > 0)
                            {
                                //selected close city is from the last city in the f list
                                baseCityIndex = f[j - 1];
                                selectedCloseCity = cityList[baseCityIndex].CloseCities[_random.Next(0, cityList[baseCityIndex].CloseCities.Count)];
                                flag--;
                            }

                            if (!holdCities.Contains(selectedCloseCity))
                            {                                
                                selectedCloseCity = holdCities[0];
                            }
                            selectedCloseCityIndex = holdCities.IndexOf(selectedCloseCity);
                            holdCities.RemoveAt(selectedCloseCityIndex);
                            f[j] = selectedCloseCity;
                        }

                        //remove some cities off randomly
                        int tobeDiscard = _random.Next(1, minus + 1);
                        while (tobeDiscard > 0)
                        {
                            int discardIndex = _random.Next(0, f.Length);
                            f = RemoveIndices(f, discardIndex);
                            tobeDiscard--;
                        }
                    }
                    #endregion

                    Individual female = new Female(f, int.MaxValue, minus);//create a female with default legacy value
                    population.Add(female);//add the young female into the population
                }
               
                //Initialize the Simulation with all the values
                var sim = new Simulation(population, timeCycle, cityList, minus,spawnnumber,reductionnumber);

                //Start the Simulation while the conditions are true
                while ((!exit_thread) && (currentTime < timeCycle)) 
                {
                    sim.ExecuteEnvironment();
                    LogEvent("Time " + currentTime.ToString() + ": " + " Top fitness: " + sim.Population[0].Fitness.ToString() + " " + sim.Population[0].ToString());
                    currentTime++;
                }
            }
            catch (Exception ex)
            {
                LogEvent(ex.Message);
            }
            LogEvent("Program stopped.");
        }

        

        private void btnStop_Click(object sender, EventArgs e)
        {
            exit_thread = true;
        }
    }
}
