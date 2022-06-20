import pandas as pd
from IPython.display import display
import logging
logging.basicConfig(level=logging.DEBUG, format=' %(asctime)s - %(levelname)s'
    ' - %(message)s')

logging.debug('Start of program')

# This script is used only to help us visualize the query solutions in table
# form

# 5)---------------------------------------------------------------------------
query5_babystep1 = pd.read_csv('query5_babystep1.csv')
display(query5_babystep1)

query5 = pd.read_csv('query5.csv')
display(query5)
# ---------------------------------------------------------------------COMPLETE
