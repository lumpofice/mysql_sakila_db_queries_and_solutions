import pandas as pd
from IPython.display import display
import logging
logging.basicConfig(level=logging.DEBUG, format=' %(asctime)s - %(levelname)s'
    ' - %(message)s')

logging.debug('Start of program')

# This script is used only to help us visualize the query solutions in table
# form

# 1)---------------------------------------------------------------------------
query1_babystep1 = pd.read_csv('query1_babystep1.csv')
display(query1_babystep1)

query1_babystep2 = pd.read_csv('query1_babystep2.csv')
display(query1_babystep2)

query1 = pd.read_csv('query1.csv')
display(query1)
# ---------------------------------------------------------------------COMPLETE