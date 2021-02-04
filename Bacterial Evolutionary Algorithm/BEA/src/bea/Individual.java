package bea;

import java.util.ArrayList;

/**
 * This class represents an Individual of the population.
 * @author Miklos F. Hatwagner
 * @param <GT> Gene type
 * @param <OT> Objective type
 * @param <FT> Fitness type
 */
public class Individual<GT, OT extends Comparable<OT>, 
        FT extends Comparable<FT>> 
    implements Comparable<Individual<GT, OT, FT>> {
    /** The list of genes. */
    protected ArrayList<GT> genes;
    /** The list of objective values. */
    protected ArrayList<OT> objectives;
    /** The fitness value of the Individual. */
    protected FT fitness;
    
    /**
     * It is a copy constructor; creates a new instance based on an already
     * existing one.
     * @param existing An existing object of the class to copy.
     */
    public Individual(Individual<GT, OT, FT> existing) {
        genes = new ArrayList<>(existing.genes);
        objectives = new ArrayList<>(existing.objectives);
        fitness = existing.fitness;
    }
    
    /**
     * It is the default constructor of the Individual class. 
     * It creates the internal lists, but does not put anything in them.
     */
    public Individual() {
        genes = new ArrayList<>();
        objectives = new ArrayList<>();
    }
    
    /**
     * Returns the list of genes.
     * @return The list of genes.
     */
    public ArrayList<GT> getGenes() {
        return genes;
    }
    
    /**
     * Sets the list of genes.
     * @param genes The new list of genes.
     */
    public void setGenes(ArrayList<GT> genes) {
        this.genes = genes;
    }
    
    /**
     * Returns the list of objective values.
     * @return The list of objective values.
     */
    public ArrayList<OT> getObjectives() {
        return objectives;
    }
    
    /** 
     * Sets the list of objective values.
     * @param objective The new list of objective values.
     */
    public void setObjectives(ArrayList<OT> objective) {
        this.objectives = objective;
    }

    /**
     * Returns the fitness value of the individual.
     * @return The fitness value.
     */
    public FT getFitness() {
        return fitness;
    }

    /**
     * Sets the current fitness value of the individual to a new value.
     * @param fitness 
     */
    public void setFitness(FT fitness) {
        this.fitness = fitness;
    }

    /**
     * Returns the String representation of the Individual.
     * @return A String containing the gene values, objective values and the
     * fitness value.
     */
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("Genes: ");
        genes.stream().forEach((g) -> {
            sb.append(g).append(" ");
        });
        sb.append("Obj.: ").append(objectives);
        sb.append(" Fit.: ").append(fitness);
        return sb.toString();
    }

    /**
     * Compares two Individuals based on their fitness values.
     * @param otherInd The other Individual to compare to.
     * @return A negative integer, zero, or a positive integer as the fitness
     * value of this Individual is less than, equal to, or greater than the 
     * specified other Individual.
     */
    @Override
    public int compareTo(Individual<GT, OT, FT> otherInd) {
        return fitness.compareTo(otherInd.fitness);
    }
}
