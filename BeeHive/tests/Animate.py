# -*- coding: utf-8 -*-
"""
Created on Tue Jul 21 16:41:53 2020

@author: qtckp
"""

import sys
sys.path.append('..')

import math
import os

import numpy as np
import matplotlib.pyplot as plt

from BeeHiveOptimization import *


route = os.path.join(os.path.dirname(__file__), 'images')


def plot1d(func = TestFunctions.Rastrigin, begin = -5, end = 5, count = 15, title = 'Rastrigin function'):
    
    def val(arr):
        return np.array([func(t) for t in arr])
    
    
    if not os.path.exists(route):
        os.mkdir(route)
    x = np.linspace(begin,end,200)
    y = val(x)
    
    def base_plot():
        plt.plot(x, y)
        plt.xlabel('x')
        plt.ylabel('y')
        plt.suptitle(title)
    
    def base_save(number):
        
        r = os.path.join(route,f'{title}_{number}.png')
        plt.savefig(r, dpi =350)
        plt.show()
        plt.close()
    
    arrow_width = 1
    arrow_length = 4
    xytext = (0, 40)  #(0, -60)
    
    
    base_plot()
    plt.title('before start',color = 'red')
    #plt.text(-1, 35, r'before start', fontsize=14, color='red')
    base_save(0)
    
    #bees = Bees(x[np.newaxis,:])
    bees = Bees(np.random.uniform(begin,end,(count,1)), width = 3)
    
    now = bees.x.flatten()
    best = bees.bests.flatten()
    
    base_plot()
    plt.title('initialization',color = 'red')
    #plt.text(-1, 35, r'initialization', fontsize=14, color='red')
    
    plt.plot(best, val(best), 'bs', color = 'red')
    plt.plot(now, val(now), 'ro', color = 'green')
    base_save(1)
    
    
    hive = Hive(bees,func, verbose = True)
    
    now = hive.bees.x.flatten()
    best = hive.bees.bests.flatten()
    v = hive.bees.v.flatten()
    
    #pos = float(hive.best_pos)
    
    base_plot()
    plt.title('first step',color = 'red')
    #plt.text(-1, 35, r'first step', fontsize=14, color='red')
    
    plt.plot(best, val(best), 'bs', color = 'red', label = 'best bee positions')
    plt.plot(now, val(now), 'ro', color = 'green', label = 'current bee positions')
    
    plt.annotate('global min', xy=(float(hive.best_pos), func(hive.best_pos)), xytext=xytext,
             arrowprops=dict(facecolor='black', shrink=0.05),
             )
    
    for p, v in zip(now,v):
        tmp = func(p)
        plt.arrow(p, tmp, v, 0 , width = arrow_width,length_includes_head = True,
               head_length = min(arrow_length, math.fabs(v/3))
              )
    
    
    base_save(2)
    
    for i in range(2,15):
        
        hive.best_val, hive.best_pos = hive.bees.make_step(0.3, 2, 5, hive.best_pos, hive.best_val)
        
        now = hive.bees.x.flatten()
        best = hive.bees.bests.flatten()
        v = hive.bees.v.flatten()
        
        #pos = float(hive.best_pos)
        
        base_plot()
        plt.title(f'step {i}',color = 'red')
        #plt.text(-1, 35, f'step {i}', fontsize=14, color='red')
        

        
        plt.annotate('global min', xy=(float(hive.best_pos), func(hive.best_pos)), xytext=xytext,
                 arrowprops=dict(facecolor='black', shrink=0.05),
                 )
        
        for b, p in zip(best, now):
            plt.plot([b,p], val(np.array([b,p])), 'r--', color = 'blue')
            
        plt.plot(best, val(best), 'bs', color = 'red', label = 'best bee positions')
        plt.plot(now, val(now), 'ro', color = 'green', label = 'current bee positions')
        
        for p, v in zip(now,v):
            tmp = func(p)
            plt.arrow(p, tmp, v, 0 , width = arrow_width,length_includes_head = True,
               head_length = min(arrow_length, math.fabs(v/3))
              )
        
        plt.legend()
        base_save(i+1)
    
    

tit = "Rastrigin function with noise"

#plot1d(TestFunctions.Shvel, -90,100, count = 8, title = tit)

#plot1d(lambda arr: TestFunctions.Shvel(arr)+random.uniform(0,4), -90,100, count = 8, title = tit)

#plot1d(TestFunctions.Rastrigin, -6,7, count = 8, title = tit)

plot1d(lambda arr: TestFunctions.Rastrigin(arr)+random.uniform(0,5), -6,5, count = 8, title = tit)

import imageio
images = []
filenames = [os.path.join(route, f'{tit}_{i}.png') for i in range(15)]
for filename in filenames:
    images.append(imageio.imread(filename))
    
imageio.mimsave(os.path.join(route,f'{tit}_movie.gif'), images, duration = 0.4)








