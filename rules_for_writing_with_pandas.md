# Guidelines for writing with pandas

# Bad example

```python

df = pd.read_csv('data.csv')

x = df[df['column1'] == 'value']

```

# Good example

```python

data = pd.read_csv('data.csv')

filtered_data = data[data['column1'] == 'value']

```

Avoid using chained indexing Chained indexing is a common mistake in pandas where multiple indexing or slicing operations are performed on a dataframe in a single statement. This can lead to unpredictable results and make the code harder to debug. Instead, use loc or iloc to access data in a single statement. Here are some code snippets to illustrate the best practices, Avoid using chained indexing :

# Bad example

```python

df['column1'][df['column2'] == 'value'] = 0

```

# Good example

```python

df.loc[df['column2'] == 'value', 'column1'] = 0

```

Avoid using inplace=True In pandas, inplace=True is used to modify the dataframe in place without creating a copy. However, this can be dangerous as it modifies the original dataframe and can make the code harder to understand. Instead, assign the result of the operation to a new variable. Here are some code snippets to illustrate the best practices

# Bad example

```python

df.dropna(inplace=True)

```

# Good example

```python

clean_df = df.dropna()

```

Use vectorized operations Pandas provides a variety of vectorized operations, which allow operations to be performed on entire columns or rows of data. This is faster and more efficient than using loops or apply functions. Here are some code snippets to illustrate the best practices

# Bad example

```python

for i in range(len(df)):

df.loc[i, 'column1'] = df.loc[i, 'column1'] + 1

```

# Good example

```python

df['column1'] = df['column1'] + 1

```

Handle missing data appropriately Missing data can cause issues with analysis and can lead to errors. It is important to handle missing data appropriately using functions such as dropna, fillna, and interpolate. Here are some code snippets to illustrate the best practices

# Bad example

```python

df = df.fillna(0)

```

# Good example

```python

df = df.interpolate()

```

Use groupby to aggregate data Groupby is a powerful function in pandas that allows data to be grouped by one or more columns and then aggregated using various functions such as sum, mean, and count. This can be a more efficient way to analyze data than using loops or apply functions. Here are some code snippets to illustrate the best practices

# Bad example

```python

result = []

for group in df.groupby('column1'):

result.append((group[0], group[1]['column2'].mean()))

```

# Good example

```python

result = df.groupby('column1')['column2'].mean().reset_index()

```

Avoid using iterrows Iterrows is a function in pandas that iterates over the rows of a dataframe. However, it can be slow and inefficient, especially for large datasets. Instead, use apply functions or vectorized operations to perform operations on data. Here are some code snippets to illustrate the best practices, Avoid using iterrows :

# Bad example

```python

for index, row in df.iterrows():

df.loc[index, 'column1'] = row['column2'] + row['column3']

```

# Good example

```python

df['column1'] = df['column2'] + df['column3']

```

Use the appropriate data types Pandas provides a variety of data types for handling different types of data such as integers, strings, and dates. It is important to use the appropriate data types to ensure that the data is handled correctly and efficiently. Here are some code snippets to illustrate the best practices, Use the appropriate data types :

# Bad example

```python

df['column1'] = df['column1'].astype('str')

```

# Good example

```python

df['column1'] = df['column1'].astype('category')

```
