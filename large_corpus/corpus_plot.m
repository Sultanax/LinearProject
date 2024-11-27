corpus = readtable('corpus.csv');
emb = fastTextWordEmbedding;
text_column = corpus.text; 

if ~isstring(text_column)
    text_column = string(text_column);
end
processed_corpus = lower(text_column);
processed_corpus = erasePunctuation(processed_corpus);

figure;
hold on;

colors = lines(length(processed_corpus));

for s = 1:length(processed_corpus)
    words = split(processed_corpus{s});
    num_words = length(words);
    word_embeddings = zeros(num_words, 2);
    
    for i = 1:num_words
        embedding = word2vec(emb, words{i});
        word_embeddings(i, :) = embedding(1:2);
    end
    scatter(word_embeddings(:,1), word_embeddings(:,2), 50, colors(s,:), 'filled');

    for i = 1:num_words
        text(word_embeddings(i,1), word_embeddings(i,2), words{i}, ...
            'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 10);
    end
    for i = 1:num_words-1
        quiver(word_embeddings(i,1), word_embeddings(i,2), ...
               word_embeddings(i+1,1)-word_embeddings(i,1), ...
               word_embeddings(i+1,2)-word_embeddings(i,2), ...
               0, 'Color', colors(s,:), 'LineWidth', 1.5, 'MaxHeadSize', 0.2);
    end
end

xlabel('Dim 1');
ylabel('Dim 2');
title('Directed Word Graphs for Sentences in Corpus');
grid on;
hold off;
