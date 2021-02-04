
import numpy as np

#
# remommended to use 
# https://github.com/PasaOpasen/OptimizationTestFunctions
#
class TestFunctions:
    @staticmethod
    def Parabol(arr):
        return np.sum(arr**2)
    @staticmethod
    def Rastrigin(arr):
        return 10*arr.size+TestFunctions.Parabol(arr) - 10*np.sum(np.cos(2*math.pi*arr))
    @staticmethod
    def Shvel(arr):
        return -np.sum(arr*np.sin(np.sqrt(np.abs(arr))))