import pandas as pd
from IPython.display import display
import logging
logging.basicConfig(level=logging.DEBUG, format=' %(asctime)s - %(levelname)s'
    ' - %(message)s')

logging.debug('Start of program')

# This script is used only to help us visualize the query solutions in table
# form

# 11)---------------------------------------------------------------------------
query11 = pd.read_csv('query11.csv')
display(query11)
# ---------------------------------------------------------------------COMPLETE






