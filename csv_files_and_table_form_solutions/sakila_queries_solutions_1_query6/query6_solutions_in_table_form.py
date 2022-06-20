import pandas as pd
from IPython.display import display
import logging
logging.basicConfig(level=logging.DEBUG, format=' %(asctime)s - %(levelname)s'
    ' - %(message)s')

logging.debug('Start of program')

# This script is used only to help us visualize the query solutions in table
# form

# 6)---------------------------------------------------------------------------
query6_babystep1 = pd.read_csv('query6_babystep1.csv')
display(query6_babystep1)

query6 = pd.read_csv('query6.csv')
display(query6)
# ---------------------------------------------------------------------COMPLETE

