import java.util.HashSet;

public class Clause {
    private HashSet<Integer> literals;

    public Clause(HashSet<Integer> literals) {
        this.literals = literals;
    }

    public HashSet<Integer> getLiterals() {
        return literals;
    }

    public boolean satisfy(SATSolution solution) {
        for (int literal :
                literals) {
            int abs = literal;
            boolean b2 = true;

            if (literal < 0) {
                abs = -literal;
                b2 = false;
            }
            abs--;
            boolean b = solution.literals.get(abs);
            if (b && b2) return true;
            if (!b && !b2) return true;
        }
        return false;
    }

    @Override
    public String toString() {
        return "Clause{" +
                "literals=" + literals +
                '}';
    }
}
