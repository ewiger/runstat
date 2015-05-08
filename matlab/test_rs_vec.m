clear;
rs = RunningStatVec.new();
%matX = randn(1024,1024,200);
%matX = randn(1024,1024,10);
matX = randn(4,4,3)
% matX = ones(4,4,2);
% matX(:,:,1) = [ 1 2 3 4; 5 6 7 8; 1 1 1 1; 1 1 1 1];
% matX(:,:,2) = [ 2 2 3 4; 5 6 7 8; 1 1 1 1; 1 1 1 1];
% matX(:,:,3) = [ 3 2 3 4; 5 6 7 8; 1 1 1 1; 1 1 1 1];

tic
for k = 1:size(matX,3)    
    rs.update(matX(:,:,k));    
end
toc

running_result_mean = rs.mean();
running_result_var = rs.var();
running_result_std = rs.std();

native_result_mean = ones(size(matX(:,:,1)));
native_result_var = ones(size(matX(:,:,1)));
native_result_std = ones(size(matX(:,:,1)));
tic
% for i = 1:size(matX,1)
%     for j = 1:size(matX,2)        
%         native_result_mean(i,j) = mean(matX(i,j,:));
%         native_result_var(i,j) = var(matX(i,j,:));
%         native_result_std(i,j) = std(matX(i,j,:));        
%     end
% end
native_result_mean = mean(matX,3);
native_result_var = var(matX,0,3);
native_result_std = std(matX,0,3);        
toc

% number of unequal results
length(find(running_result_mean ~= native_result_mean))
length(find(running_result_std ~= native_result_std))
length(find(running_result_var ~= native_result_var))
