classdef MatlabRunningStatVecImpl < RunningStatVec
       
    properties (Access='private')
       vec_length;
       % *(running) mean
       m = 0;
       % * counter of updates
       n = 0;
       % (running) sum of the recurrence form: 
       % M(2,n) = M(2,n-1) + (x - mean(x_n))*(x - mean(x_{n-1}))
       M2 = 0;
       % max/min
       max_value = 0;
       min_value = 0;
    end
    
    methods
        function result = mean(self)
            result = self.m;
        end
        
        function result = var(self)
            if self.n > 2
                result = self.M2 ./ (self.n - 1);
            else
                result = self.M2 ./ self.n;
            end
        end
        
        function result = std(self)
            result = sqrt(self.var);
        end
        
        function result = min(self)
            result = 0;
        end
        
        function result = max(self)
            result = 0;
        end
        
        function result = count(self)
            result = self.n;
        end
        
        function reset(self)            
            self.n = 0;
        end
        
        function update(self, value, varargin)
            % Get linear length of the vector value. 
            if (self.n <= 1)
                self.vec_length = numel(value);
            end
            % Update running stats with weight equals 1 by default.
            if nargin==1
                weight = varargin{1};
            else
                weight = ones(size(value));
            end
            
            self.n = self.n + 1;
            if (self.n <= 1)
                self.m = double(value);
                self.M2 = zeros(size(value));
                self.n = 1;
                return
            end
            % update max/min
%             if value > self.max_value
%                 self.max_value = value;
%             elseif value < self.min_value
%                 self.min_value = value;
%             end
            % update running moments
            delta = value - self.m;
            if delta == 0
                return
            end
            self.m = self.m + delta ./ self.n;
            if self.n > 1
                self.M2 = self.M2 + delta .* (value - self.m);
            end       
        end
    end
    
end
