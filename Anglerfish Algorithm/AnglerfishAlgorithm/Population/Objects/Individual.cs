using System;
using System.Collections.Generic;
using AnglerfishAlgorithm.Population.Events;
using AnglerfishAlgorithm.TSP;
using MathNet.Numerics.Distributions;

namespace AnglerfishAlgorithm.Population.Objects
{
    public abstract class Individual    {
        
        public int LifeTime { get; set; }
        
        public int[] Genes { get; set; }
        public double Fitness { get; set; }

        public string Gender { get; set; }
        public int Legacy { get; set; }
        public int Minus { get; set; }

        protected Individual(int[] genes, string gender, int legacy, int minus)
        {
            Genes = genes;
            Gender = gender;
            Legacy = legacy;
            Minus = minus;           
        }

     
        public double DetermineFitness(Cities cities)
        {
            double fitness = 0;

            if (Genes == null) return fitness;

            int firstCity = Genes[0];
            int currentCity, nextCity;

            for (int i = 0; i < Genes.Length; i++)
            {
                currentCity = Genes[i];
                if (i == Genes.Length - 1)
                    nextCity = firstCity;
                else nextCity = Genes[i + 1];

                fitness = fitness + cities[currentCity].Distances[nextCity];
            }

            Fitness = fitness;
            return fitness;
        }

        public bool SuitablePartner(Individual individual)
        {
            return (
            individual is Male &&
            individual.Genes != null &&
            !Array.Exists(Genes, element => element == individual.Genes[0])
            );
            
        }

        

        public void FindPartner(IEnumerable<Individual> population,
  Dictionary<Event, IDistribution> distributions, Random random)
        {

            foreach (var candidate in population)
                if (SuitablePartner(candidate))
                {
                    
                    int[] oldFemaleGenes = Genes;
                    int[] newFemaleGenes = new int[oldFemaleGenes.Length + 1];

                    int newPosition = random.Next(0, newFemaleGenes.Length);
                    Array.Copy(oldFemaleGenes, 0, newFemaleGenes, 0, newPosition);
                    newFemaleGenes[newPosition] = candidate.Genes[0];
                    if (newPosition < newFemaleGenes.Length - 1)
                        Array.Copy(oldFemaleGenes, newPosition, newFemaleGenes, newPosition + 1, oldFemaleGenes.Length - newPosition);

                    Genes = newFemaleGenes;

                    candidate.Genes = null;
                    break;                    
                }
        }

        public override string ToString()
        {
            string geneStr = "Length: " + Genes.Length + ": ";
            foreach (int gene in Genes)
            {
                geneStr = geneStr + gene.ToString() + ",";
            }
            return geneStr;
        }


    }
}
