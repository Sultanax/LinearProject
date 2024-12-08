# Simplicity is Key: An Approach to Predictive Text Using Graph Theory and Adjacency Matrices

This project explores predictive text through a minimalist yet powerful approach leveraging graph theory and adjacency matrices. We compare our method to a more complex LSTM model for context-based next-word prediction.

## Files and Descriptions

### MATLAB Files
- **`corpus_plot.m`**  
  Generates a 2D plot visualizing all corpus sentences in their semantic space, demonstrating how closely related or categorized they are.
  
- **`D3_corpus_plot.m`**  
  Creates a 3D plot of corpus sentences, providing a more detailed view of their semantic relationships.
  
- **`directed_graph.m`**  
  Implements the directed graph-based prediction algorithm, which is the core of this project. This file is the main program for generating predictions.

### Data
- **Small Corpus:**  
  A compact dataset containing approximately 8 text messages, designed for quick evaluation with a small dictionary.
  
- **Large Corpus:**  
  A comprehensive dataset of around 2,000 words, derived from a larger text dataset, offering a robust test of the algorithm's capabilities.

### Precomputation Folder
Includes precomputed results for the directed graph and corpus plots for the large dataset to optimize runtime and reduce computational demands.

### LSTM Code
The project includes an LSTM-based next-word prediction implementation, adapted from the article *“Next Word Prediction with Deep Learning in NLP”* by Geeks for Geeks, for comparison purposes.

## How to Run the Project
1. Clone the repository:  
   ```bash
   git clone <repository-url>
2. Open MATLAB and upload the .m files into your workspace.
3. Modify the input word in the directed_graph.m file to test predictions.
4. Execute the scripts to generate results or use precomputed files for the large dataset.

