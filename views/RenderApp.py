from PyQt5.QtWidgets import *
from controllers.Graph3D import Graph3D
from controllers.colorpicker import ColorPicker
import matplotlib.pyplot as plt
import numpy as np
from matplotlib import cm
from pyqt_checkbox_list_widget.checkBoxListWidget import CheckBoxListWidget
from random import *

class RenderApp(QWidget):
    def __init__(self, mlEngine, app):
        super(QWidget, self).__init__()
        self.layout = QHBoxLayout(self)
        self.mlEngine = mlEngine
        self.app = app

        # Toolbar
        self.toolbox = QVBoxLayout(self)
        self.toolbox.addWidget(QLabel("NeitzInferiorMonkey"))
        self.neuronList = CheckBoxListWidget()
        self.toolbox.addWidget(self.neuronList)
        self.layout.addLayout(self.toolbox)

        # Add neuron section of toolbar
        self.addNeuronSection = QGridLayout(self)
        self.addNeuronSection.addWidget(QLabel("Add Neuron:"), 0, 0)
        self.textInput = QLineEdit("ID")
        self.addNeuronSection.addWidget(self.textInput, 1, 0)
        self.addButton = QPushButton("+")
        self.addButton.pressed.connect(self.onAddNeuron)
        self.addNeuronSection.addWidget(self.addButton, 1, 1)
        self.colorButton = ColorPicker()
        self.addNeuronSection.addWidget(self.colorButton, 0, 1)
        self.load = QLabel("")
        self.addNeuronSection.addWidget(self.load, 2, 0)

        self.toolbox.addLayout(self.addNeuronSection)

        self.graph = Graph3D()
        self.layout.addWidget(self.graph)


    def onAddNeuron(self):
        if not self.textInput.text().isdigit():
            return

        neuronID = int(self.textInput.text())
        self.load.setText("Adding c" + str(neuronID))
        self.app.processEvents()
        self.neuronList.addItem('c' + str(neuronID))

        self.textInput.setText("")
        neuron = self.mlEngine.createNeuron(neuronID, 't')
        self.graphNeuron(neuron)
        self.load.setText("")

    def disableButtons(self):
        self.addButton.setDisabled(True)


    def graphNeuron(self,neuron):
        nodes = self.mlEngine.nodesDictionary(neuron)
        edges = self.mlEngine.edgesList(neuron, nodes)
        x = []
        y = []
        z = []
        for id in nodes:
            x1,y1,z1,area1 = nodes[id]
            x.append(x1)
            y.append(y1)
            z.append(z1)
        self.graph.scatterPlot(x,y,z)
        self.graph.linePlot(edges)

        surface = self.mlEngine.eng.GetSurface(neuron)

        for segment in surface:
            x = np.asarray(segment[0])
            y = np.asarray(segment[1])
            z = np.asarray(segment[2])
            surf = self.graph.axes.plot_surface(x, y, z, cmap=cm.coolwarm,
                            linewidth=0, antialiased=False, alpha=0.3)

        self.graph.fig.canvas.setFocus()
        plt.show()




