import numpy as np


def tournement_selection(source):

    s2 = np.size(source)
    #np.random.seed(10)
    neighbor = np.random.permutation(s2)

    if source[neighbor[0]] < source[neighbor[1]]:
        choice = neighbor[0]
    else:
        choice = neighbor[1]
    return choice



