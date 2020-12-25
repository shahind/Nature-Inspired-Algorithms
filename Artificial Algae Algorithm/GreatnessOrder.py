import numpy as np


def GreatnessOrder(Big_algae):
    s2 = np.size(Big_algae)

    sorting = np.ones((1, s2))

    BAlgae_Great_Surface = np.zeros((1, s2))

    for i in range(0,s2):
        sorting[:,i] = i

    for i in range(0,s2 - 1):

        for j in range(i + 1, s2):

            i_sort = np.int(sorting[:,i])
            j_sort = np.int(sorting[:,j])

            if Big_algae[:,i_sort] > Big_algae[:,j_sort]:

                temp = np.int(sorting[:,i])

                sorting[:,i] = sorting[:,j]

                sorting[:,j] = temp
        l_sort = np.int(sorting[:,i])
        BAlgae_Great_Surface[:,l_sort] = np.power(i, 2)

    k_sort = np.int(sorting[:,s2-2])
    BAlgae_Great_Surface[:,k_sort] = np.power((i + 1), 2)
    BAlgae_Great_Surface = (BAlgae_Great_Surface - np.min(BAlgae_Great_Surface))/ np.ptp(BAlgae_Great_Surface)

    return BAlgae_Great_Surface
