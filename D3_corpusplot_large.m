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

% Initialize figure for 3D plot
figure;
hold on;
view(3); % Set the view to 3D

% Assign different colors for each sentence graph
colors = lines(length(processed_corpus));

for s = 1:length(processed_corpus)
    % Split the sentence into words
    words = split(processed_corpus{s});
    
    % Initialize storage for 3D embeddings
    num_words = length(words);
    word_embeddings = zeros(num_words, 3); % Store 3 dimensions
    
    % Fetch embeddings for each word
    for i = 1:num_words
        embedding = word2vec(emb, words{i});
        word_embeddings(i, :) = embedding(1:3); % Take the first 3 dimensions
    end
    
    % Plot the nodes in 3D
    scatter3(word_embeddings(:,1), word_embeddings(:,2), word_embeddings(:,3), 50, colors(s,:), 'filled');
    
    % Annotate the nodes with the word
    for i = 1:num_words
        text(word_embeddings(i,1), word_embeddings(i,2), word_embeddings(i,3), words{i}, ...
            'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 10);
    end
    
    % Draw unidirectional edges between consecutive words
    for i = 1:num_words-1
        % Plot the edge as a line in 3D
        plot3(word_embeddings(i:i+1, 1), word_embeddings(i:i+1, 2), word_embeddings(i:i+1, 3), ...
            'Color', colors(s,:), 'LineWidth', 1.5);
        
        % Compute the direction vector for the arrow
        dx = word_embeddings(i+1,1) - word_embeddings(i,1);
        dy = word_embeddings(i+1,2) - word_embeddings(i,2);
        dz = word_embeddings(i+1,3) - word_embeddings(i,3);
        
        % Plot the black arrowhead using 'quiver3'
        quiver3(word_embeddings(i,1), word_embeddings(i,2), word_embeddings(i,3), ...
                dx, dy, dz, 0, 'Color', 'k', 'LineWidth', 1.5, 'MaxHeadSize', 2);
    end
end

% Set labels and title for 3D plot
xlabel('Dim 1');
ylabel('Dim 2');
zlabel('Dim 3');
title('3D Directed Word Graphs for Sentences in Corpus');
grid on;
hold off;
