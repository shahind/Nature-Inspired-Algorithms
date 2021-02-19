import java.util.*;

public class SATSolution extends Solution<InstanceSAT, SATSolution> {
    BitSet literals;

    public SATSolution(InstanceSAT problem) {
        super(problem);
        int numVars = problem.variables.size();
        literals = new BitSet(numVars);
        Random random = new Random();
        for (int i = 0; i < numVars; i++) {
            literals.set(i, random.nextBoolean());
        }
    }

    public int size() {
        return literals.size();
    }

    @Override
    public String toString() {
        return "Solution{" +
                "literals=" + literals +
                '}';
    }

    @Override
    HashSet<SATSolution> getNeighbors() {

        HashSet<SATSolution> neighbors = new HashSet<>();
        for (int i = 0; i < problem.variables.size(); i++) {
            SATSolution solution = this.copy();
            solution.literals.flip(i);
            neighbors.add(solution);
        }
        return neighbors;
    }

    @Override
    Set<SATSolution> getSerachPoints(int nbBees) {
        return getSearchPoints(nbBees, 5);
    }

    Set<SATSolution> getSearchPoints(int nbBees, int flip) {

        HashSet<SATSolution> neighbors = new HashSet<>();
        int n = problem.variables.size();
        int k = n / flip;
        for (int i = 0; i < flip; i++) {
            SATSolution solution = copy();
            for (int j = 0; flip * j + i < n; j++)
                if (flip * j + i < n)
                    solution.literals.set(flip * j + i, !literals.get(flip * j + i));
            neighbors.add(solution);
        }
        return neighbors;
    }

//     List<Integer> vars = problem.variables.stream().map(x -> x - 1).collect(Collectors.toList());
//    @Override
//    HashSet<SATSolution> getNeighbors(int flip) {
//        HashSet<SATSolution> neighbors = new HashSet<>();
//        for (int f = 1; f <= flip; f++) {
//            for (List<Integer> list : new Combinator<>(vars, f)) {
//                SATSolution solution = copy();
//                for (int i :
//                        list) {
//                    solution.literals.set(i, !literals.get(i));
//                }
//                neighbors.add(solution);
//            }
//        }
//        return neighbors;
//    }


    private SATSolution copy() {
        SATSolution solution = new SATSolution(problem);
        solution.literals = (BitSet) literals.clone();
        return solution;
    }

    @Override
    double quality() {
        return problem.numSatisfy(this);
    }

    @Override
    double distance(SATSolution other) {
        BitSet d = (BitSet) literals.clone();
        d.xor(other.literals);
        return d.cardinality();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        SATSolution solution = (SATSolution) o;
        return Objects.equals(literals, solution.literals);
    }

    @Override
    public int hashCode() {

        return Objects.hash(literals);
    }
}
