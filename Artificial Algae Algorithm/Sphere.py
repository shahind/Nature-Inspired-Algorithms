import numpy as np


def ObjVal(Colony):
    #S = np.dot(Colony, Colony)
    S = Colony * Colony

    sh = np.array(S).transpose()

    objValue = sum(sh)

    return objValue