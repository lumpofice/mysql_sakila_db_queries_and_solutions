import pandas as pd
from IPython.display import display
import logging
logging.basicConfig(level=logging.DEBUG, format=' %(asctime)s - %(levelname)s'
    ' - %(message)s')

logging.debug('Start of program')

# This script is used only to help us visualize the query solutions in table
# form

# 1)---------------------------------------------------------------------------
i_j_k = pd.read_csv('i_j_k.csv')
display(i_j_k)

i_j_kk = pd.read_csv('i_j_kk.csv')
display(i_j_kk)

i_jj_k = pd.read_csv('i_jj_k.csv')
display(i_jj_k)

i_jj_kk = pd.read_csv('i_jj_kk.csv')
display(i_jj_kk)

i = pd.read_csv('i.csv')
display(i)

ii_j_k = pd.read_csv('ii_j_k.csv')
display(ii_j_k)

ii_j_kk = pd.read_csv('ii_j_kk.csv')
display(ii_j_kk)

ii_jj_k = pd.read_csv('ii_jj_k.csv')
display(ii_jj_k)

ii_jj_kk = pd.read_csv('ii_jj_kk.csv')
display(ii_jj_kk)

ii_jjj_k = pd.read_csv('ii_jjj_k.csv')
display(ii_jjj_k)

ii_jjj_kk = pd.read_csv('ii_jjj_kk.csv')
display(ii_jjj_kk)

ii = pd.read_csv('ii.csv')
display(ii)
# ---------------------------------------------------------------------COMPLETE
