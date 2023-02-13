from controllers.MLEngine import MLEngine
from tqdm import tqdm
from mayavi import mlab

def extract(lst, ind):
    return list(list(zip(*lst))[ind])

# Cells
# 127 - ~2500
# 10912 - almost 11,000
# 1321 - ~9000

print('start')
mle = MLEngine()
print('gen neuron')
neu = mle.createNeuron(10912, 'i')
print('add to path')
mle.eng.addpath('C:/Users/murra/Documents/SLU/SLU_OSSC/MATLAB/SBFSEM-tools/+sbfsem/+render/')
print('hitting cylinder')
fv = mle.eng.render(neu)
fv = mle.eng.allFV(neu)

verts = fv['vertices']
faces = fv['faces']

x = extract(verts, 0)
y = extract(verts, 1)
z = extract(verts, 2)

for face in tqdm(faces):
    for i in range(0, len(face)):
        face[i] = int(face[i]) - 1

mlab.triangular_mesh(x, y, z, faces)
mlab.show()
