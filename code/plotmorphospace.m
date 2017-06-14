function [ motifs_norm ] = plotmorphospace( orca_output )
% Code to plot the morphospace
% Sarah Morgan, 28/05/2017

% this part is set up specifically for 4 node motifs. The orca output actually contains
% motif position counts per node and this script uses those nodal motif counts to calculate
% the total 4 node motif counts across the whole network.

numFiles=length(orca_output);

motifs=zeros(numFiles,6);
motifs_norm=zeros(numFiles,6);

for ind=1:numFiles
matrix=sum(orca_output{1,ind},1);
motifs(ind,1)=matrix(1,5)./2;
motifs(ind,2)=matrix(1,8);
motifs(ind,3)=matrix(1,9)./4;
motifs(ind,4)=matrix(1,10);
motifs(ind,5)=matrix(1,14)./2;
motifs(ind,6)=matrix(1,15)./4;
end

% normalise with respect to the total number of motifs:

total_motifs=sum(motifs,2);
for ind=1:numFiles
motifs_norm(ind,:)=100*motifs(ind,:)./total_motifs(ind);
end

% save motifs and motifs_norm:

dlmwrite('motifs.dat',motifs)
dlmwrite('motifs_norm.dat',motifs)

% plot motif profile:

figure
errorbar(1:6,mean(motifs_norm),std(motifs_norm))
xlabel('Motif')
ylabel('Mean motif profile')

% calculate the PCs:

numvars=6;
[loadings,score,latent]=princomp(motifs_norm);

% calculate and plot the cumulative variability explained by PC:
percentagevar=100*cumsum(latent)/sum(latent);

figure
plot(1:6,percentagevar,'x-');
xlabel('Principal component')
ylabel('Cumulative variability explained (%)')

% plot motif morphospace biplot:

vbls = {'m1','m2','m3','m4','m5','m6'};
varnames=vbls;

figure
hold on;
scatter(score(:,1), score(:,2), 5, 'ro','filled');
scale = max((abs(score(:,1:2)))) ./ max((abs(loadings(:,1:2))));
scatter(loadings(:,1)*scale(1), loadings(:,2)*scale(2), 'bo', 'filled');
for i = 1:numvars
    line([0,loadings(i,1)*scale(1)],...
        [0,loadings(i,2)*scale(2)], 'Color', 'b');
    text(loadings(i,1)*scale(1)-1, loadings(i,2)*scale(2), varnames{i},'FontSize',16);
end

xlabel('PC 1');
ylabel('PC 2');
set(gca,'fontsize',16)

xL = xlim;
yL = ylim;
line([0 0], yL,'Color','k');
line(xL, [0 0],'Color','k');

end
