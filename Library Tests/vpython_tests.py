from vpython import *
import random
import matlab.engine
from controllers.MLEngine import MLEngine


mle = MLEngine()

neu = mle.createNeuron(127, 'i')

print('getting dict')

data = mle.nodesDictionary(neu)
edge = mle.edgesList(neu, data)

print(data)

scene.width = scene.height = 600

scene.background = color.white

N = 50
sRange = 200

scene.range = sRange

# Display frames per second and render time:
scene.append_to_title("<div id='fps'/>")

run = True
def Runbutton(b):
    global run
    if b.text == 'Pause':
        run = False
        b.text = 'Run'
    else:
        run = True
        b.text = 'Pause'

button(text='Pause', bind=Runbutton)
scene.append_to_caption("""
To rotate "camera", drag with right button or Ctrl-drag.
To zoom, drag with middle button or Alt/Option depressed, or use scroll wheel.
  On a two-button mouse, middle is left + right.
To pan left/right and up/down, Shift-drag.
Touch screen: pinch/extend to zoom, swipe or two-finger rotate.""")

color_list = [color.white, color.purple, color.blue, color.green, color.black, color.orange, color.cyan, color.red, color.yellow]

all_points = []

max_rad = 0

for key in data.keys():
    p = data.get(key)
    print(p, key)
    all_points.append({'pos': vec(p[0], p[1], p[2]), 'radius': 1, 'color': color_list[random.randint(0, len(color_list)-1)]})
    if p[3] > max_rad:
        max_rad = p[3]

print(max_rad)

c = points(pos=all_points, size_units='world')

# half_range = int(sRange/2)
# neg = -half_range

# for i in range(0, N):
#     v1 = random.randint(neg, half_range)
#     v2 = random.randint(neg, half_range)
#     v3 = random.randint(neg, half_range)
#
#     all_vs.append(vertex(pos=vec(v1, v2, v3), color=color_list[random.randint(0, len(color_list)-1)]))
#
# for i in range(0, len(all_vs)-2):
#     t = triangle(vs=all_vs[i:i+3])


