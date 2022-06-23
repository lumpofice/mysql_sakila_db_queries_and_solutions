import pandas as pd
from IPython.display import display
import logging
logging.basicConfig(level=logging.DEBUG, format=' %(asctime)s - %(levelname)s'
    ' - %(message)s')

logging.debug('Start of program')

# This script is used only to help us visualize the query solutions in table
# form

# 2)---------------------------------------------------------------------------
i_k = pd.read_csv('i_k.csv')
display(i_k)

i_kk = pd.read_csv('i_kk.csv')
display(i_kk)

query2 = pd.read_csv('query2.csv')
display(query2)
# ---------------------------------------------------------------------COMPLETE

