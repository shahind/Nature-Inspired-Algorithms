using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AnglerfishAlgorithm.TSP;

namespace AnglerfishAlgorithm.Population.Objects
{
    public class Male : Individual
    {
        public Male(int[] genes) : base(genes, "M", 0, 0)
        {
        }
        public override string ToString()
        {
            return base.ToString() + " Male";
        }
    }
}
