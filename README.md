# Motif-Morphospace
This repo describes how to take a bunch of networks and create their motif morphospace, as described in: http://www.biorxiv.org/content/early/2017/06/21/153320. If you use this code, please cite that paper. The code is written in Matlab.

Creating the motif morphospace involves calculating the motif profile of each network, then performing a principal component analysis (PCA) across all of the networks to extract the principal components (PCs). You can then plot the individual networks within the PC space.

Input *(what you need to use this code)*: undirected, binary adjacency matrices. All of the matrices should have the same number of nodes and edges, because motif counts depend (non-trivially) on the number of nodes and edges. So if your matrices have different numbers of nodes or edges, you're no longer comparing like with like. This code could be modified quite easily to work for directed networks (and hence directed motifs), although the way it's described here is for undirected networks.

Outputs: average motif profile for your networks, variance explained by each PC, plot of motif morphospace and plots of motif morphospace coloured by global network metrics.

**Steps:**

**1. Import your adjacency matrices into Matlab**

Obviously how you do this depends on your data, but I normally use something like:

    fnames = dir('*.txt');
    numfids = length(fnames);
    vals_adj = cell(1,numfids);
    for K = 1:numfids      vals_adj{K} = importfile(fnames(K).name);    end

where importfile is a function to import the file in the correct form (as a matrix).

Ultimately, the goal is to have a cell array "vals{1,N}" where each cell contains one of your N networks.

**2. Run the code adjacency2orca.m**

This code accepts your adjacency matrices and puts them in the format required for orca, which is a piece of software used to count motifs (more details below). You can run it using the command:

    vals_orca=adjacency2orca(vals_adj);
    
Next you want to output N files (one for each network), which contain the networks in the right format for orca. So create a new directory (called, e.g. vals_orca) for these files and make sure you're in it, then run:

    for num=1:100
        fid = fopen(strcat('orca_',num2str(num),'.txt'),'w');
        fprintf(fid,'%d\t%d\n',vals_orca{1,num}');
        fclose(fid);
    end

**3. Count the motifs**

Now we're ready to count the motifs! There are lots of ways to do this- e.g. [mfinder](https://www.weizmann.ac.il/mcb/UriAlon/download/network-motif-software) (by Milo et al., "Network Motifs: Simple Building Blocks of Complex Networks", Science, 2002), [FANMOD](http://theinf1.informatik.uni-jena.de/motifs/) (by S. Wernicke and F. Rasche, "FANMOD: a tool for fast network motif detection", Bioinformatics, 2006), the [Brain Connectivity Toolbox](https://sites.google.com/site/bctnet/measures/list#TOC-Motifs) and [orca](http://www.biolab.si/supp/orca/) (by Tomaž Hočevar and Janez Demšar, "A combinatorial approach to graphlet counting", Bioinformatics, 2014). Here I'll describe how to use orca, which I like because it's super fast and it also gives you a motif count per region, but the others would work equally well. If you use a different code from orca, bear in mind that it will almost certainly require a (sometimes subtly) different input. The output will probably also be different, e.g. in terms of the ordering of the motifs (is motif 1 a square, a chain or something else? You need to check!), whether it outputs motifs per region and whether the motifs counts are normalised to the total number of motifs or not.

To use orca, first install it from [here](http://www.biolab.si/supp/orca/).

Then run the application on your data. The command (which you can run straight from the command line in Windows) will be something like:

    orca.exe 4 myfile.txt myfile.txt_out
    
Here 4 refers to the maximum number of nodes you want the motifs you're counting to have. E.g. if you put 4 then you'll be counting 4 node motifs, put 5 if you also need 5 node motifs etc. The larger the motifs, the longer they take to count. The time taken will also depend on the number of nodes and edges your networks have.

We want to loop this command over all of the networks, so in Windows you need to go to the command line, navigate into the folder where you've saved the networks (e.g. the folder vals_orca above) and then run something like:

    for %f in (.\*) do orca.exe 4 %f %f.OUT

Here I'm counting everything up to and including 4 node motifs. Note that all of the files in the directory will be counted.

Once it's run you should have a bunch of files with the extension .OUT. These files contain the motif counts.

**4. Import your orca results**

To recap- so far we have imported our networks and counted the number of every motif with 4 or fewer nodes in every network.
Now we need to import the results from orca. To do this, you need to create the function 'importfile2'- this can be done manually in Matlab by going to 'Import data', selecting the option 'matrix', then 'Import selection' and 'Generate function'. Save the result in the same folder as the orca output files. Then, from the folder with your orca output files, run:

    numFiles=100;
    orca_output = cell(1,numFiles);
    for fileNum = 1:numFiles
    	fileName = ['orca_',num2str(fileNum),'.txt.OUT'];
    	orca_output{fileNum} = importfile(fileName);
    end

Note that in the code above numFiles should be set to the number of networks/files you have (e.g. here we have 100 networks).

**5. Calculate and plot your morphospace**

The code plotmorphospace.m allows you to:
  - Calculate and plot the motif profiles
  - Calculate and plot the cumulative variability explained by each PC
  - Calculate and plot the morphospace
  
You can run it directly using the command 'plotmorphospace' in Matlab. The code is set up for 4 node motifs. If you want to consider motifs with a different number of nodes, you will need to modify it.

Congratulations- you have calculated your motif morphospace!! :)

**6. Do any other analyses you're interested in!**

Obviously there are lots of things you might want to do with your motif morphospace. Below is one possible analysis with a link to the code. Please feel free to add your own analyses to the list and put the relevant code in the folder!

  - 'globalmetrics.m': Calculates global network measures and colours the morphospace according to these measures
