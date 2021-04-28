'''
## Specify data input and model input file
## - uncomment model, that you want to use
## - only one model can be used at time!
'''

'''
## Model farm
'''
from data.library.farm.data import *
from model.library.farm.model import *

'''
## Model transport
'''
#from data.library.transport.data import *
#from model.library.transport.model import *


'''
## Model CPM
'''
''' wait-and-see model'''
#from data.library.cpm.data_ws import *
''' expected values model'''
#from data.library.cpm.data_ev import *
''' min-max model'''
#from data.library.cpm.data_mm import *
'''individual scenario model'''
#from data.library.cpm.data_is import *
''' two-staged model'''
#from data.library.cpm.data_ts import *
''' two-staged with evpi and vss'''
#from data.library.cpm.data_ts_evpi_eev_vss import *
'''
# Model file here is the same, you need to select which gams model
# you want to use in model.com.model in get_gams_model() and get_return_values()
'''
#from model.library.cpm.model import *


'''
# Application on real data
# Optimized model based on https://www.vutbr.cz/studenti/zav-prace/detail/121416
'''
#from data.library.tetour.data import *
#from model.library.tetour.model import *