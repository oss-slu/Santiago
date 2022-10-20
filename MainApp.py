import sys
from PyQt6.QtCore import *
from PyQt6.QtGui import *
from PyQt6.QtWidgets import *


class MainApp(QTabWidget):
    def __init__(self, parent=None):
        super(MainApp, self).__init__(parent)

        self.tab1 = QWidget()
        self.tab2 = QWidget()
        self.tab3 = QWidget()

        self.addTab(self.tab1, "GraphApp")
        self.addTab(self.tab2, "RenderApp")
        self.addTab(self.tab3, "App3")

        self.setWindowTitle("Main App")


if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = MainApp()
    window.resize(500, 400)
    window.show()
    sys.exit(app.exec())
