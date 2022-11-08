import matlab.engine

class MLEngine():
    def __init__(self):
        self.eng = matlab.engine.start_matlab()
        self.eng.addpath('matlab')

    def createNeuron(self, cell, type):
        neuron = self.eng.Neuron(cell,type)
        return neuron

    def nodesDictionary(self,neuron):
        nodes = self.eng.getfield(neuron, 'nodes')
        id = self.eng.getfield(nodes,'ID')
        XYZum = self.eng.getfield(nodes,'XYZum')
        area = self.eng.getfield(nodes,'Radius')

        nodeData = {}
        for i in range(len(XYZum)):
            currentid = id[i][0]
            nodeData[int(currentid)] = (XYZum[i][0],XYZum[i][1],XYZum[i][2],area[i][0]) 
        
        return nodeData


    def edgesList(self,neuron,nodesDict):
        edges = self.eng.getfield(neuron, 'edges')
        a = self.eng.getfield(edges,'A')
        b = self.eng.getfield(edges,'B')
        
        edgeData = []

        for i in range(len(a)):
            edgeA = a[i][0]
            edgeB = b[i][0]

            nodeA = nodesDict[edgeA][0:3]
            nodeB = nodesDict[edgeB][0:3]

            edgeData.append((nodeA,nodeB))

        return edgeData


    # def neuronSurface(self,neuron):

#example using MLEngine
if __name__ == "__main__":
    mlEng = MLEngine()

    print(mlEng.eng.ones(3)) #using it directly

    n = mlEng.createNeuron(182,'t') #using abstracted function
    print(n)