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
from matplotlib.ticker import MaxNLocator

from BeeHiveOptimization import *


route = os.path.join(os.path.dirname(__file__), 'images')


def plot2d(func = TestFunctions.Rastrigin, begin = -5, end = 5, count = 15, title = 'Rastrigin function'):
    
    
    if not os.path.exists(route):
        os.mkdir(route)
    
    x = np.linspace(begin,end,100)
    y = np.linspace(begin,end,100)
    
    a, b = np.meshgrid(x, y)
    
    data = np.empty((x.size,y.size))
    for i in range(x.size):
        for j in range(y.size):
            data[i,j] = func(np.array([x[i], y[j]]))
    
    a = a.T
    b = b.T
    
    l_a=a.min()
    r_a=a.max()
    l_b=b.min()
    r_b=b.max()
    
    l_c, r_c = data.min(), data.max()
    
    levels = MaxNLocator(nbins=15).tick_values(l_c,r_c)
    cmap = plt.get_cmap('summer')
    
    
    figure, axes = plt.subplots()
    #c = axes.contourf(a, b, data , cmap=cmap, levels = levels, vmin=l_c, vmax=r_c)
    
    def base_plot():
        c = axes.contourf(a, b, data , cmap=cmap, levels = levels, vmin=l_c, vmax=r_c)       
        name = title
        axes.set_title(name)
        axes.axis([l_a, r_a, l_b, r_b])
        figure.colorbar(c)
        
    
    def base_save(number):
        
        r = os.path.join(route,f'{title}_{number}.png')
        figure.savefig(r, dpi = 350)
        plt.show()
        #figure.clf()
        plt.close(figure)
    
    
    
    arrow_width = 2
    arrow_length = 8
    xytext = (-40, 75) #(-2, 4)  
    
    
    
    
    base_plot()
    
    base_save(0)
    
    bees = Bees(np.random.uniform(begin,end,(count,2)), width = 3)
    
    #bees = Bees.get_Bees_from_randomputs(count, RandomPuts.Normal(0, 1.5, 2), 2)
    
    now = bees.x
    best = bees.bests
    
    figure, axes = plt.subplots()
    base_plot()
    
    axes.plot(best[:,0], best[:,1], 'bs', color = 'red', markeredgecolor = "black")
    axes.plot(now[:,0], now[:,1], 'ro', color = 'yellow', markeredgecolor = "black")  
    
    base_save(1)
    
    
    hive = Hive(bees,func, verbose = True)
    
    now = hive.bees.x
    best = hive.bees.bests
    v = hive.bees.v
    
    # #pos = float(hive.best_pos)
    figure, axes = plt.subplots()
    base_plot()
   
    axes.plot(best[:,0], best[:,1], 'bs', color = 'red', markeredgecolor = "black")
    axes.plot(now[:,0], now[:,1], 'ro', color = 'yellow', markeredgecolor = "black") 
    
    # plt.plot(best, val(best), 'bs', color = 'red', label = 'best bee positions')
    # plt.plot(now, val(now), 'ro', color = 'green', label = 'current bee positions')
    bbox = dict(boxstyle ="round", fc ="0.8") 
    arrowprops = dict( 
            arrowstyle = "->", 
            connectionstyle = "angle, angleA = 0, angleB = 90, rad = 10")
    
    axes.annotate(f'global min = {hive.best_val:.5}', xy= tuple(hive.best_pos), xytext=xytext,
             arrowprops=dict(facecolor='red', shrink=0.05), 
              #color = 'red',
              bbox = bbox#, arrowprops = arrowprops
             )
    
    for p, v in zip(now,v):
         axes.arrow(p[0], p[1], v[0], v[1] , width = arrow_width, length_includes_head = True,
                head_length = min(arrow_length, np.abs(v).max()/3)              
              )
    
    
    base_save(2)
    
    
    for i in range(2,20):
        
        hive.best_val, hive.best_pos = hive.bees.make_step(0.3, 2, 5, hive.best_pos, hive.best_val)
        
        now = hive.bees.x
        best = hive.bees.bests
        v = hive.bees.v
        
    #     #pos = float(hive.best_pos)
        figure, axes = plt.subplots()
        base_plot()
   
        
        axes.annotate(f'global min = {hive.best_val:.5}', xy= tuple(hive.best_pos), xytext=xytext,
             arrowprops=dict(facecolor='red', shrink=0.05), 
              #color = 'red',
              bbox = bbox#, arrowprops = arrowprops
             )
        
        for bb, p in zip(best, now):
            plt.plot([bb[0],p[0]], [bb[1],p[1]], 'r--', color = 'blue')
            
    #     plt.plot(best, val(best), 'bs', color = 'red', label = 'best bee positions')
    #     plt.plot(now, val(now), 'ro', color = 'green', label = 'current bee positions')
        axes.plot(best[:,0], best[:,1], 'bs', color = 'red', markeredgecolor = "black")
        axes.plot(now[:,0], now[:,1], 'ro', color = 'yellow', markeredgecolor = "black") 
        
        for p, v in zip(now,v):
            axes.arrow(p[0], p[1], v[0], v[1] , width = arrow_width, length_includes_head = True,
                head_length = min(arrow_length, np.abs(v).max()/3)              
              )
        
    #     plt.legend()
        base_save(i+1)
        
    
    

tit = "Shvel function with noise (2d)"

#plot2d(TestFunctions.Shvel, -90,100, count = 15, title = tit)

plot2d(lambda arr: TestFunctions.Shvel(arr)+random.uniform(0,10), -90,100, count = 15, title = tit)

#plot2d(TestFunctions.Rastrigin, -6,5, count = 15, title = tit)

#plot2d(lambda arr: TestFunctions.Rastrigin(arr)+random.uniform(0,7), -6,5, count = 15, title = tit)


import imageio
images = []
filenames = [os.path.join(route, f'{tit}_{i}.png') for i in range(20)]
for filename in filenames:
    images.append(imageio.imread(filename))
    
imageio.mimsave(os.path.join(route,f'{tit}_movie.gif'), images, duration = 0.4)








