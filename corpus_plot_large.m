% Corpus dictionary
corpus = readtable('corpus.csv');

% Load word embeddings
emb = fastTextWordEmbedding;

% Preprocess corpus: Convert to lowercase, remove punctuation, and split into sentences
text_column = corpus.text; 

% Convert the column to a string array
if ~isstring(text_column)
    text_column = string(text_column);  % Convert to string array
end

processed_corpus = lower(text_column);
processed_corpus = erasePunctuation(processed_corpus);

% Initialize figure
figure;
hold on;

% Assign different colors for each sentence graph
colors = lines(length(processed_corpus));

for s = 1:length(processed_corpus)
    % Split the sentence into words
    words = split(processed_corpus{s});
    
    % Initialize storage for 2D embeddings
    num_words = length(words);
    word_embeddings = zeros(num_words, 2); % Store only 2 dimensions
    
    % Fetch embeddings for each word
    for i = 1:num_words
        embedding = word2vec(emb, words{i});
        word_embeddings(i, :) = embedding(1:2); % Take the first 2 dimensions
    end
    
    % Plot the nodes
    scatter(word_embeddings(:,1), word_embeddings(:,2), 50, colors(s,:), 'filled');
    
    % Annotate the nodes with the word
    for i = 1:num_words
        text(word_embeddings(i,1), word_embeddings(i,2), words{i}, ...
            'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 10);
    end
    
    % Draw unidirectional edges between consecutive words
    for i = 1:num_words-1
        quiver(word_embeddings(i,1), word_embeddings(i,2), ...
               word_embeddings(i+1,1)-word_embeddings(i,1), ...
               word_embeddings(i+1,2)-word_embeddings(i,2), ...
               0, 'Color', colors(s,:), 'LineWidth', 1.5, 'MaxHeadSize', 0.2);
    end
end

% Set labels and title
xlabel('Dim 1');
ylabel('Dim 2');
title('Directed Word Graphs for Sentences in Corpus');
grid on;
hold off;
