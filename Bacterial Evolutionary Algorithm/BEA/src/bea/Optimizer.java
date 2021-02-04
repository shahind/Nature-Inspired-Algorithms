package bea;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Random;
import java.util.function.Consumer;
import java.util.function.Function;

/**
 * This class implements the Bacterial Evolutionary Algorithm (BEA). All 
 * problem-dependent details were tried to remove from the implementation, 
 * including the types of data. The fitness value is the basis of comparisons 
 * and sorting of individuals. In case of single objective problems, the 
 * fitness value is the same as the objective value. In case of multi-objective 
 * problems, the fitness value is the number of Pareto-front the individual 
 * belongs to. Front no. 1 contains the best ones.
 * @see <a href="http://ieeexplore.ieee.org/abstract/document/725020/" 
 * target="_blank">original paper.</a> 
 * @author Miklos F. Hatwagner
 * @param <GT> Gene type
 * @param <OT> Objective type
 * @param <FT> Fitness type
 * @param <IP> Initialization parameter
 * @param <GP> Gene fn. parameter
 */
public class Optimizer<GT, OT extends Comparable<OT>, FT extends Comparable<FT>, IP, GP> {
   
    private final ArrayList<Individual<GT, OT, FT>> population;
    private final Consumer<Individual<GT, OT, FT>> objFn;
    private final int popSize;
    private final int numGenes;
    private final int numClones;
    private final Function<Circumstance<GT, OT, FT, GP>, GT> geneFn;
    private final GP genePar;
    private final int numInfections;
    private final int numGenerations;
    private final Random rnd;
    
    /**
     * Creates a new instance of the optimizer.
     * @param popSize The number of individuals in the population.
     * @param initFn The function to initialize the first generation of the 
     * population.
     * @param initPar The user-defined parameter of the init function.
     * @param objFn The objective function.
     * @param numClones The number of clones.
     * @param geneFn Function to calculate the new value of a gene.
     * @param genePar The user-defined parameter of the gene function.
     * @param numInfections The number of infections per generation.
     * @param numGenerations The number of generations. Currently this is the 
     * only stop condition of the algorithm.
     */
    public Optimizer(
            int popSize, 
            Function<IP, ArrayList<GT>> initFn,
            IP initPar, 
            Consumer<Individual<GT, OT, FT>> objFn, 
            int numClones,
            Function<Circumstance<GT, OT, FT, GP>, GT> geneFn, 
            GP genePar, 
            int numInfections, 
            int numGenerations) {
        this.popSize = popSize;
        population = new ArrayList<>(popSize);
        for(int p=0; p<popSize; p++) {
            Individual<GT, OT, FT> ind = new Individual<>();
            ind.setGenes(initFn.apply(initPar));
            population.add(ind);
        }
        this.objFn = objFn;
        population.parallelStream().forEach(objFn);
        numGenes = population.get(0).getGenes().size();
        this.numClones = numClones;
        this.geneFn = geneFn;
        this.genePar = genePar;
        this.numInfections = numInfections;
        this.numGenerations = numGenerations;
        rnd = new Random();
    }

    private boolean isXDominatedByY(Individual<GT, OT, FT> x, Individual<GT, OT, FT> y) {
        boolean all = true;
        boolean exists = false;
        OT vx, vy;
        for(int i=0; i<x.getObjectives().size() && all; i++) {
            vx = x.getObjectives().get(i);
            vy = y.getObjectives().get(i);
            if(vy.compareTo(vx) > 0) {
                all = false;
            }
            if(vy.compareTo(vx) < 0) {
                exists = true;
            }
        }
        return all&&exists;
    }
    
    private void fitness(ArrayList<Individual<GT, OT, FT>> inds) {
        if(inds.get(0).getObjectives().size()<2) {
            inds.stream().forEach(ind -> 
                    ind.setFitness((FT)ind.getObjectives().get(0))
            );
        } else {
            ArrayList<Individual<GT, OT, FT>> copy = new ArrayList<>(inds);
            Integer frontNo = 1;
            while(!copy.isEmpty()) {
                ArrayList<Individual<GT, OT, FT>> domted = new ArrayList<>();
                for(Individual<GT, OT, FT> ind1 : copy) {
                    boolean isInd1Dominated = false;
                    for(Individual<GT, OT, FT> ind2 : copy) {
                        if(isInd1Dominated) break;
                        if(ind1 != ind2) {
                            isInd1Dominated = isXDominatedByY(ind1, ind2);
                        }
                    }
                    if(isInd1Dominated) {
                        domted.add(ind1);
                    } else {
                        ind1.setFitness((FT) frontNo);
                    }
                }
                copy = domted;
                frontNo++;
            }
        }
    }
    
    private ArrayList<Integer> fisherYates() {
        ArrayList<Integer> order = new ArrayList<>(numGenes);
        for(int i=0; i<numGenes; i++) {
            order.add(i);
        }
        for(int i=numGenes-1; i>0; i--) {
            int j = rnd.nextInt(i+1);
            Integer tmp = order.get(i);
            order.set(i, order.get(j));
            order.set(j, tmp);
        }
        return order;
    }
    
    private void mutation() {
        // mutate all individuals
        population.parallelStream().forEach(ind -> {
            ArrayList<Integer> geneOrder = fisherYates();
            // mutate all genes in random order
            geneOrder.stream().forEach(geneIdx -> {
                ArrayList<Individual<GT, OT, FT>> clones = new ArrayList<>(numClones);
                for(int i=0; i<numClones; i++) {
                    Individual<GT, OT, FT> clone = new Individual<>(ind);
                    Circumstance<GT, OT, FT, GP> c = new Circumstance<>(genePar, clone, geneIdx);
                    clone.getGenes().set(geneIdx, geneFn.apply(c));
                    objFn.accept(clone);
                    clones.add(clone);
                }
                ArrayList<Individual<GT, OT, FT>> fittPop = new ArrayList<>();
                fittPop.add(ind);
                fittPop.addAll(clones);
                fitness(fittPop);
                Collections.sort(clones);
                if(clones.get(0).compareTo(ind) < 0) {
                    ind.getGenes().set(geneIdx, clones.get(0).getGenes().get(geneIdx));
                    ind.setObjectives(clones.get(0).getObjectives());
                }
            });
        });
    }
    
    private void transfer() {
        int half = popSize / 2;
        for(int i=0; i<numInfections; i++) {
            fitness(population);
            Collections.sort(population);
            int good = rnd.nextInt(half);
            int bad = half + rnd.nextInt(popSize - half);
            int geneIdx = rnd.nextInt(numGenes);
            population.get(bad).getGenes().set(geneIdx, 
                    population.get(good).getGenes().get(geneIdx));
            objFn.accept(population.get(bad));
        }
    }
    
    /**
     * Starts the optimization with the parameters given to the constructor.
     */
    public void optimize() {
        for(int i=0; i<numGenerations; i++) {
            mutation();
            transfer();
        }
        fitness(population);
        Collections.sort(population);
    }
    
    /**
     * Provides the String representation of the population.
     * @return A textual description of the population.
     */
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        population.stream().forEach(ind -> {
            sb.append(ind).append("\n");
        });
        return sb.toString();
    }
    
}
