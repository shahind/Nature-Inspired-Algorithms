import bea.Circumstance;
import bea.Individual;
import bea.Optimizer;
import java.util.ArrayList;
import java.util.DoubleSummaryStatistics;
import java.util.Random;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * Test class for demonstration purpose only.
 * The first (commented) case is a single, the second case is a multi-objective 
 * problem.
 * @author Miklos F. Hatwagner
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        
        Function<Circumstance<Double, Double, Double, Object>, Double> geneFn1 = (c) -> {
            return new Random().nextDouble()*5.12*2. - 5.12;
        };
        Function<Function<Circumstance<Double, Double, Double, Object>, Double>, ArrayList<Double>> initFn1 = (ip) -> {
            ArrayList<Double> genes = new ArrayList<>();
            for(int i=0; i<2; i++) {
                genes.add(ip.apply(null));
            }
            return genes;
        };
        Consumer<Individual<Double, Double, Double>> objFn1 = (ind) -> {
            ArrayList<Double> genes = ind.getGenes();
            double result = 10. * genes.size();
            DoubleSummaryStatistics dss = genes.stream().collect(
                    Collectors.summarizingDouble(
                            g -> g*g - 10.*Math.cos(2.*Math.PI*g)));
            result += dss.getSum();
            ArrayList<Double> objs = ind.getObjectives();
            if(objs.isEmpty()) {
                objs.add(result);
            } else {
                objs.set(0, result);
            }
            ind.setObjectives(objs);
        };
        
//        Optimizer<Double, Double, Double, Function<Circumstance<Double, Double, Double, Object>, Double>, Object> opt1 = 
//                new Optimizer<>(4, initFn1, geneFn1, objFn1, 3, geneFn1, null, 3, 500);
//        
//        opt1.optimize();
//        System.out.println(opt1);
        
        // ------------------
        
        // GT -> Double
        // OT -> Double
        // FT -> Integer
        // GP -> Object
        Function<Circumstance<Double, Double, Integer, Object>, Double> geneFn2 = (c) -> {
            return new Random().nextDouble()*5.12*2. - 5.12;
        };
        Function<Function<Circumstance<Double, Double, Integer, Object>, Double>, ArrayList<Double>> initFn2 = (ip) -> {
            ArrayList<Double> genes = new ArrayList<>();
            for(int i=0; i<2; i++) {
                genes.add(ip.apply(null));
            }
            return genes;
        };
        // GT, OT, FT
        Consumer<Individual<Double, Double, Integer>> objFn2 = (ind) -> {
            ArrayList<Double> genes = ind.getGenes();
            ArrayList<Double> objs = ind.getObjectives();
            for(int i=0; i<genes.size(); i++) {
                double result = genes.get(i)*genes.get(i);
                if(objs.size() <= i) {
                    objs.add(result);
                } else {
                    objs.set(i, result);
                }
            }
            ind.setObjectives(objs);
        };
        
        // GT, OT, FT, IP, GP
        Optimizer<Double, Double, Integer, Function<Circumstance<Double, Double, Integer, Object>, Double>, Object> opt2 = 
                new Optimizer<>(10, initFn2, geneFn2, objFn2, 3, geneFn2, null, 3, 10);
        
        opt2.optimize();
        System.out.println(opt2);
    }
}
