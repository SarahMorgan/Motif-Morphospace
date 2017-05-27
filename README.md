# Motif-Morphospace
This repo describes how to take a bunch of networks and create their motif morphospace, as described in... The code is written in Matlab.

Creating the motif morphospace involves calculating the motif profile of each network, then performing a principal component analysis (PCA) across all of the networks to extract the principal components (PCs). You can then plot the individual networks within the PC space.

Input (what you need to use this code): undirected, binary adjacency matrices. All of the matrices should have the same number of nodes and edges, because motif counts depend (non-trivially) on the number of nodes and edges. So if your matrices have different numbers of nodes or edges, you're no longer comparing like with like.

Outputs: average motif profile for your networks, variance explained by each PC, plot of motif morphospace and plots of motif morphospace coloured by global network metrics.

**Steps:**

**1. Import your adjacency matrices into Matlab**

Obviously how you do this depends on your data, but I normally use something like:

    fnames = dir('*.txt');
    numfids = length(fnames);
    vals = cell(1,numfids);
    for K = 1:numfids
      vals{K} = importfile(fnames(K).name);
    end

where importfile is a function to import the file in the correct form (as a matrix).

Ultimately, the goal is to have a cell array "vals{1,N}" where each cell contains one of your N networks.

**2. Run the code adjacency2orca.m**

This code accepts your adjacency matrices and puts them in the format required for orca, which is a piece of software used to count motifs. You can run it using the command...

**3. Count the motifs**

Now we're ready to count the motifs! There are lots of ways to do this- e.g. mfinder (...), FANMOD (...) and orca (...). Here I'll describe how to use orca, which I like because it's super fast and it also gives you a motif count per region, but the others would work equally well. If you use a different code from orca, bear in mind that it will almost certainly require a (sometimes subtly) different input. The output will probably also be different, e.g. in terms of the ordering of the motifs (is motif 1 a square, a chain or something else? You need to check!), whether it outputs motifs per region and whether the motifs counts are normalised to the total number of motifs or not.

To use orca, first install it from...

Then run the application on your data. The command will be something like:


Once it's run you'll have a bunch of files called e.g. ...

**4. Calculate and plot your morphospace**

To recap- so far we have imported our networks and counted the number of every 4 node motif in every network. The code plotmorphospace.m allows you to:
  - Import your orca results
  - Calculate and plot the motif profiles
  - Calculate and plot the morphospace
  
You can run it directly using the command 'plotmorphospace' in Matlab.

Congratulations- you have calculated your motif morphospace!! :)

**5. Do any other analyses you're interested in!**

Obviously there are lots of things you might want to do with your motif morphospace. Below is a list of possible analyses with links to the code. Please feel free to add your own analyses to the list and put the relevant code in the folder!

  - Calculate global network measures and colour the morphospace according to these measures
  - Superimpose new data on top of your original morphospace (thanks ... for this one!)
