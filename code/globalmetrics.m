function globalmetrics( vals_adj, motifs_norm )
% Code to calculate global metrics and colour morphospace according to e.g.
% global efficiency
%
% Inputs: vals_adj is a cell containing all of the adjacency matrices
%         motifs_norm is the normalised motif scores (output by 'plotmorphospace.m')
% Sarah Morgan, 28/05/2017

% This code uses functions from the Brain Connectivity Toolbox (need to make sure BCT is on path)

numFiles=length(vals_adj);
nodes=length(vals_adj{1,1});

% Modularity:
for num=1:numFiles
[Q value]=modularity_und(vals_adj{1,num},1);
modularity(num)=value;
end

%For global efficiency :

for num=1:numFiles
efficiency(num)=efficiency_bin(vals_adj{1,num},0);
end

%For local efficiency :

for num=1:numFiles
efficiency2(num)=sum(efficiency_bin(vals_adj{1,num},1))/nodes;
end

%For assortativity :

for num=1:numFiles
assort(num)=assortativity_bin(vals_adj{1,num},0);
end

%For clustering :

for num=1:numFiles
clust(num)=sum(clustering_coef_bu(vals_adj{1,num}))/nodes;
end

%For transitivity :

for num=1:numFiles
trans(num)=transitivity_bu(vals_adj{1,num});
end

[loadings,score]=princomp(motifs_norm);

x=loadings(:,1);
y=loadings(:,2);

% Now plot scatter plot of morphospace coloured by e.g. efficiency:
figure
scatter(x,y,50,efficiency,'filled')
xlabel('PC 1')
ylabel('PC 2')
title('Efficiency')

end