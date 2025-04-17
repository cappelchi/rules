# Guidelines for writing with Dask

1. Avoid Very Large Partitions. So if you have 100 MB chunks, then Dask is likely to use at least 1 GB of memory.
2. Avoid Very Large Graphs
