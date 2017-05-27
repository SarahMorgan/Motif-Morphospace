function [ vals_fororca ] = adjacency2orca( vals_adj )
% Code to go from your adjacency matrices to input for orca
% Sarah Morgan, 27/05/2017

clear vals2 vals3 vals_fororca

n=length(vals_adj{1,1});
num_matrices=length(vals_adj);

enum=zeros(1,num_matrices);
vals2=cell(1,num_matrices);
vals3=cell(1,num_matrices);
vals_fororca=cell(1,num_matrices);

for num=1:num_matrices

    matrix=vals_adj{1,num};
    enum(num)=sum(sum(matrix))/2;

    for i=1:n
        for j=1:n

            if i>j && matrix(i,j)==1
                vals2{1,num}(n*(i-1)+j,1)=i;
                vals2{1,num}(n*(i-1)+j,2)=j;
                %vals2{1,num}(n*(i-1)+j,3)=1; %% mfinder only
            end
        end
    end
    
    vals2{1,num}( ~any(vals2{1,num},2), : ) = [];
end

for num=1:num_matrices
    vals3{1,num}=vals2{1,num}-1;
end

for num=1:num_matrices
    vals_fororca{1,num}=vertcat([n enum(num)],vals3{1,num});
end

end