# LinearProject

Matlab files
corpus_plot.m --> graph of all corpus sentences with their semantic space (aka how closely related / categorized) -- 2D plot
D3_corpus_plot.m --> the same thing as above but 3d plot
directed_graph.m --> directed graph. THIS IS MAIN prediction algorithm 

We include figures for both our small_corpus, an array of about 8 text messages with a very small dictionary, and also a large_corpus, which 
includes abotu 2,000 words from a dataset. As this takes up lots of computational energy, we also created a precomputation folder that precomputes
the directed graph and corpus plot for the large dataset.