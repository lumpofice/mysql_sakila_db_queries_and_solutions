import pandas as pd
from IPython.display import display
import logging
logging.basicConfig(level=logging.DEBUG, format=' %(asctime)s - %(levelname)s'
    ' - %(message)s')

logging.debug('Start of program')

# This script is used only to help us visualize the query solutions in table
# form

# 10)---------------------------------------------------------------------------
query10 = pd.read_csv('query10.csv')
display(query10)
# ---------------------------------------------------------------------COMPLETE





