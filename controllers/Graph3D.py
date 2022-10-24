from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg
from matplotlib.figure import Figure

class Graph3D(FigureCanvasQTAgg):
    def __init__(self):
        self.fig = Figure(figsize=(100, 100), dpi=70)
        FigureCanvasQTAgg.__init__(self,self.fig)
        super(Graph3D, self).__init__(self.fig)

        self.fig.canvas.mpl_connect('key_press_event', self.on_press)

        self.axes=self.fig.add_subplot(111,projection="3d")
        self.fig.tight_layout()
    

    def scatterPlot(self,x,y,z):
        self.fig.canvas.setFocus()
        self.axes.scatter(x,y,z, color='b', marker='o', s=5)
        self.draw()

    def linePlot(self,x,y,z):
        self.axes.plot(x,y,z, color='black')

    def clearGraph(self):
        self.axes.clear()
        self.draw()

    def hide_background(self):
        self.fig.canvas.setFocus()
        self.axes.grid(False)
        self.axes.set_axis_off()
        self.draw()

    def moveX(self, multiplier):
        amount = multiplier * abs(self.axes.get_xbound()[0]-self.axes.get_xbound()[1])
        self.axes.set_xbound(self.axes.get_xbound()[0]+amount, self.axes.get_xbound()[1]+amount)
        self.draw()
    
    def moveY(self,multiplier):
        amount = multiplier * abs(self.axes.get_ybound()[0]-self.axes.get_ybound()[1])
        self.axes.set_ybound(self.axes.get_ybound()[0]+amount, self.axes.get_ybound()[1]+amount)
        self.draw()

    def moveZ(self,multiplier):
        amount = multiplier * abs(self.axes.get_zbound()[0]-self.axes.get_zbound()[1])
        self.axes.set_zbound(self.axes.get_zbound()[0]+amount, self.axes.get_zbound()[1]+amount)
        self.draw()

    def on_press(self,event):
        if event.key == 'a':
            self.moveX(0.02)
        if event.key == 'd':
            self.moveX(-0.02)
        if event.key == 'w':
            self.moveY(0.02)
        if event.key == 's':
            self.moveY(-0.02)
        if event.key == 'q':
            self.moveZ(0.02)
        if event.key == 'e':
            self.moveZ(-0.02)
        if event.key == 'left':
            self.axes.view_init(elev = self.axes.elev, azim = self.axes.azim + 5)
            self.draw()
        if event.key == 'right':
            self.axes.view_init(elev = self.axes.elev, azim = self.axes.azim - 5)
            self.draw()
        if event.key == 'up':
            self.axes.view_init(elev = self.axes.elev + 5, azim = self.axes.azim)
            self.draw()
        if event.key == 'down':
            self.axes.view_init(elev = self.axes.elev - 5, azim = self.axes.azim)
            self.draw()