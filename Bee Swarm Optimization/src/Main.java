import com.github.dakusui.combinatoradix.Combinator;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Set;

public class Main {
    public static void main(String[] args) throws IOException {
        BSO<InstanceSAT, SATSolution> bso = new BSO<>(
                200,
                7,
                20,
                3,
                15
        );
        String path = "/home/mohammedi/IdeaProjects/BSO/benchmarks/UF75.325.100/uf75-06.cnf";
        InstanceSAT problem = InstanceSAT.fromCNF(path);
        SATSolution beeInit = new SATSolution(problem);

        System.out.println("beeInit = " + beeInit);

        SATSolution solution = bso.run(beeInit);
        System.out.println("solution = " + solution);
        System.out.println("solution.problem.numSatisfy(solution) = " + solution.problem.numSatisfy(solution));
    }
}
