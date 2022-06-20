import pandas as pd
from IPython.display import display
import logging
logging.basicConfig(level=logging.DEBUG, format=' %(asctime)s - %(levelname)s'
    ' - %(message)s')

logging.debug('Start of program')

# This script is used only to help us visualize the query solutions in table
# form

# 13)---------------------------------------------------------------------------
query13 = pd.read_csv('query13.csv')
display(query13)

query13_observation = pd.read_csv('query13_observation.csv')
display(query13_observation)
# ---------------------------------------------------------------------COMPLETE








