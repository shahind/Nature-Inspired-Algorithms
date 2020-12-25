using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AnglerfishAlgorithm.TSP;
using AnglerfishAlgorithm.Population.Events;
using MathNet.Numerics.Distributions;

namespace AnglerfishAlgorithm.Population.Objects
{
    public class Female : Individual
    {
        public Cities Cities { get; set; }

        public Female(int[] genes, int legacy, int minus) : base(genes, "F", legacy, minus)
        {
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

        public Individual GiveBirth(Dictionary<Event, IDistribution> distributions, int maxGenes, Random random)
        {
            var sample =
              ((ContinuousUniform)distributions[Event.BirthEngageDisengage]).Sample();
            
            Individual child;
            if (sample > 0.2) // create male 
            {
                int[] mGene = new int[1];
                mGene[0] = random.Next(0, maxGenes);
                child = new Male(mGene);
            }
            else // create female
            {
                //retain most of mom's gene
                int[] childGenes = Genes;
                int tobeDiscard = random.Next(1, Minus + 1);
                while (tobeDiscard > 0)
                {
                    int discardIndex = random.Next(0, childGenes.Length);
                    childGenes = RemoveIndices(childGenes, discardIndex);
                    tobeDiscard--;
                }

                child = new Female(childGenes, Legacy, Minus);
            }

            return child;
        }

        public override string ToString()
        {
            return base.ToString() + " Female";
        }
    }
}
