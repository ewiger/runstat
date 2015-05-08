% Expecting to see:
%
%      added 0  now mean=0.00 var=0.00 std=0.00
%      added 1  now mean=0.50 var=0.25 std=0.50
%      added 2  now mean=1.00 var=0.67 std=0.82
%      added 3  now mean=1.50 var=1.25 std=1.12
%      added 4  now mean=2.00 var=2.00 std=1.41
%      added 5  now mean=2.50 var=2.92 std=1.71
%      added 6  now mean=3.00 var=4.00 std=2.00
%      added 7  now mean=3.50 var=5.25 std=2.29
%      added 8  now mean=4.00 var=6.67 std=2.58
%      added 9  now mean=4.50 var=8.25 std=2.87

% clear;
% rs = RunningStat.new();
% matX = randn(1000000,1)*2;
% for i = 1:1000000
%     rs.update(matX(i));
%     fprintf('added %-2d now mean=%.6f var=%.6f sd=%.6f\n', i, rs.mean(), rs.var(), rs.stddev());
% end
% 
% 

% Compare with native matlab implementation.
clear;
rs = RunningStat.new();
matX = randn(100,1)*2;
for i = 1:100
    rs.update(matX(i));    
end
running_result_mean = rs.mean;
native_result_mean = mean(matX);
running_result_std = rs.std;
native_result_std = std(matX);
running_result_var = rs.var;
native_result_var = var(matX);
length(find([running_result_mean ~= native_result_mean, ...
    running_result_std ~= native_result_std,...
    running_result_var ~= native_result_var]))
running_result_mean
native_result_mean
running_result_std
native_result_std
running_result_var
native_result_var
