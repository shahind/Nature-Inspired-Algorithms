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

import os, math, PIL, PIL.Image

from metaheuristic_optimizer.bench_functions import *

def create_image(func, x1, y1, x2, y2, step = 1.0):
  width  = int((x2 - x1) / step) + 1
  height = int((y2 - y1) / step) + 1
  image  = PIL.Image.new("RGB", (width, height))
  values = []
  minv   = maxv = func([x1, y1])
  x = x1
  while x < x2:
    values.append([])
    y = y1
    while y < y2:
      v = func([x, y])
      if v < minv: minv = v
      if v > maxv: maxv = v
      values[-1].append(v)
      y += step
    x += step
    
  for x in range(len(values)):
    for y in range(len(values[x])):
      v = int(255.0 * (values[x][y] - minv) / maxv)
      image.putpixel((x, y), (v, v, v))
      
  image.save(os.path.join(os.path.dirname(__file__), "%s.png" % func.__name__))

  
#create_image(sphere, -100.0, -100.0, 100.0, 100.0, 0.5)
#create_image(rosenbrock, -2.048, -2.048, 2.048, 2.048, 0.01)
create_image(rastrigin, -12.0, -12.0, 12.0, 12.0, 0.05)
#create_image(himmelblau, -6.0, -6.0, 6.0, 6.0, 0.02)
#create_image(eggholder, -512.0, -512.0, 512.0, 512.0, 2.0)
