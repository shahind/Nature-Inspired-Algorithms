using System;
using System.Collections.Generic;
using System.Linq;
using MathNet.Numerics.Distributions;
using AnglerfishAlgorithm.Population.Events;
using AnglerfishAlgorithm.Population.Objects;
using AnglerfishAlgorithm.TSP;

namespace AnglerfishAlgorithm.Population
{
    public class Simulation
    {
        public List<Individual> Population { get; set; }
        public int Time { get; set; }        
        private readonly Dictionary<Event, IDistribution> _distributions;
        public Cities Cities { get; set; }
        static Random _random = new Random();

        int minus;
        int SpawnNumber, Reduction;

        public Simulation(IEnumerable<Individual> population, int time, Cities cities, int mns, int sp, int r)
        {
            Population = new List<Individual>(population);
            Time = time;
            Cities = cities;
            minus = mns;
            SpawnNumber = sp;
            Reduction = r;

            _distributions = new Dictionary<Event, IDistribution>
{
{ Event.BirthEngageDisengage, new ContinuousUniform() },
                                 };

        }

        public void ExecuteEnvironment()        {
            
                //Sort the population based on Gender, Legacy
                Population.Sort((x, y) => {
                    var ret = x.Gender.CompareTo(y.Gender);
                    if (ret == 0) ret = x.Legacy.CompareTo(y.Legacy);
                    return ret;
                });

                //Mating
                for (int i = 0; i < Population.Count; i++)
                {
                    var individual = Population[i];
                    if (individual is Female)
                    {
                        int flag = minus;
                        while (individual.Genes.Length < Cities.Count && flag > 0)
                        {
                            individual.FindPartner(Population,  _distributions, _random);
                            flag--;
                        }
                    }
                    if (individual is Male) break;
                }

                //Removed all young males and young females
                Population.RemoveAll(s => s.Genes == null);
                Population.RemoveAll(s => s.Genes.Length < Cities.Count);

                //Fitness test, and sort accordingly
                Population.Sort((x, y) => {
                    var ret = x.Gender.CompareTo(y.Gender);
                    if (ret == 0) ret = y.Genes.Count().CompareTo(x.Genes.Count());
                    if (ret == 0) ret = x.DetermineFitness(Cities).CompareTo(y.DetermineFitness(Cities));
                    return ret;
                });


                // population control
                if (Population.Count > 10000)
                {
                    Population.RemoveRange(10000, Population.Count - 10000);
                }

                if (Population.Count == 0) return;           

                
                //assign legacy
                int legacy = 0;
                for (int i = 0; i < Population.Count; i++)
                {
                    var individual = Population[i];
                    if (individual.Genes.Length == Cities.Count)
                    {
                        individual.Legacy = legacy;
                        legacy = legacy + 1;
                    }
                }
                
                //Spawning
                int fitspawn = SpawnNumber;
                for (int i = 0; i < Population.Count; i++)
                {
                    var individual = Population[i];

                    if (individual.Genes.Length == Cities.Count)
                    {
                        int spawn = 0;
                        while (spawn < fitspawn)
                        {
                            Population.Add((individual as Female).GiveBirth(_distributions,
                                 Cities.Count, _random));
                            spawn++;
                        }
                
                        fitspawn = fitspawn - Reduction;
                    }
                    if (fitspawn == 0) break;
                }               
                
        }

    }
}
