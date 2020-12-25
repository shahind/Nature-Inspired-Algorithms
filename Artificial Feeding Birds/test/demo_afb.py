# -*- coding: utf-8 -*-
# Metaheuristic_Optimizer
# Copyright (C) 2016-2017 Jean-Baptiste LAMY
# LIMICS (Laboratoire d'informatique médicale et d'ingénierie des connaissances en santé), UMR_S 1142
# University Paris 13, Sorbonne paris-Cité, Bobigny, France

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import sys, os.path, random, tkinter, PIL

import metaheuristic_optimizer
import metaheuristic_optimizer.artificial_feeding_birds
from metaheuristic_optimizer.artificial_feeding_birds import NumericAlgorithm
from metaheuristic_optimizer.artificial_feeding_migratory_birds import NumericAlgorithm

from metaheuristic_optimizer.bench_functions import *

class Params(object):
  def __init__(self, cost_func, **kargs):
    self.cost_func = cost_func
    self.__dict__.update(kargs)
    
sphere_params = Params(
  sphere,
  nb_dimension =  2, min_x = -100.0, max_x = 100.0, delta_x = 0.5,
  chance_joining_other = 0.1, chance_memory = 0.8, fly_limit = 5,
)
rosenbrock_params = Params(
  rosenbrock,
  nb_dimension = 2, min_x = -2.048, max_x = 2.048, delta_x = 0.02,
  chance_joining_other = 0.1, chance_memory = 0.8, fly_limit = 5,
)
rastrigin_params = Params(
  rastrigin,
  nb_dimension = 2, min_x = -12.0, max_x = 12.0, delta_x = 1.0,
  chance_joining_other = 0.1, chance_memory = 0.8, fly_limit = 5,
)
himmelblau_params = Params(
  himmelblau,
  nb_dimension = 2, min_x = -6.0, max_x = 6.0, delta_x = 0.1,
  chance_joining_other = 0.1, chance_memory = 0.8, fly_limit = 5,
)
eggholder_params = Params(
  eggholder,
  nb_dimension = 2, min_x = -512.0, max_x = 512.0, delta_x = 2.0,
  chance_joining_other = 0.1, chance_memory = 0.8, fly_limit = 10,
)


def show(params):
  window = tkinter.Tk()

  image_filename = os.path.join(os.path.dirname(__file__), "%s.png" % params.cost_func.__name__)
  image  = tkinter.PhotoImage(file = image_filename)
  width  = image.width ()
  height = image.height()
  
  algo = NumericAlgorithm(
    params.cost_func, params.nb_dimension, params.min_x, params.max_x,
  )
  
  for bird in algo.birds: bird.old_position = bird.position
  
  def iterate():
    for bird in algo.birds: bird.old_position = bird.position
    algo.iterate()
    print(algo.nb_cost_computed, "tested positions, best result:", algo.get_lowest_cost())
    
  canvas_items = []
  def update():
    nonlocal canvas_items
    for item in canvas_items: canvas.delete(item)
    canvas_items = []
    for bird in algo.birds:
      #if (abs(bird.position[0] - bird.old_position[0]) <= 1) and (abs(bird.position[1] - bird.old_position[1]) <= 1):
      #  canvas_items.append(canvas.create_rectangle(bird.position[0] - 1, bird.position[1] - 1, bird.position[0] + 1, bird.position[1] + 1, outline = "red", fill = "red"))
      #else:
      x1 = width  * (bird.old_position[0] - params.min_x) / (params.max_x - params.min_x)
      y1 = height * (bird.old_position[1] - params.min_x) / (params.max_x - params.min_x)
      x2 = width  * (bird.position[0] - params.min_x) / (params.max_x - params.min_x)
      y2 = height * (bird.position[1] - params.min_x) / (params.max_x - params.min_x)
      if   bird.last_move == 1: color = "red"
      elif bird.last_move == 2: color = "blue"
      elif bird.last_move == 3: color = "green"
      else:                     color = "cyan"
      canvas_items.append(canvas.create_line(x1, y1, x2, y2, fill = color))
      canvas_items.append(canvas.create_rectangle(x2 - 1, y2 - 1, x2 + 1, y2 + 1, outline = color, fill = color))
      
  def run_1_gen():
    iterate()
    update()
    
  def run_100_gen():
    for i in range(100): iterate()
    update()
    
  looping = False
  def loop():
    nonlocal looping
    looping = not looping
    if looping: loop_iteration()
    
  def loop_iteration():
    iterate()
    update()
    
    if looping: canvas.after(100, loop_iteration)
    
  stop_clicked = True
  def stop_loop(): stop_clicked = True
  
  def reset():
    algo.reset()
    for bird in algo.birds: bird.old_position = bird.position
    update()
  
  frame  = tkinter.Frame(window)
  frame.pack()
  
  canvas = tkinter.Canvas(frame, bg = "white", width = width, height = height)
  canvas.pack()
  canvas.create_image(width / 2, height / 2, image = image)
  
  button = tkinter.Button(frame, text = "Run 1   iteration" , command = run_1_gen)
  button.pack()
  
  button = tkinter.Button(frame, text = "Run 100 iterations" , command = run_100_gen)
  button.pack()
  
  button = tkinter.Button(frame, text = "Loop" , command = loop)
  button.pack()
  
  button = tkinter.Button(frame, text = "Reset" , command = reset)
  button.pack()
  
    
  update()
    
  window.mainloop()
  
#show(sphere_params)
#show(rosenbrock_params)
#show(rastrigin_params)
show(eggholder_params)
