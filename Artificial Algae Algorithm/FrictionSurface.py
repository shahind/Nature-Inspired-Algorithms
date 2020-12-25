import numpy as np


def FrictionSurface(Big_Algae):

    s2 = np.size(Big_Algae)

    BAlgae_Fr_Surface = np.zeros((1, s2))

    for i in range(0,s2):
        r = np.power(((Big_Algae[:,i] * 3) / (4 * np.pi)), (1 / 3))  # Calculate the Radius
        BAlgae_Fr_Surface[:,i] = 2 * np.pi * np.power(r, 2)  # Calculate the Friction Surface

    BAlgae_Fr_Surface = (BAlgae_Fr_Surface - np.min(BAlgae_Fr_Surface)) / np.ptp(BAlgae_Fr_Surface)

    return BAlgae_Fr_Surface
