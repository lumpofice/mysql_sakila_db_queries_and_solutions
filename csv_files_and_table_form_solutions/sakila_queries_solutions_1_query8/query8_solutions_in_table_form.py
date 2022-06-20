import pandas as pd
from IPython.display import display
import logging
logging.basicConfig(level=logging.DEBUG, format=' %(asctime)s - %(levelname)s'
    ' - %(message)s')

logging.debug('Start of program')

# This script is used only to help us visualize the query solutions in table
# form

# 8)---------------------------------------------------------------------------
query8 = pd.read_csv('query8.csv')
display(query8)

query8_alternative = pd.read_csv('query8_alternative.csv')
display(query8_alternative)
# ---------------------------------------------------------------------COMPLETE



