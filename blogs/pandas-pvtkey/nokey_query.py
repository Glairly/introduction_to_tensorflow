#!/usr/bin/env python

def query_to_dataframe(query):
  import pandas as pd
  return pd.read_gbq(query,
                     project_id='cloud-training-demos',
                     dialect='standard')

query = """
SELECT
  year,
  COUNT(1) as num_babies
FROM
  publicdata.samples.natality
WHERE
  year > 2000
GROUP BY
  year
"""

df = query_to_dataframe(query)
print(df.head())

