import matlab.engine

class MLEngine():
    def __init__(self):
        self.eng = matlab.engine.start_matlab()

    def createNeuron(self, cell, type):
        neuron = self.eng.Neuron(cell,type)
        return neuron

    def nodesDictionary(self,neuron):
        nodes = self.eng.getfield(neuron, 'nodes')
        id = self.eng.getfield(nodes,'ID')
        posx = self.eng.getfield(nodes,'X')
        posy = self.eng.getfield(nodes,'Y')
        posz = self.eng.getfield(nodes,'Z')

        nodeData = {}
        for i in range(len(posx)):
            currentid = id[i][0]
            nodeData[int(currentid)] = (posx[i][0],posy[i][0],posz[i][0]) 
        
        return nodeData

    def nodesCordinates(self,neuron):
        nodes = self.eng.getfield(neuron, 'nodes')
        posx = self.eng.getfield(nodes,'X')
        posy = self.eng.getfield(nodes,'Y')
        posz = self.eng.getfield(nodes,'Z')

        x = []
        y = []
        z = []

        for i in range(len(posx)):
            x.append(posx[i][0])
            x.append(posy[i][0])
            x.append(posz[i][0])
        return [x,y,z]


    def edgesList(self,neuron,nodesDict):
        edges = self.eng.getfield(neuron, 'edges')
        a = self.eng.getfield(edges,'A')
        b = self.eng.getfield(edges,'B')
        
        edgeData = []

        for i in range(len(a)):
            edgeA = a[i][0]
            edgeB = b[i][0]

            nodeA = nodesDict[edgeA]
            nodeB = nodesDict[edgeB]

            edgeData.append((nodeA,nodeB))

        return edgeData


#example using MLEngine
if __name__ == "__main__":
    mlEng = MLEngine()

    print(mlEng.eng.ones(3)) #using it directly

    n = mlEng.createNeuron(182,'t') #using abstracted function
    print(n)