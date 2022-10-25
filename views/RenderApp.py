from PyQt5.QtWidgets import *
from controllers.Graph3D import Graph3D
from controllers.colorpicker import ColorPicker
from pyqt_checkbox_list_widget.checkBoxListWidget import CheckBoxListWidget


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
        self.load.setText("Loading")
        self.app.processEvents()
        self.neuronList.addItem(self.textInput.text())
        neuronID = int(self.textInput.text())

        self.textInput.setText("")
        neuron = self.mlEngine.createNeuron(neuronID, 't')
        self.graphNeuron(neuron)
        self.load.setText("")



    def graphNeuron(self,neuron):
        nodes = self.mlEngine.nodesDictionary(neuron)
        edges = self.mlEngine.edgesList(neuron, nodes)
        x = []
        y = []
        z = []
        for id in nodes:
            x1,y1,z1 = nodes[id]
            x.append(x1)
            y.append(y1)
            z.append(z1)
        self.graph.scatterPlot(x,y,z)

        for edge in edges:
            x = [edge[0][0],edge[1][0]]
            y = [edge[0][1],edge[1][1]]
            z = [edge[0][2],edge[1][2]]
            self.graph.linePlot(x,y,z)
        self.graph.draw()
        self.graph.fig.canvas.setFocus()

