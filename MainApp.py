import sys
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
from views.RenderApp import RenderApp
from controllers.Graph3D import Graph3D
from controllers.MLEngine import MLEngine


class MainApp(QMainWindow):
    def __init__(self, app, parent=None):
        super(MainApp, self).__init__(parent)

        # Creates and adds tab widgets to switch between functions
        self.tabs = QTabWidget()
        self.setCentralWidget(self.tabs)
        mlEngine = MLEngine()

        self.tab1 = RenderApp(mlEngine, app)
        self.tab2 = Graph3D()
        self.tab3 = QWidget()

        self.tabs.addTab(self.tab1, "RenderApp")
        self.tabs.addTab(self.tab2, "GraphApp")
        self.tabs.addTab(self.tab3, "Tab 3")

        self.setWindowTitle("Santiago")


if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = MainApp(app)
    window.resize(1200, 800)
    window.show()
    sys.exit(app.exec())
