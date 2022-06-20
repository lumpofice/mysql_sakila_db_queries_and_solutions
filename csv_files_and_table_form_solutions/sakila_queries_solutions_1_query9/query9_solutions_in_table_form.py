import pandas as pd
from IPython.display import display
import logging
logging.basicConfig(level=logging.DEBUG, format=' %(asctime)s - %(levelname)s'
    ' - %(message)s')

logging.debug('Start of program')

# This script is used only to help us visualize the query solutions in table
# form

# 9)---------------------------------------------------------------------------
query9 = pd.read_csv('query9.csv')
display(query9)

query9_supportingquery = pd.read_csv('query9_supportingquery.csv')
display(query9_supportingquery)
# ---------------------------------------------------------------------COMPLETE




