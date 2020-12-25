from __future__ import division
import math
from Graph import Graph
from operator import itemgetter

class Sweep:
    def __init__(self):
        self.Graph = None

    def run(self, graph, center_node, max_demands):
        if isinstance(graph, Graph) is False:
            print "Please add correct graph"
            exit()
        sweeped_graphs = []
        self.createPolar(graph, center_node)
        sorted_polar = sorted(graph.getPolar(), key=itemgetter('deg'))
        del sorted_polar[0]
        size = len(sorted_polar)
        all_used = False
        while( all_used is False ):
            sweeped_locations = []
            curr_demands = 0
            for i in xrange(size):
                if sorted_polar[i]['used'] is True:
                    continue
                if max_demands >= curr_demands + sorted_polar[i]['demands']:
                    curr_demands += sorted_polar[i]['demands']
                    sorted_polar[i]['used'] = True
                    sweeped_locations.append(sorted_polar[i])

            # Create graph by sweeped_locations
            new_graph = Graph()
            new_nodes = [
                [0, 0] # Put back the depot
            ]
            new_demands = [0]
            new_longlat = [
                graph.getLongLat()[center_node]
            ]
            new_location_names = [
                graph.getLocationNames()[center_node]
            ]
            for node in sweeped_locations:
                new_nodes.append(node['location'])
                new_demands.append(node['demands'])
                new_longlat.append(node['longlat'])
                new_location_names.append(node['location_name'])
            new_graph.setNodes(new_nodes)
            new_graph.setDemands(new_demands)
            new_graph.setLongLat(new_longlat)
            new_graph.setLocationNames(new_location_names)
            new_graph.createDistance(new_nodes)
            sweeped_graphs.append(new_graph)
            
            # Check if all locations are used
            for i in xrange(size):
                if sorted_polar[i]['used'] is False:
                    break
                if i == len(sorted_polar) - 1 and sorted_polar[i]['used'] is True:
                    all_used = True
                    break
        return sweeped_graphs

    def createPolar(self, graph, center_node):
        """Initialize nodes polar."""
        locations = graph.getNodes()
        longlat = graph.getLongLat()
        location_names = graph.getLocationNames()
        size = len(locations)
        polar = []
        for i in xrange(size):
            r = self.calcPolar(locations[i])
            deg = self.calcPolarDeg(locations[i])
            depot = locations[center_node]
            if depot != locations[i]:
                angle = self.calcAngle(locations[i], depot)
            else:
                angle = 0.0
            polar.append({
                'r':r, 'deg':deg, 'location': locations[i], 'longlat': longlat[i],'demands': graph.getDemands()[i], 'location_name': location_names[i],'used': False
            })
        graph.setPolar(polar)

    def calcPolarDeg(self, x):
        # radian = math.atan2(x[1],x[0]) # Changed the formula as in the journal
        try:
            radian = math.atan(x[0]/x[1])
        except ZeroDivisionError:
            radian = 0
        degrees = math.degrees(radian)
        if degrees < 0:
            degrees = degrees * (-1) + 90 # It converts minus degree to be over 90 degrees basis
        return degrees

    def calcPolar(self, x):
        return math.sqrt(x[0]**2 + x[1]**2)

    #Currently not being used
    def calcAngle(self, ver, depot):
        sin_a = (ver[1] - depot[1] ) / (math.sqrt( (ver[0] - depot[0])**2 + (ver[1] - depot[1])**2 ))
        radian = math.asin(sin_a)
        return math.degrees(radian)