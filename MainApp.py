import sys
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
from controllers.renderapp import RenderApp
from controllers.Graph3D import Graph3D


class MainApp(QMainWindow):
    def __init__(self, parent=None):
        super(MainApp, self).__init__(parent)

        self.setWindowTitle("Programm")

        # Creates and adds tab widgets to switch between functions
        self.tabs = QTabWidget()
        self.setCentralWidget(self.tabs)

        self.tab1 = Graph3D()
        self.tab2 = RenderApp()
        self.tab3 = QWidget()

        self.tabs.addTab(self.tab1, "GraphApp")
        self.tabs.addTab(self.tab2, "RenderApp")
        self.tabs.addTab(self.tab3, "App3")

        self.setWindowTitle("Santiago")


if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = MainApp()
    window.resize(900, 600)
    window.show()
    sys.exit(app.exec())
