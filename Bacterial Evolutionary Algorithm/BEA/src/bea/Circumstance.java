package bea;

/**
 * The objects of this class represent the calling environment of the 'Gene 
 * function'. It stores the user-defined parameter of the gene function, 
 * the reference of the individual intended to modify and the index of the gene 
 * to be mutated.
 * @author Miklos F. Hatwagner
 * @param <GT> Gene type
 * @param <OT> Objective type
 * @param <FT> Fitness type
 * @param <GP> Gene parameter
 */
public class Circumstance<GT, OT extends Comparable<OT>, 
        FT extends Comparable<FT>, GP> {
    private final GP genePar;
    private final Individual<GT, OT, FT> ind;
    private final int geneIdx;

    /**
     * Creates a new Circumstance object.
     * @param genePar The user-defined parameter of the gene function.
     * @param ind Reference of the individual intended to modify.
     * @param geneIdx Index of the gene to be mutated.
     */
    public Circumstance(GP genePar, Individual<GT, OT, FT> ind, int geneIdx) {
        this.genePar = genePar;
        this.ind = ind;
        this.geneIdx = geneIdx;
    }

    /**
     * Returns the user-defined parameter of the gene function.
     * @return Gene fn. parameter.
     */
    public GP getGenePar() {
        return genePar;
    }

    /**
     * Returns the individual to modify.
     * @return Reference of the individual.
     */
    public Individual<GT, OT, FT> getInd() {
        return ind;
    }

    /**
     * Returns the index of gene to mutate/modify.
     * @return The index of the gene.
     */
    public int getGeneIdx() {
        return geneIdx;
    }
}
