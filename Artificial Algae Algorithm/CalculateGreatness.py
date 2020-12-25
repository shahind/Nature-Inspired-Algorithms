import numpy as np

def CalculateGreatness(BigX,ObjX):

    ObjX = (ObjX - np.min(ObjX))/ np.ptp(ObjX)

    s2 = np.size(BigX)

    BigY = []

    for i in range(0,s2):

        fKs = np.abs(BigX[:,i]/2.0)

        M = (ObjX[i] / (fKs + ObjX[i]))

        dX = M * BigX[:,i]

        BigX[:,i] = BigX[:,i] + dX

    return BigX
