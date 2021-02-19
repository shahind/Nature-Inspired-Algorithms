import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collector;
import java.util.stream.Collectors;

public abstract class Solution<P extends Problem, T extends Solution<P, T>> extends Object {
    public Solution(P problem) {
        this.problem = problem;
    }

    P problem;
    abstract Set<T> getNeighbors();
    abstract Set<T> getSerachPoints(int nbBees);
    abstract double quality();

    double diversity(Set<T> set) {
        return set.stream().mapToDouble(this::distance).min().orElse(0);
    }

    abstract double distance(T other);

    public T search(int numberOfLocalSearchIterations, HashSet<T> taboo) {
        List<T> searchArea = this
                .getNeighbors()
                .stream()
                .filter(x -> !taboo.contains(x))
                .sorted(Comparator.comparingDouble(sol -> -sol.quality()))
                .limit(numberOfLocalSearchIterations)
                .collect(Collectors.toList());

        taboo.addAll(searchArea);

        return searchArea.
                stream()
                .max(Comparator.comparingDouble(Solution::quality))
                .orElse(null);
    }
}
