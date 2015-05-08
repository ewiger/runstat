#running_stat

Implementation of running variance/standard deviation (Welford 1962). This follows ["Accurately computing running variance"](http://www.johndcook.com/standard_deviation.html), derived from work by [Brendan O'Connor](http://github.com/brendano/running_stat).


The same interface borrowed from [arma](http://arma.sourceforge.net/docs.html#running_stat) is implemented in several languages.

function | comment
--- | --- 
X(scalar) | update the statistics so far using the given scalar 
X.min()   | get the minimum value so far 
X.max()   | get the maximum value so far 
X.mean()  | get the mean or average value so far 
X.var()  and  X.var(norm_type) | get the variance so far 
X.stddev()  and  X.stddev(norm_type) | get the standard deviation so far 
X.reset()	 | reset all statistics and set the number of samples to zero 
 X.count()	 | get the number of samples so far 

Other languages implement update as a separate method: **X.update()**

## C++

Use [arma](http://arma.sourceforge.net/docs.html#running_stat)

## python

### Installation

Pure python implementation.

```
pip install runstat
```

### Example

```python
from __future__ import print_function
import numpy as np
from runstat import RunStat

rs = RunStat()

X = np.random.rand(10)
for x in X:
    rs(x)

print(rs.mean)
print(rs.var)
print(rs.std)
```

## matlab

Pure matlab implementation.
