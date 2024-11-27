corpus = readtable('corpus.csv');
text_column = corpus.text;
if ~isstring(text_column)
    text_column = string(text_column);
end
processed_corpus = lower(text_column);
processed_corpus = erasePunctuation(processed_corpus);

edges = {};
edge_counts = containers.Map('KeyType', 'char', 'ValueType', 'double');

for s = 1:length(processed_corpus)
    words = split(processed_corpus{s});
    for i = 1:length(words)-1
        % directed edge from current word to next word
        edge = strcat(words{i}, '->', words{i+1});
        edges = [edges; words(i), words(i+1)];
        % occurrences of the edge
        if isKey(edge_counts, edge)
            edge_counts(edge) = edge_counts(edge) + 1;
        else
            edge_counts(edge) = 1;
        end
    end
end

% save directed graph
G = digraph(edges(:, 1), edges(:, 2));
save('precomputations/directed_graph.mat', 'G', 'edge_counts');
