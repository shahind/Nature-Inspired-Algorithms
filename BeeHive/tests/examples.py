# -*- coding: utf-8 -*-
"""
Created on Wed Jul 22 13:26:31 2020

@author: qtckp
"""
import sys
sys.path.append('..')

from BeeHiveOptimization import Bees, Hive, BeeHive, TestFunctions, RandomPuts

import numpy as np

# 1st step is to create bees

np.random.seed(1)

# it's just numpy array with shape bees_count_x_dim

arr = np.random.uniform(low = -3, high = 5, size = (10,3))

# width parameter means the maximum range of random begging speeds

bees = Bees(arr, width = 0.2)

bees.show()

# u aslo can create bees by random generator like () --> random numpy array (point)

bees = Bees.get_Bees_from_randomputs(count = 10, random_gen = RandomPuts.Normal(mean = 1, std = 0.1, size = 2), width = 0.3)

bees.show()



# 2nd step 

bees = Bees(np.random.normal(loc = 2, scale = 2, size = (100,3)), width = 3)

func = lambda arr: TestFunctions.Parabol(arr-3)

    
hive = Hive(bees, 
            func, 
            parallel = False, # use parallel evaluating of functions values for each bee? (recommented for heavy functions, f. e. integtals) 
            verbose = True) # show info about hive 

# getting result

best_result, best_position = hive.get_result(max_step_count = 25, # maximun count of iteraions
                      max_fall_count = 6, # maximum count of continious iterations without better result
                      w = 0.3, fp = 2, fg = 5, # parameters of algorithm
                      latency = 1e-9, # if new_result/old_result > 1-latency then it was the iteration without better result
                      verbose = True # show the progress (recommented for heavy functions, f. e. integtals) 
                      )


# u also can use this code (without creating a hive)

best_result, best_position = BeeHive.Minimize(func, bees, 
                 max_step_count = 100, max_fall_count = 30, 
                 w = 0.3, fp = 2, fg = 5, latency = 1e-9, 
                 verbose = False, parallel = False)



print()


# to get best solution


func = lambda arr: TestFunctions.Rastrigin(arr) + TestFunctions.Shvel(arr) + 1 / (1 + np.sum(np.abs(arr)))

for w in (0.1,0.3,0.5,0.8):
    for fp in (1, 2, 3, 4.5):
        for fg in (3, 5, 8, 15):
            
            # 200 bees, 10 dimentions
            bees = Bees(np.random.uniform(low = -100, high = 100, size = (200, 10) ))
            
            best_val, _ = BeeHive.Minimize(func, bees, 
                 max_step_count = 200, max_fall_count = 70, 
                 w = 2, fp = fp, fg = fg, latency = 1e-9, 
                 verbose = False, parallel = False)
            
            print(f'best val by w = {w}, fp = {fp}, fg = {fg} is {best_val}')





























