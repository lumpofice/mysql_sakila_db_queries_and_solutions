import pandas as pd
from IPython.display import display
import logging
logging.basicConfig(level=logging.DEBUG, format=' %(asctime)s - %(levelname)s'
    ' - %(message)s')

logging.debug('Start of program')

# This script is used only to help us visualize the query solutions in table
# form

# 12)---------------------------------------------------------------------------
query12_1 = pd.read_csv('query12_1.csv')
display(query12_1)

query12_2 = pd.read_csv('query12_2.csv')
display(query12_2)
# ---------------------------------------------------------------------COMPLETE







