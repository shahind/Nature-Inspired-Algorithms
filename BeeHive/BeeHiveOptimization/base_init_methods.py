
import numpy as np

#
# recommended to use
# https://github.com/PasaOpasen/opp-op-pop-init#population-initializers
#
class RandomPuts:
    @staticmethod
    def Uniform(minimum, maximum, size):
        return lambda: np.random.uniform(minimum, maximum, size)
    @staticmethod
    def Normal(mean, std, size):
        return lambda: np.random.normal(mean, std, size)