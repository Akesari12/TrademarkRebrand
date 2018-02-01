
# coding: utf-8

# In[ ]:

import pandas as pd 
import numpy as np
import pymongo


# In[ ]:
import difflib
import itertools
from fuzzywuzzy import fuzz
from fuzzywuzzy import process


# In[ ]:

df=pd.read_csv("EntityRef.csv")
df1=pd.read_csv("Unique Unmatched Names.csv")


# In[ ]:

## Convert text to lower
df['companyName']=df['companyName'].str.lower()
df1['companyName']=df1['companyName'].str.lower()

## Remove punctuation
df["companyName"] = df['companyName'].str.replace('[^\w\s]','')
df1["companyName"] = df1['companyName'].str.replace('[^\w\s]','')


## Remove tabs
#test['searchText'].str.strip()


# In[ ]:

compare = pd.MultiIndex.from_product([df['companyName'],
                                      df1['companyName']]).to_series()


# In[ ]:

a = [df.levenshtein_distance(x[0], x[1]) for x in itertools.combinations(df1,2)]


# In[ ]:

# In[ ]:

df['UniqueOwnerName'] = df['companyName'].apply(lambda x: difflib.get_close_matches(x, df1['companyName']))


# In[ ]:

df.to_csv("Matched Owner Names.csv")

