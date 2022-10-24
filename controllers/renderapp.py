from PyQt5.QtWidgets import *
from controllers.Graph3D import Graph3D
from controllers.colorpicker import ColorPicker
from pyqt_checkbox_list_widget.checkBoxListWidget import CheckBoxListWidget


class RenderApp(QWidget):
    def __init__(self):
        super(QWidget, self).__init__()
        self.layout = QHBoxLayout(self)

        # Toolbar
        self.toolbox = QVBoxLayout(self)
        self.toolbox.addWidget(QLabel("NeitzInferiorMonkey"))
        self.neuronList = CheckBoxListWidget()
        self.toolbox.addWidget(self.neuronList)
        self.layout.addLayout(self.toolbox)

        # Add neuron section of toolbar
        self.addNeuron = QGridLayout(self)
        self.addNeuron.addWidget(QLabel("Add Neuron:"), 0, 0)
        self.textInput = QLineEdit("ID")
        self.addNeuron.addWidget(self.textInput, 1, 0)
        self.addButton = QPushButton("+")
        self.addButton.pressed.connect(self.onAddNeuron)
        self.addNeuron.addWidget(self.addButton, 1, 1)
        self.colorButton = ColorPicker()
        self.addNeuron.addWidget(self.colorButton, 0, 1)
        self.toolbox.addLayout(self.addNeuron)

        self.graph = Graph3D()
        self.layout.addWidget(self.graph)

    def onAddNeuron(self):
        self.neuronList.addItem(self.textInput.text())
        self.textInput.setText("")
