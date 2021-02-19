from random import uniform
from random import choice
from random import random
from random import randint
from copy import deepcopy

import sys
sys.tracebacklimit = 0


def _generate_new_position(x0: list = None, dof: int = None, bounds: list = None) -> list:
    '''GENERATE NEW POSITION

    Parameters
    ----------
    dof : int
    x0 : list
    bounds : list of tuples [(x1_min, x1_max),...,(xn_min, xn_max)]

    Returns
    -------
    list

    Notes
    -----
    There are several ways in which an initial position can be generated.
    Outlined below are all possible scenarios and outputs.

    nomenclature: 
        "dof" = "degrees of freedom" = "dimensions" = "d"
        p = new initial position vector of length d

    just bounds:
        for each position i in bounds,  p[i] = random value in [i_min, i_max]]

    just x0:
        for each position i in x0: p[i] = x0[i] + random value in [-1, 1]

    just dof:
        for each position i from 0 to d,  p[i] = random value in [-1, 1]

    dof + x0:
        since dof and x0 are redundent from a dimensionality perspective,
        this situation will defer to the case above "just x0".

    dof + bounds:
        since dof and bounds are redundent from a dimensionality perspective,
        this situation wll defer to the case above "just bounds"

    x0 + bounds:
        for each position i in x0: 
            p[i] = x0[i] + random value in [-1, 1] constrained by bounds[i].min
            and bounds[i].max

    dof + x0 + bounds:
        see case: "x0 + bounds" above

    All this boils down to four cases (ordered by information gain from user):
    1) x0 and bounds
    2) bounds
    3) x0
    4) dof
    '''

    if x0 and bounds:
        return [min(max(uniform(-1,1) + x0[i], bounds[i][0]), bounds[i][1]) for i in range(len(x0))]
        
    if bounds:
        return [uniform(bounds[i][0], bounds[i][1]) for i in range(len(bounds))]

    if x0:
        return [x_i + uniform(-1, 1) for x_i in x0]

    if dof:
        return [uniform(-1, 1) for _ in range(0, dof)]


def minimize(func, x0=None, dof=None, bounds=None, pp=0.6, cr=0.44, pm=0.4,
             npop=10, disp=False, maxiter=50):
    '''
    Parameters
    ----------
    x0 : list
    	initial guess
    pp : float
    	procreating percentage
    cr : float
    	cannibalism rate. A cr of 1 results in all children surviving. A cr of 0
        results in no children surviving
    pm : float
        mutation rate

    Returns
    -------
    float : solution at global best
    list : position at global best

    References
    ----------
    '''

    # do some basic checks before going any further
    assert type(disp) == bool, 'parameter: disp -> must be of type: bool'
    assert type(npop) == int, 'parameter: npop -> must be of type: int'
    assert type(maxiter) == int, 'parameter: maxiter -> must be of type int'
    if x0 is not None: assert type(x0) == list, 'x0 must be of type: list'
    if dof is not None: assert type(dof) == int, 'parameter: dof -> must be of type: int'
    if bounds is not None: assert type(bounds) == list, 'parameter: bounds -> must be of type list'
    assert x0 is not None or dof is not None or bounds is not None, 'must specify at least one of the following: x0, dof, or bounds'
    if x0 and bounds: assert len(bounds) == len(x0), 'x0 and bounds must have same number of elements'
    assert pp > 0 and pp <= 1, 'procreating percentage "pp" must be: 0 < pp <= 1'
    assert cr >= 0 and cr <= 1, 'cannibalism rate "cr" must be: 0 < cr <= 1'
    assert pm >= 0 and pm <= 1, 'mutation rate "pm" must be: 0 < pm <= 1'
    assert maxiter > 0, 'maxiter must be greater than zero.'

    # check bounds specification if necessary
    if bounds:
        assert type(bounds) == list, 'bounds must be of type: list'
        for b in bounds:
            assert type(b) == tuple, 'element in bounds is not of type: tuple. ever every element must be a tuple as specified (v_min, v_max)'
            assert b[0] < b[1], 'element in bounds specified incorrectly. must be (xi_min, xi_max)'

    # constants
    if x0 is not None: dof = len(x0)
    elif bounds is not None: dof = len(bounds)

    nr = int(npop * pp)         # number of reproduction
    nm = int(npop * pm)         # number of mutation children
    spacer = len(str(npop))     # for logging only

    # initialize population
    pop = [_generate_new_position(x0, dof, bounds) for _ in range(0, npop)]
    
    # main loop
    hist = []
    for epoch in range(0, maxiter):

		# initialize epoch
        pop = sorted(pop, key=lambda x: func(x), reverse=False)
        pop1 = deepcopy(pop[:nr])
        pop2 = []
        pop3 = []
        gbest = pop[0]
        
        # print something useful
        if disp: print(f'> ITER: {epoch+1:>{spacer}} | GBEST: {func(gbest):0.6f}')

        # procreation and cannibalism
        for i in range(0, nr):

            # randomly pick two parents
            i1, i2 = randint(0, len(pop1)-1), randint(0, len(pop1)-1)
            p1, p2 = pop1[i1], pop1[i2]

            # crossover
            children = []
            for j in range(0, int(dof/2)):

                # generate two new children using equation (1)
                alpha = random()
                c1 = [(alpha * v1) + ((1 - alpha)*v2) for v1, v2 in zip(p1, p2)]
                c2 = [(alpha * v2) + ((1 - alpha)*v1) for v1, v2 in zip(p1, p2)]

                # persist new children to temp population
                children.append(c1)
                children.append(c2)

            # cannibalism - destroy male; since female black widow spiders are 
            # larger and often end up killing the male during mating, we'll
            # assume that the fitter partent is the female. thus, we'll delete 
            # the weaker parent.
            if func(p1) > func(p2): pop1.pop(i1)
            else: pop1.pop(i2)

            # cannibalism - destroy some children
            children = sorted(children, key=lambda x: func(x), reverse=False)
            children = children[:max(int(len(children) * cr), 1)]

            # add surviving children to pop2
            pop2.extend(children)

        # mutation
        for i in range(0, nm):

            # pick a random child
            m = choice(pop2)

            # pick two random chromosome positions
            cp1, cp2 = randint(0, dof-1), randint(0, dof-1)

            # swap chromosomes
            m[cp1], m[cp2] = m[cp2], m[cp1]

            # persist
            pop3.append(m)

        # assemble final population
        pop2.extend(pop3)
        pop = deepcopy(pop2)

    # return global best position and func value at global best position
    return func(gbest), gbest
