corpus = readtable('../corpus.csv');
emb = fastTextWordEmbedding;
text_column = corpus.text; 

if ~isstring(text_column)
    text_column = string(text_column);
end

processed_corpus = lower(text_column);
processed_corpus = erasePunctuation(processed_corpus);

figure;
hold on;
view(3);

colors = lines(length(processed_corpus));

for s = 1:length(processed_corpus)
    words = split(processed_corpus{s});
    num_words = length(words);
    word_embeddings = zeros(num_words, 3); % 3 dimensions
    
    for i = 1:num_words
        embedding = word2vec(emb, words{i});
        word_embeddings(i, :) = embedding(1:3);
    end

    scatter3(word_embeddings(:,1), word_embeddings(:,2), word_embeddings(:,3), 50, colors(s,:), 'filled');
    for i = 1:num_words
        text(word_embeddings(i,1), word_embeddings(i,2), word_embeddings(i,3), words{i}, ...
            'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 10);
    end

    for i = 1:num_words-1
        plot3(word_embeddings(i:i+1, 1), word_embeddings(i:i+1, 2), word_embeddings(i:i+1, 3), ...
            'Color', colors(s,:), 'LineWidth', 1.5);
        dx = word_embeddings(i+1,1) - word_embeddings(i,1);
        dy = word_embeddings(i+1,2) - word_embeddings(i,2);
        dz = word_embeddings(i+1,3) - word_embeddings(i,3);
        quiver3(word_embeddings(i,1), word_embeddings(i,2), word_embeddings(i,3), ...
                dx, dy, dz, 0, 'Color', 'k', 'LineWidth', 1.5, 'MaxHeadSize', 2);
    end
end

xlabel('Dim 1');
ylabel('Dim 2');
zlabel('Dim 3');
title('3D Directed Word Graphs for Sentences in Corpus');
grid on;
hold off;
