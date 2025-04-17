# Guidelines for writing with Dask

## Data Structures

### Rule 1: Match your data structure to your use case

| Data Structure | Best For | When to Avoid |
|----------------|----------|---------------|
| Dask DataFrame | Tabular data, pandas-like operations | When operations would be better expressed as array math |
| Dask Array | N-dimensional data, NumPy-like operations | Irregular data structures, operations requiring pandas features |
| Dask Bag | Unstructured or semi-structured data, map/filter/reduce operations | When data has a clear tabular or array structure |

# Good: Using Dask DataFrame for tabular data
```pyton
import dask.dataframe as dd
df = dd.read_csv('data/*.csv')
result = df.groupby('column').mean()
```

# Good: Using Dask Array for numerical computations
```pyton
import dask.array as da
arr = da.random.random((10000, 10000), chunks=(1000, 1000))
result = arr.mean(axis=0)
```

# Good: Using Dask Bag for processing JSON data
```pyton
import dask.bag as db
bag = db.read_text('data/*.json').map(json.loads)
result = bag.filter(lambda x: x['value'] > 100).count()
```

### Rule 2: Choose chunk sizes carefully

- For Dask Arrays: Target chunks of 100MB-1GB each
- For Dask DataFrames: Aim for chunks with 10 million to 100 million rows
- Balance memory usage with parallelism

# Good: Specifying reasonable chunk sizes
```pyton
df = dd.read_csv('large-file.csv', blocksize='64MB')
arr = da.ones((10000, 10000), chunks=(1000, 1000))  # ~8MB chunks
```

# Less efficient: Chunks too small leads to task scheduling overhead. Too many small tasks
```pyton
arr_inefficient = da.ones((10000, 10000), chunks=(100, 100))
```

## Data Loading and I/O

### Rule 3: Leverage native file formats

- Preferred formats: Parquet, HDF5, Zarr (avoid CSV when possible)
- Use partitioned storage formats that support parallel reads

# Good: Writing to an efficient format
```pyton
df = dd.read_csv('data/*.csv')
df.to_parquet('data/parquet/', engine='pyarrow', partition_on=['category'])
```

# Better for future reads:
```pyton
df = dd.read_parquet('data/parquet/', engine='pyarrow')
```

### Rule 4: Load only what you need

- Use column selection whenever possible
- Apply filtering early in your pipeline
- Use partitioning to your advantage

# Good: Only loading necessary columns
```pyton
df = dd.read_parquet('data/parquet/', columns=['date', 'value', 'category'])
```

# Good: Filtering early
```pyton
df = dd.read_parquet('data/parquet/', filters=[('category', '==', 'A')])
```

## Task Scheduling and Execution

### Rule 5: Delay computation until necessary

- Build computation graphs with lazy evaluation
- Call .compute() or .persist() only when needed

# Good: Building up computation before execution
```pyton
df = dd.read_parquet('data/parquet/')
filtered = df[df['value'] > 100]
result = filtered.groupby('category').mean()
```
# Only now compute the result. This triggers actual computation
```pyton
final = result.compute()
```

### Rule 6: Use persist() strategically

- Use .persist() for intermediate results that will be reused
- Consider available memory when persisting

# Good: Persisting a filtered dataset that will be reused
```pyton
df = dd.read_parquet('data/*.parquet')
filtered_df = df[df['value'] > threshold].persist()
```

# Now reuse filtered_df in multiple operations
```pyton
result1 = filtered_df.groupby('category').mean().compute()
result2 = filtered_df['other_column'].value_counts().compute()
```
## Performance Optimization

### Rule 7: Profile before optimizing

- Use the Dask dashboard to visualize task execution
- Identify bottlenecks in computation graphs

# Starting a client with dashboard
from dask.distributed import Client
```pyton
client = Client()  # Dashboard URL will be printed
```

# Now run your computation and watch the dashboard
```pyton
result = df.groupby('column').mean().compute()
```

### Rule 8: Minimize shuffling operations
- Limit use of operations that require data shuffling:
  - set_index()
  - groupby() with non-index columns
  - .merge() on non-partitioning columns

# Less efficient: Requires full data reshuffling
```pyton
df = df.set_index('arbitrary_column')
```

# More efficient: If possible, design workflows to avoid shuffling
# For example, if you need to join on 'customer_id', partition by it first
```pyton
df1 = df1.set_index('customer_id')
df2 = df2.set_index('customer_id')
joined = df1.join(df2)  # Now more efficient
```

### Rule 9: Optimize memory usage

- Use map_partitions() to apply memory-efficient operations
- Consider map_overlap() for stencil/window operations

# Good: Processing each partition independently
```pyton
def my_function(partition_df):
    # Complex operation that benefits from being applied to smaller chunks
    return process_data(partition_df)

result = df.map_partitions(my_function)
```
## Error Handling and Debugging

### Rule 10: Test on small data first

- Validate your workflow on a small subset before scaling
- Use .head() or sample small number of partitions

# Good: Testing logic on a small sample
```pyton
sample_df = df.head(1000)  # Get pandas DataFrame with first 1000 rows
```
# or
```pyton
sample_ddf = df.partitions[0:2]  # Get Dask DataFrame with first 2 partitions
```

# Test your logic
```pyton
test_result = process_data(sample_df)
```

### Rule 11: Implement exception handling

- Wrap complex operations in try/except
- Use retries for operations prone to intermittent failures

```pyton
from dask.distributed import Client, worker_client

def process_with_retry(partition, max_retries=3):
    for attempt in range(max_retries):
        try:
            return complex_processing(partition)
        except TemporaryError as e:
            if attempt == max_retries - 1:
                raise
            time.sleep(1)  # Wait before retrying

result = df.map_partitions(process_with_retry)
``` 

## Advanced Topics

### Rule 12: Combine with other libraries efficiently

- Use dask_ml for scalable machine learning
- Handle interoperability with NumPy and pandas correctly

# Machine Learning with Dask
```pyton
from dask_ml.preprocessing import StandardScaler
from dask_ml.linear_model import LogisticRegression

scaler = StandardScaler()
X_scaled = scaler.fit_transform(X_dask)
model = LogisticRegression()
model.fit(X_scaled, y_dask)
``` 

### Rule 13: Use appropriate schedulers

- Local scheduler: For development and small datasets
- Distributed scheduler: For production and large datasets
- YARN/Kubernetes: For integration with existing infrastructure

# Local scheduler (default)
```pyton
result = df.mean().compute()
``` 

# Distributed scheduler
# Connect to existing cluster
```pyton
from dask.distributed import Client
client = Client('scheduler-address:8786')
```  
# or
```pyton
client = Client(n_workers=4)  # Create local cluster
result = df.mean().compute()  # Now uses distributed scheduler
```
### Rule 14: Customize task fusion

- Adjust task fusion settings for memory/performance tradeoffs
- Use optimization_level to control task fusion

# Less fusion - more tasks but less memory per task
```pyton
with dask.config.set({'optimization.fuse.active': False}):
    result = df.groupby('key').mean().compute()
```

# More aggressive fusion - fewer tasks, potentially higher memory usage
```pyton
with dask.config.set({'optimization.fuse.active': True, 
                     'optimization.fuse.ave-width': 10}):
    result = df.groupby('key').mean().compute()
```
## Real-World Use Cases

### Case Study 1: Processing Terabytes of Log Files

# Process logs stored in S3 as gzipped JSON
```pyton
import dask.bag as db
import boto3
from distributed import Client

client = Client(n_workers=20)  # Set up a cluster
```

# Create a list of S3 file paths.
```pyton
s3 = boto3.client('s3')
files = ['s3://bucket/logs/2023/' + obj['Key'] 
         for obj in s3.list_objects(Bucket='bucket', Prefix='logs/2023/')['Contents']]
```

# Process logs
```pyton
logs = db.read_text(files).map(json.loads
```

# Extract and analyze error rates by service
```pyton
errors = logs.filter(lambda log: log['level'] == 'ERROR')
by_service = errors.pluck('service').frequencies()
result = by_service.compute()
```

### Case Study 2: Time Series Analysis on Financial Data

```pyton
import dask.dataframe as dd
import pandas as pd
```

# Load multiple years of minute-by-minute stock data
```pyton
df = dd.read_parquet('s3://bucket/stocks/*.parquet',
                     columns=['timestamp', 'symbol', 'price', 'volume'])
```

# Partition data by date for time-based operations
```pyton
df['date'] = df.timestamp.dt.date
df = df.set_index('date')  # Makes time-based queries faster
```

# Calculate daily volatility for each stock
```pyton
def calc_daily_volatility(partition):
    return partition.groupby('symbol')['price'].agg(
        lambda x: x.pct_change().std())

volatility = df.map_partitions(calc_daily_volatility)
result = volatility.compute()
```

## Resources for Further Learning

1. [Official Dask Documentation](https://docs.dask.org/)
2. [Dask Examples Repository](https://github.com/dask/dask-examples)
3. [Dask Patterns](https://docs.dask.org/en/latest/patterns.html)
4. [Dask Dashboard Documentation](https://docs.dask.org/en/latest/dashboard.html)
5. [Coiled Blog](https://coiled.io/blog/) - Real-world Dask use cases and tips

## Diagnostic Tools

- **Dask Dashboard**: Visualize task streams, memory usage, and task graphs
- **dask.distributed.performance_report()**: Generate execution reports
- **ProfilePlugin**: Profile CPU usage in distributed workloads

```pyton
from dask.distributed import Client, performance_report

client = Client()
with performance_report(filename="dask-report.html"):
    result = df.groupby('key').mean().compute()
```

