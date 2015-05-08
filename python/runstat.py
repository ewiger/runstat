'''
Implementation of running variance/standard deviation.


The MIT License (MIT)

Copyright (c) 2015 Yauhen Yakimovich <eugeny.yakimovitch@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
'''
from math import sqrt
from decimal import Decimal


__version__ = '1.0.0'


class RunStat(object):
    '''
    Class for keeping the running statistics of a continuously sampled one-
    or multi-dimensional process/signal.
    '''

    def __init__(self, dtype=Decimal):
        self.dtype = dtype
        # (running) mean
        self.m = dtype(0)
        # counter of updates
        self.n = 0
        # (running) sum of the recurrence form:
        # M(2,n) = M(2,n-1) + (x - mean(x_n))*(x - mean(x_{n-1}))
        self.M2 = dtype(0)
        # max/min
        self.max_value = dtype(0)
        self.min_value = dtype(0)
        # weight of items seen
        # TODO: implement this
        self.total_weight = dtype(1)

    @property
    def mean(self):
        return self.m

    @property
    def var(self):
        if self.n > 2:
            return self.M2 / (self.n - 1)
        return self.M2 / self.n

    @property
    def std(self):
        return self.dtype(sqrt(self.var))

    @property
    def min(self):
        return self.min_value

    @property
    def max(self):
        return self.max_value

    @property
    def count(self):
        return self.n

    def reset(self):
        self.n = 0
        self.is_started = False

    def update(self, value, weight=None):
        '''
        Update running stats with weight equals 1 by default.
        '''
        # Initialize.
        value = self.dtype(value)
        self.n = self.n + 1

        if self.n <= 1:
            # First update.
            self.m = value
            self.M2 = self.dtype(0)
            self.total_weight = self.dtype(0)
            self.n = self.dtype(1)
            return

        # Update max/min.
        if value > self.max_value:
            self.max_value = value
        elif value < self.min_value:
            self.min_value = value

        # No update.
        delta = value - self.m
        if delta == 0:
            return

        # Update running moments.
        self.m = self.m + delta / self.n

        if weight is None:
            # Ignore weight
            if self.n > 1:
                self.M2 = self.M2 + delta * (value - self.m)
            return

        # Weight-aware implementation.
        weight = self.dtype(weight)
        next_weight = self.total_weight + weight
        R = self.dtype(delta * (weight / next_weight))
        self.m = self.m + R
        if self.total_weight > 0:
            self.M2 = self.M2 + self.total_weight * delta * R
        self.total_weight = next_weight

    def __call__(self, *args, **kwds):
        self.update(*args, **kwds)

