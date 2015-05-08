classdef MatlabRunningStatImpl < RunningStat
       
    properties (Access='private')       
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
       % weight of items seen
       %total_weight;       
    end
    
    methods
        function result = mean(self)
            result = self.m;
        end
        
        function result = var(self)
            %result = self.ss / self.total_weight;
            %result = (self.M2 / self.total_weight);            
            if self.n > 2
                result = self.M2 / (self.n - 1);
            else
                result = self.M2 / self.n;
            end
        end
        
        function result = std(self)
            result = sqrt(self.var);
        end
        
        function result = min(self)
            result = self.min_value;
        end
        
        function result = max(self)
            result = self.max_value;
        end
        
        function result = count(self)
            result = self.n;
        end
        
        function reset(self)            
            self.n = 0;
            self.is_started = false;
        end
        
        function update(self, value, varargin)
            % Update running stats with weight equals 1 by default.
            if nargin==1
                weight = varargin{1};
            else
                weight = 1;
            end
            self.n = self.n + 1;
            if (self.n <= 1)
                self.m = double(value);
                self.M2 = double(0);
                %self.total_weight = double(0);
                self.n = 1;
                return
            end
            % update max/min
            if value > self.max_value
                self.max_value = value;
            elseif value < self.min_value
                self.min_value = value;
            end
            % update running moments
            delta = value - self.m;
            if delta == 0
                return
            end
            self.m = self.m + delta/self.n;
            if self.n > 1
                self.M2 = self.M2 + delta * (value - self.m);
            end           
%   TODO: make weight based implementation            
%             next_weight = self.total_weight + weight;
%             delta = value-self.m;
%             R = double(delta * (weight / next_weight));
%             self.m = self.m + R;
%             if self.total_weight > 0
%                self.M2 = self.M2 + self.total_weight * delta * R;
%             end
%             self.total_weight = next_weight;
            
        end
    end
    
end


