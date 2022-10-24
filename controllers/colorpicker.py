from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
from PyQt5.QtCore import Qt, pyqtSignal


class ColorPicker(QPushButton):

    colorChanged = pyqtSignal(object)

    def __init__(self, *args, color=None, **kwargs):
        super(ColorPicker, self).__init__(*args, **kwargs)

        self.currentColor = None
        self.defaultColor = color
        self.pressed.connect(self.onColorPicker)

        self.setColor(self.defaultColor)

    def setColor(self, color):
        if color != self.currentColor:
            self.currentColor = color
            self.colorChanged.emit(color)

        if self.currentColor:
            self.setStyleSheet("background-color: %s;" % self.currentColor)
        else:
            self.setStyleSheet("")

    def color(self):
        return self.currentColor

    def onColorPicker(self):
        dlg = QColorDialog(self)
        if self.currentColor:
            dlg.setCurrentColor(QColor(self.currentColor))

        if dlg.exec_():
            self.setColor(dlg.currentColor().name())

    def mousePressEvent(self, e):
        if e.button() == Qt.RightButton:
            self.setColor(self.defaultColor)

        return super(ColorPicker, self).mousePressEvent(e)
