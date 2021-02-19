import java.util.*;
import java.util.stream.Collectors;

public class BSO<P extends Problem, S extends Solution<P, S>> {
    private int maximumNumberOfIterations;
    private int parameterFlip;
    private int numberOfBees;
    private int maximumNumberOfChanges;
    private int numberOfLocalSearchIterations;

    public BSO(int maximumNumberOfIterations, int parameterFlip, int numberOfBees, int maximumNumberOfChanges, int numberOfLocalSearchIterations) {
        this.maximumNumberOfIterations = maximumNumberOfIterations;
        this.parameterFlip = parameterFlip;
        this.numberOfBees = numberOfBees;
        this.maximumNumberOfChanges = maximumNumberOfChanges;
        this.numberOfLocalSearchIterations = numberOfLocalSearchIterations;
    }

    public S run(S beeInit) {
        HashSet<S> taboo = new HashSet<>();
        int numberOfChanges = maximumNumberOfChanges;
        S sref = beeInit;
        S best = sref;
        int i = 0;
        while (i < maximumNumberOfIterations && !sref.problem.isOptimal(best)) {
            System.out.println("sref.quality() = " + sref.quality() + " ,sref.diversity() = " + sref.diversity(taboo) + " ,taboo = " + taboo.size());
            taboo.add(sref);
            List<S> dances =
            sref.getSerachPoints(numberOfBees)
                    .stream()
                    .filter(x -> !taboo.contains(x))
                    .sorted(Comparator.comparingDouble(sol -> -sol.quality()))
                    .limit(numberOfBees)
                    .map(solution -> solution.search(numberOfLocalSearchIterations, taboo))
                    .collect(Collectors.toList());

            S bestQuality = dances.stream().filter(Objects::nonNull).max(Comparator.comparingDouble(Solution::quality)).orElse(null);
            S bestDiversity = dances.stream().filter(Objects::nonNull).max(Comparator.comparingDouble(s -> s.diversity(taboo))).orElse(null);

            System.out.println("bestDiversity diversity = " + bestDiversity.diversity(taboo));
            System.out.println("bestQuality diversity = " + bestQuality.diversity(taboo));

            if (bestQuality.quality() > sref.quality()) sref = bestQuality;
            else {
                numberOfChanges--;
                if (numberOfChanges > 0) sref = bestQuality;
                else {
                    sref = bestDiversity;
                    numberOfChanges = maximumNumberOfChanges;
                }
            }
            if (best.quality() < sref.quality()) best = sref;
            i++;
        }
        return best;
    }
}
