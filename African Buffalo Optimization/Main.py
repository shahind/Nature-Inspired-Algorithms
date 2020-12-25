import os, sys
sys.path.append(os.path.dirname(__file__)+'/Models/')
# Uncomment code below and comment code above if you want to debug using python through terminal
# sys.path.append(os.path.dirname(__file__)+'Models/')
from ABO import ABO
from Graph import Graph
from Sweep import Sweep
from pprint import pprint

class Main:
    def __init__(self):
        # Initiate Parameters
        self.depot_index = 0
        self.lp = [0.6, 0.5]
        self.speed = 0.9
        self.buffalo_size = 200
        self.trial_size = 50
        self.bg_not_updating = 3
        self.max_demands = 3000

        self.graph = Graph()
        self.sweep = Sweep()
        self.sweeped_graphs = []
        self.sweeped_buffalos = []

        self.results = []
        
    def runABO(self, graph, counter = 0):
        Abo = ABO(self.depot_index, graph)
        Abo.setFirstIter()
        Abo.initParams(self.lp, self.speed)
        buffalos = [ABO(self.depot_index, graph) for i in range(1,self.buffalo_size)]
        update_counter = 0
        for i in range(1, self.trial_size):
            for buffalo in buffalos:
                buffalo.buffaloMove()
            for buffalo in buffalos:
                if buffalo.bgUpdate() is True:
                    update_counter += 1
            if update_counter > 0:
                Abo.bg_update_counter += 1
            update_counter = 0

        counter = Abo.bg_update_counter

        if counter < self.bg_not_updating:
            return self.runABO(graph, counter)
        
        return {
            'abo': Abo,
            'graph': graph,
            'buffalos': buffalos
        }

    def setResults(self, Abo):
        if Abo is None or Abo['buffalos'] is None or isinstance(Abo['buffalos'], list) is False:
            print "Error"
            exit()

        optimal_buffalo = Abo['buffalos'][0]
        optimal_index = 0
        for buffalo in Abo['buffalos']:
            buffalo.calculateTotalDistance()
            if optimal_buffalo.getTotalDistance() > buffalo.getTotalDistance():
                optimal_buffalo = buffalo
                optimal_index = Abo['buffalos'].index(buffalo)
        # Calculate total demands
        total_demands = 0
        visited_nodes = optimal_buffalo.getVisitedNodes()
        real_nodes = [self.depot_index]
        for i in xrange(len(visited_nodes)):
            total_demands += Abo['graph'].getDemands()[visited_nodes[i]]
            real_nodes.append(self.graph.getNodes().index(Abo['graph'].getNodes()[visited_nodes[i]]))

        self.results.append({
            'buffalo':optimal_buffalo,
            'buffalo_no':optimal_index,
            'real_nodes':real_nodes,
            'total_demands':total_demands,
            'graph':Abo['graph']
        })


    # For API
    def generateResults(self, depot_index=0, lp = [0.6, 0.5], speed = 0.9, buffalo_size = 200, trial_size = 50, bg_not_updating = 3, max_demands = 3000):
        # Initiate Parameters
        self.depot_index = depot_index
        self.lp = lp
        self.speed = speed
        self.buffalo_size = buffalo_size
        self.trial_size = trial_size
        self.bg_not_updating = bg_not_updating
        self.max_demands = max_demands
        
        # Sweep the graph, run the ABO and print the result, that's all :)
        self.graph = Graph()
        self.sweep = Sweep()
        self.sweeped_graphs = self.sweep.run( self.graph, self.depot_index, self.max_demands )
        self.sweeped_buffalos = []

        self.results = []

        if isinstance(self.sweeped_graphs, list) is False or len(self.sweeped_graphs) < 1:
            return {
                'status':False,
                'message':"Error on sweeped graphs"
            }

        for sweeped_graph in self.sweeped_graphs:
            abo = self.runABO( sweeped_graph )
            self.sweeped_buffalos.append(abo)

        if isinstance(self.sweeped_buffalos, list) is False or len(self.sweeped_buffalos) < 1:
            return {
                'status':False,
                'message':"Error on sweeped buffalos"
            }

        if len(self.sweeped_buffalos) != len(self.sweeped_graphs):
            return {
                'status':False,
                'message':"Buffalos and graphs total must be same"
            }

        # Generate the result!
        for buffalo in self.sweeped_buffalos:
            self.setResults(buffalo)

        return {
            'status':True,
            'data':self.results
        }

    def printResult(self):
        # Generate the results!
        results = self.generateResults(self.depot_index, self.lp, self.speed, self.buffalo_size, self.trial_size, self.bg_not_updating, self.max_demands)
        if isinstance(results, dict):
            if results['status'] is False:
                print results['message']
            else:
                print "Demands table",self.graph.getDemands()
                for Abo in self.results:
                    print "Rute ke",self.results.index(Abo)+1,"adalah:"
                    print "Kerbau teroptimal adalah kerbau ke",Abo['buffalo_no'],"dengan total jarak",Abo['buffalo'].getTotalDistance()
                    print "Langkah tempuh kerbau ke",Abo['buffalo_no'],"adalah",Abo['real_nodes']
                    print "Total demands:",Abo['total_demands']

# Uncomment code below to see the results in terminal
# Main().printResult()