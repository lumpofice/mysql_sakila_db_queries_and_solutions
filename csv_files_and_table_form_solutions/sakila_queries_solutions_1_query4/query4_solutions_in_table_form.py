import pandas as pd
from IPython.display import display
import logging
logging.basicConfig(level=logging.DEBUG, format=' %(asctime)s - %(levelname)s'
    ' - %(message)s')

logging.debug('Start of program')

# This script is used only to help us visualize the query solutions in table
# form

# 4)---------------------------------------------------------------------------
query4_babystep1 = pd.read_csv('query4_babystep1.csv')
display(query4_babystep1)

query4 = pd.read_csv('query4.csv')
display(query4)
# ---------------------------------------------------------------------COMPLETE
