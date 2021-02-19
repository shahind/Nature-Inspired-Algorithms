import java.io.IOException;
import java.util.ArrayList;
import java.util.BitSet;
import java.util.Objects;

public class Test {
    public static void main(String[] args) throws IOException {
        String path = "/home/mohammedi/IdeaProjects/BSO/benchmarks/UF75.325.100/uf75-06.cnf";
        SATSolution s1 = new SATSolution(InstanceSAT.fromCNF(path));
        BitSet clone = (BitSet) s1.literals.clone();
        System.out.println("Objects.equals(tahar, zohra) = " + Objects.equals(s1.literals, clone));
        System.out.println("Objects.equals(tahar, zohra) = " + (s1.literals == clone));
    }
}
