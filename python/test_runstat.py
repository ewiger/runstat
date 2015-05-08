'''
Usage:

cd python && nosetests
'''
from math import *
from decimal import getcontext, Decimal
import numpy as np
from runstat import RunStat


def test_basic_stat():
    getcontext().prec = 12

    rs = RunStat()

    X = np.random.rand(10)
    for x in X:
        rs(x)

    _error = 0.1
    assert abs(rs.mean - Decimal(np.mean(X))) <= _error
    assert abs(rs.var - Decimal(np.var(X))) <= _error
    assert abs(rs.std - Decimal(np.std(X))) <= _error
