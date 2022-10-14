# MLEngine is used for abstraction for matlab functions that we want to use
# or we can use it to access the engine directly
# it could handle converting matlab data to type so that python can use it

import matlab.engine

class MLEngine():
    def __init__(self):
        self.eng = matlab.engine.start_matlab()

    def createNeuron(self, cell, type):
        neuron = self.eng.Neuron(cell,type)
        return neuron




#example using MLEngine
if __name__ == "__main__":
    mlEng = MLEngine()

    print(mlEng.eng.ones(3)) #using it directly

    n = mlEng.createNeuron(182,'t') #using abstracted function
    print(n)