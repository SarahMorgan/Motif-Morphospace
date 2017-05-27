# Motif-Morphospace
This repo describes how to take a bunch of networks and create their motif morphospace, as described in... The code is written in Matlab.

Creating the motif morphospace involves calculating the motif profile of each network, then performing a principal component analysis (PCA) across all of the networks to extract the principal components (PCs). You can then plot the individual networks within the PC space.

Input *(what you need to use this code)*: undirected, binary adjacency matrices. All of the matrices should have the same number of nodes and edges, because motif counts depend (non-trivially) on the number of nodes and edges. So if your matrices have different numbers of nodes or edges, you're no longer comparing like with like. This code could be modified quite easily to work for directed networks (and hence directed motifs), although the way it's described here is for undirected networks.

Outputs: average motif profile for your networks, variance explained by each PC, plot of motif morphospace and plots of motif morphospace coloured by global network metrics.

**Steps:**

**1. Import your adjacency matrices into Matlab**

Obviously how you do this depends on your data, but I normally use something like:

    fnames = dir('*.txt');
    numfids = length(fnames);
    vals_adj = cell(1,numfids);
    for K = 1:numfids
      vals_adj{K} = importfile(fnames(K).name);
    end

where importfile is a function to import the file in the correct form (as a matrix).

Ultimately, the goal is to have a cell array "vals{1,N}" where each cell contains one of your N networks.

**2. Run the code adjacency2orca.m**

This code accepts your adjacency matrices and puts them in the format required for orca, which is a piece of software used to count motifs. You can run it using the command: "adjacency2orca". Note that this command will output N files (one for each network), into the current directory (these files contain the network in the right format). So create a new directory (called, e.g. vals_orca) for these files and make sure you're in it before running the command.

**3. Count the motifs**

Now we're ready to count the motifs! There are lots of ways to do this- e.g. [mfinder](https://www.weizmann.ac.il/mcb/UriAlon/download/network-motif-software) (by Milo et al., "Network Motifs: Simple Building Blocks of Complex Networks", Science, 2002), [FANMOD](http://theinf1.informatik.uni-jena.de/motifs/) (by S. Wernicke and F. Rasche, "FANMOD: a tool for fast network motif detection", Bioinformatics, 2006) and [orca](http://www.biolab.si/supp/orca/) (by Tomaž Hočevar and Janez Demšar, "A combinatorial approach to graphlet counting", Bioinformatics, 2014). Here I'll describe how to use orca, which I like because it's super fast and it also gives you a motif count per region, but the others would work equally well. If you use a different code from orca, bear in mind that it will almost certainly require a (sometimes subtly) different input. The output will probably also be different, e.g. in terms of the ordering of the motifs (is motif 1 a square, a chain or something else? You need to check!), whether it outputs motifs per region and whether the motifs counts are normalised to the total number of motifs or not.

To use orca, first install it from [here](http://www.biolab.si/supp/orca/).

Then run the application on your data. The command (which you can run straight from the command line in Windows) will be something like:

    orca.exe 4 example.in example.out
    
Here 4 refers to the maximum number of nodes you want the motifs you're counting to have. E.g. if you put 4 then you'll be counting 4 node motifs, put 5 if you also need 5 node motifs etc. The larger the motifs, the longer they take to count. The time taken will also depend on the number of nodes and edges your networks have.

We want to loop this command over all of the networks, so in Windows you need to go to the command line, navigate into the folder where you've saved the networks (e.g. the folder vals_orca above) and then run something like:

    for %f in (.\*) do orca.exe 4 %f %f.OUT

Here I'm counting everything up to 4 node motifs. Note that all of the files in the directory will be counted.

Once it's run you should have a bunch of files with the extension .OUT. These files contain the motif counts.

**4. Calculate and plot your morphospace**

To recap- so far we have imported our networks and counted the number of every motif with 4 or fewer nodes in every network. The code plotmorphospace.m allows you to:
  - Import your orca results
  - Calculate and plot the motif profiles
  - Calculate and plot the morphospace
  
You can run it directly using the command 'plotmorphospace' in Matlab. The code is set up for 4 node motifs. If you want to consider motifs with a different number of nodes, you will need to modify it.

Congratulations- you have calculated your motif morphospace!! :)

**5. Do any other analyses you're interested in!**

Obviously there are lots of things you might want to do with your motif morphospace. Below is a list of possible analyses with links to the code. Please feel free to add your own analyses to the list and put the relevant code in the folder!

  - Calculate global network measures and colour the morphospace according to these measures
  - Superimpose new data on top of your original morphospace (many thanks to... for this!)
