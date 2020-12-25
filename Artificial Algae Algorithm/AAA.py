import numpy as np
from Sphere import ObjVal
from CalculateGreatness import CalculateGreatness
from GreatnessOrder import GreatnessOrder
from FrictionSurface import FrictionSurface
from tournement_selection import tournement_selection


def AAA(MaxFEVs, N, D, LB, UB, K, le, Ap):
    Algae = np.zeros((N,D))
    # Xij = Ximin + (Ximax - Ximin) * random(0, 1)
    Algae = LB + (UB - LB) * np.random.rand(N, D)

    Starve = np.zeros((1, N))
    Big_Algae = np.ones((1, N))
    Obj_Algae = []

    Best_Algae = np.zeros((1, N))

    for i in range(1, N):
        Obj_Algae = ObjVal(Algae)

    # [value,indices] = np.min(Obj_Algae)
    min_Obj_Alg = np.min(Obj_Algae)
    for ii, vi in enumerate((Obj_Algae),start=0):
        if vi == min_Obj_Alg:
            indices = ii
            value = vi

    Best_Algae = Algae[indices, :]
    Obj_Best_Algae = value

    Big_Algae = CalculateGreatness(Big_Algae, Obj_Algae)

    counter = 0

    c = N
    while c < MaxFEVs:

        Cloro_ALG = GreatnessOrder(Big_Algae);  # Calculate energy values

        Big_Algae_Surface = FrictionSurface(Big_Algae);  # Sorting by descending size and normalize between[0, 1]

        for i in range(0,c):

            starve = 0

            while Cloro_ALG[:,39] >= 0 and c < MaxFEVs:

                Neighbor = tournement_selection(Obj_Algae)

                while Neighbor == i:
                    Neighbor = tournement_selection(Obj_Algae)

                parameters = np.random.permutation(D)

                New_Algae = Algae[i, :]

                parameter0 = np.int(parameters[0])
                parameter1 = np.int(parameters[1])
                parameter2 = np.int(parameters[2])

                Subtr_Eq0 = np.float(Algae[Neighbor, parameter0] - New_Algae[parameter0])
                Subtr_Eq1 = np.float(Algae[Neighbor, parameter0] - New_Algae[parameter0])
                Subtr_Eq2 = np.float(Algae[Neighbor, parameter0] - New_Algae[parameter0])

                K_Big_Algae = K - np.float(Big_Algae_Surface[:,i])

                rand_value = np.random.random() - 0.5
                cosine_value = np.cos(np.random.random() * 360)
                sine_value = np.sin(np.random.random() * 360)

                New_Algae[parameter0] = Subtr_Eq0 * K_Big_Algae * (rand_value * 2)
                New_Algae[parameter1] = Subtr_Eq1 * K_Big_Algae * cosine_value
                New_Algae[parameter2] = Subtr_Eq2 * K_Big_Algae * sine_value

                ##########################################
                for p in range(1, 3):

                    if New_Algae[parameters[p]] > UB:
                        New_Algae[parameters[p]] = UB

                    if New_Algae[parameters[p]] < LB:
                        New_Algae[parameters[p]] = LB

                Obj_New_Algae = ObjVal(New_Algae)

                c = c + 1
                counter = c
                Cloro_ALG[:,i] = Cloro_ALG[:,i] - (le / 2)

                if Obj_New_Algae <= Obj_Algae[i]:
                    Algae[i, :] = New_Algae
                    Obj_Algae[i] = Obj_New_Algae
                    starve = 1
                else:
                    Cloro_ALG[:,i] = Cloro_ALG[:,i] - (le / 2)
        if starve == 0:
            Starve[:,i] = Starve[:,i] + 1

        #[val, ind] = np.min(Obj_Algae)

        min_Obj_Alg1 = np.min(Obj_Algae)
        for ju, valuee in enumerate((Obj_Algae), start=0):
            if valuee == min_Obj_Alg1:
                ind = ju
                valki = valuee

        if valki < Obj_Best_Algae:
            Best_Algae = Algae[ind, :]
            Obj_Best_Algae = valki

        Big_Algae = CalculateGreatness(Big_Algae, Obj_Algae)

        m = np.int(np.fix(np.random.random() * D) + 1)
        imax = np.max(Big_Algae)
        imin = np.min(Big_Algae)

        big_algae_to_1_arr = np.array(Big_Algae).reshape(N)
        #Algae[imin, m] = Algae[imax, m]

        for ind_max, max_value in enumerate((big_algae_to_1_arr),start=0):
            if max_value == imax:
                index_max = ind_max
                maxi_value = max_value

        for ind_min, min_value in enumerate((big_algae_to_1_arr),start=0):
            if min_value == imin:
                index_min = ind_min
                mini_value = min_value
        if m >= 40:
            m = m - 1;

        Algae[index_min, m] = Algae[index_max, m]

        starve = np.int(np.max(Starve))

        if np.random.random() < Ap:
            for m in range(0,D):
                Algae[starve, m] = Algae[starve, m] + (Algae[index_max, m] - Algae[starve, m]) * np.random.random()

        print('Run = %d error = %1.8e\n' %(counter, Obj_Best_Algae))

    return Obj_Best_Algae
