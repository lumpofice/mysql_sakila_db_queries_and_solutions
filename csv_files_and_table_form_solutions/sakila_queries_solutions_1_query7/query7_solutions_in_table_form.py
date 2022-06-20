import pandas as pd
from IPython.display import display
import logging
logging.basicConfig(level=logging.DEBUG, format=' %(asctime)s - %(levelname)s'
    ' - %(message)s')

logging.debug('Start of program')

# This script is used only to help us visualize the query solutions in table
# form

# 7)---------------------------------------------------------------------------
query7_babystep1 = pd.read_csv('query7_babystep1.csv')
display(query7_babystep1)

query7 = pd.read_csv('query7.csv')
display(query7)
# ---------------------------------------------------------------------COMPLETE


