
from PyQt5.QtWebEngineWidgets import QWebEngineView
import plotly.offline as po
import plotly.graph_objs as go
from PyQt5.QtCore import QUrl
from PyQt5.QtWebEngineWidgets import QWebEngineView
import numpy as np


class PlotlyGraph():
    def __init__(self):

        self.fig = go.Figure()
        
        self.fig.write_image("fig1.png")

        raw_html = '<html><head><meta charset="utf-8" />'
        raw_html += '<script src="https://cdn.plot.ly/plotly-latest.min.js"></script></head>'
        raw_html += '<body>'
        raw_html += po.plot(self.fig, include_plotlyjs=False, output_type='div')
        raw_html += '</body></html>'

        self.browser  = QWebEngineView()
        self.fig.add_trace(go.Scatter3d(x=[], y=[], z=[]))
     
        self.browser.setHtml(raw_html)
        self.browser.show()
        self.browser.raise_()

    def update(self):
        raw_html = '<html><head><meta charset="utf-8" />'
        raw_html += '<script src="https://cdn.plot.ly/plotly-latest.min.js"></script></head>'
        raw_html += '<body>'
        raw_html += po.plot(self.fig, include_plotlyjs=False, output_type='div')
        raw_html += '</body></html>'

        self.browser.setHtml(raw_html)
        self.browser.show()
        self.browser.raise_()

    def scatterPlot(self, x,y,z):     
        self.fig.add_trace(go.Scatter3d(x=x, y=y, z=z, mode="markers", showlegend=False, marker=dict(size=3), opacity=0.8))

    def linePlot(self, x,y,z):     
        self.fig.add_trace(go.Scatter3d(x=x, y=y, z=z, mode="lines", showlegend=False, line=dict(color="#0000ff")))

    def surfacePlot(self, x,y,z):     
        self.fig.add_trace(go.Surface(x=x, y=y, z=z, opacity=0.2))
        self.fig.update_coloraxes(showscale=False)

    def move(self):
        self.update()