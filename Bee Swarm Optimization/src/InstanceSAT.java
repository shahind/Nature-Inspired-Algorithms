import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.stream.Collectors;

public class InstanceSAT implements Problem {
    public Clause[] clauses;
    public HashSet<Integer> variables = new LinkedHashSet<>();

    private InstanceSAT(Clause[] clauses) {
        this.clauses = clauses;
        for (Clause clause : clauses) {
            variables.addAll(clause.getLiterals().stream().map(Math::abs).collect(Collectors.toSet()));
        }
    }

    public boolean satisfy(SATSolution solution) {
        for (Clause c :
                clauses)
            if (!c.satisfy(solution)) return false;

        return true;
    }

    public long numSatisfy(SATSolution solution) {
        return Arrays.stream(clauses).filter(clause -> clause.satisfy(solution)).count();
    }

    public double tauxSatisfy(SATSolution solution) {
        return (double) numSatisfy(solution) / (double) clauses.length;
    }

    public static InstanceSAT fromCNF(String file) throws IOException {
        return new InstanceSAT(Files
                .readAllLines(Paths.get(file))
                .stream()
                .filter(line -> !line.startsWith("c") && !line.startsWith("p")  && !line.startsWith("%") && !line.startsWith("0") && !line.equals(""))
                .map(line -> {
                    if (line.startsWith(" ")) line = line.substring(1);
                    String[] literals = line.split(" ");
                    LinkedHashSet<Integer> l = new LinkedHashSet<>();
                    for (int i = 0; i < literals.length - 1; i++) {
                        l.add(Integer.parseInt(literals[i]));
                    }
                    return new Clause(l);
                })
                .toArray(Clause[]::new));
    }

    @Override
    public String toString() {
        return "InstanceSAT{" +
                "clauses=" + Arrays.toString(clauses) +
                ", variables=" + variables +
                '}';
    }

    public double distance(SATSolution solution) {
        return clauses.length - numSatisfy(solution);
    }

    @Override
    public <T> boolean isOptimal(T solution) {
        return numSatisfy((SATSolution) solution) == clauses.length;
    }
}
