from __future__ import division
import math
import random
import sys
import bisect

class ABO:

    # Static variable for this class
    bg = []
    lp = []
    speed = 0
    depot_index = 3
    bg_update_counter = 0

    ### Begin Initialization ###
    def __init__(self, depot_index, graph):
        self.Graph = graph
        self.available_index = []
        self.available_value = []
        self.visited_edges = []
        self.visited_nodes = []
        self.back_step = []
        self.bp = []
        self.m = []
        self.w = []
        self.total_distance = 0
        # D is in position 3 within the Array
        ABO.depot_index = depot_index
        self.bp = self.Graph.getNodes()[ABO.depot_index]
        self.m = self.bp
        self.current_index = ABO.depot_index
        # get available nodes from bp
        self.availableNodes(ABO.depot_index)
        if len(self.available_index) < 1:
            print "Program has been stopped, because there is no available move from current depot"
            sys.exit(1)

    def initParams(self, lp, speed):
        ABO.lp = lp
        ABO.speed = speed

    def setFirstIter(self):
        # set the bg randomly for first iteration
        bg_index = random.choice(self.available_index)[1]
        ABO.bg = self.Graph.getNodes()[bg_index]
        ABO.bg_update_counter = 0
    ### End Initialization ###

    ### Begin Setter/Getter ###
    def getCurrentIndex(self):
        return self.current_index

    def getNextIndex(self):
        return self.next_index

    def getVisitedEdges(self):
        return self.visited_edges

    def getVisitedNodes(self):
        return self.visited_nodes

    def getAvailableIndex(self):
        return self.available_index

    def getAvailableValue(self):
        return self.available_value

    def getTotalDistance(self):
        return self.total_distance
    ### End Setter/Getter ###

    ### Begin Formula Functions ###
    def newMk(self, m, w, bp, bg):
        x = m[0] + ABO.lp[0] * (bg[0] - w[0]) + ABO.lp[1] * (bp[0] - w[0])
        y = m[1] + ABO.lp[0] * (bg[1] - w[1]) + ABO.lp[1] * (bp[1] - w[1])
        return [x,y]

    def democraticEq(self, m, w, bp, bg, range):
        x = ( m[0] + ABO.lp[0] * (bg[0] - w[0]) + ABO.lp[1] * (bp[0] - w[0]) ) * range
        y = ( m[1] + ABO.lp[0] * (bg[1] - w[1]) + ABO.lp[1] * (bp[1] - w[1]) ) * range
        location = [x,y]
        return self.fobj(location)

    def newWk(self, m, w):
        x = (w[0] + m[0]) / ABO.speed
        y = (w[1] + m[1]) / ABO.speed
        return [x,y]

    def movementEq(self, m, w, ab):
        return ((w[0]**ABO.lp[0]) * ab * (m[0] ** ABO.lp[1]) * ab) / ((w[1]**ABO.lp[0]) * ab * (m[1] ** ABO.lp[1]) * ab)

    def fobj(self, x):
        # a = 1
        # b = 5.1/(4*3.14**2)
        # c = 5/math.pi		
        # r = 6
        # s = 10
        # t = 1/(8*math.pi)
        
        # term1 = a * (x[1] - b*x[0]**2 + c*x[0] - r)**2
        # term2 = s*(1-t)*math.cos(x[0])
        # f = term1 +term2 +s
        f = math.pow((x[0] - 1), 2) + math.pow((x[1] - 1), 2)
        return f
    ### End Formula Functions ###

    ### Begin The Algorithm Functions ###
    def buffaloMove(self):
        repeat = True
        if ABO.depot_index in self.visited_nodes: #If depot has been visited already, then stop the loop
            return False
        if len(self.available_index) < 1:
            self.backup_memory = {
                "m":self.m, "w":self.w, "bp":self.bp, "bg":ABO.bg
            }
            self.buffaloBack()
        else:
            self.backup_memory = None
            repeat = False

        m = self.m
        w = self.Graph.getNodes()[self.current_index]
        bp = self.bp
        bg = ABO.bg
        if self.backup_memory is not None:
            m = self.backup_memory['m']
            w = self.backup_memory['w']
            bp = self.backup_memory['bp']
            bg = self.backup_memory['bg']

        available_nodes = []
        for node in self.available_index:
            available_nodes.append(node[1])
        self.next_index = random.choice(available_nodes)
        self.w = w
        # If there is finish node on available nodes but not all edges have been passed yet
        if ABO.depot_index in available_nodes and self.allEdgesArePassed() is False:
            self.removeDepotFromAvailable()
            index = available_nodes.index(ABO.depot_index)
            del available_nodes[index]
            self.next_index = random.choice(available_nodes)

        # Do the math
        newMk = self.newMk(m, w, bp, bg)
        self.m = newMk
        # if self.fobj(newMk) < self.fobj(m):
        #     self.m = newMk
        newWk = self.newWk(self.m, w)
        if self.fobj(newWk) < self.fobj(bp):
            self.bp = newWk

        self.visited_edges.append([self.current_index, self.next_index])
        self.visited_nodes.append(self.next_index)
        self.current_index = self.next_index
        self.availableNodes(self.current_index)

        if repeat is False:
            return False
            
        return self.buffaloMove()

    def bgUpdate(self):
        if self.fobj(self.bp) < self.fobj(ABO.bg):
            # print "bgUpdate ----"
            # print "current bg",ABO.bg
            ABO.bg = self.bp
            # print "updated bg",ABO.bg
            # print "visited nodes",self.visited_nodes
            return True
        return False

    def buffaloBack(self):
        # Back step is a temporary variable which stores last step that gives empty available move, so that the algorithm can delete the selected index later
        self.back_step = self.visited_edges[len(self.visited_edges) - 1]
        del self.visited_edges[-1]
        del self.visited_nodes[-1]
        self.current_index = self.visited_nodes[len(self.visited_nodes)-1]
        self.availableNodes(self.current_index)

    # check available nodes
    def availableNodes(self, current_index):
        self.available_index = []
        self.available_value = []
        for i in self.Graph.getDistance():
            if i != current_index:
                continue
            for j in self.Graph.getDistance()[i]:
                if self.Graph.getDistance()[i][j] == 0:
                    continue
                # if [i,j] not in self.visited_edges and [j,i] not in self.visited_edges: # Activate this if you want to make visited nodes can be available if there is another way through different edges
                if j not in self.visited_nodes:
                    self.available_index.append([i, j])
                    self.available_value.append(self.Graph.getDistance()[i][j])
        # Check if there is a back step which has been stored before from buffaloMove() and it's in available move, so remove the back step from the available move options
        if self.back_step in self.available_index:
            index = self.available_index.index(self.back_step)
            del self.available_index[index]
            del self.available_value[index]
            self.back_step = [] #Clear and empty the back step again
                    
    # Remove depot from available options, it is used when the solution tried to finish itself to the depot but not all edges are completed yet
    def removeDepotFromAvailable(self):
        for option in self.available_index:
            if option[1] == ABO.depot_index:
                index = self.available_index.index(option)
                del self.available_index[index]
                del self.available_value[index]

    def allEdgesArePassed(self):
        nodes = []
        for node in self.Graph.getNodes():
            nodes.append(self.Graph.getNodes().index(node))
        index = nodes.index(ABO.depot_index)
        del nodes[index]
        for node in nodes:
            if node not in self.visited_nodes:
                return False
        return True

    def calculateTotalDistance(self):
        distances = []
        for distance in self.visited_edges:
            distances.append(self.Graph.getDistance()[distance[0]][distance[1]])
        for distance in distances:
            self.total_distance += distance
    ### End The Algorithm Functions ###