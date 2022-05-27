import pandas as pd
from IPython.display import display
import logging
logging.basicConfig(level=logging.DEBUG, format=' %(asctime)s - %(levelname)s'
    ' - %(message)s')

logging.debug('Start of program')

# This script is used only to help us visualize the query solutions in table
# form

# 2)---------------------------------------------------------------------------
query2_babystep1 = pd.read_csv('query2_babystep1.csv')
display(query2_babystep1)

query2_babystep2 = pd.read_csv('query2_babystep2.csv')
display(query2_babystep2)

query2 = pd.read_csv('query2.csv')
display(query2)
# ---------------------------------------------------------------------COMPLETE