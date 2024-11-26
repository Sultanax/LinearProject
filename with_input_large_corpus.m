corpus = readtable('corpus.csv');
text_column = corpus.text; 

% Preprocess corpus
if ~isstring(text_column)
    text_column = string(text_column);  % Convert to string array
end

processed_corpus = lower(text_column);
processed_corpus = erasePunctuation(processed_corpus);

% directed graph
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

G = digraph(edges(:, 1), edges(:, 2));

figure;
plot(G, 'Layout', 'force');
title('Directed Word Graph');
grid on;

input_words = ["i", "am", "worried"];

valid_path = true;
current_word = input_words(1);

for i = 2:length(input_words)
    if any(strcmp(G.Nodes.Name, current_word))
        % successors of the current word
        succ = successors(G, current_word);
        next_word = input_words(i);
        if ~isempty(succ) && any(strcmp(succ, next_word))
            current_word = next_word;
        else
            valid_path = false;
            break;
        end
    else
        valid_path = false;
        break;
    end
end

if valid_path && any(strcmp(G.Nodes.Name, current_word))
    successors_list = successors(G, current_word);
    if isempty(successors_list)
        fprintf('No successors found for the word: %s\n', current_word);
    else
        % probabilities for each successor
        total_count = 0;
        successor_counts = containers.Map('KeyType', 'char', 'ValueType', 'double');
        
        for i = 1:length(successors_list)
            successor_word = successors_list{i};
            edge = strcat(current_word, '->', successor_word);
            if isKey(edge_counts, edge)
                successor_counts(successor_word) = edge_counts(edge);
                total_count = total_count + edge_counts(edge);
            end
        end
        
        max_probability = 0;
        predicted_words = {};
        fprintf('Probabilities of successors for the word "%s":\n', current_word);
        successor_keys = keys(successor_counts);
        for i = 1:length(successor_keys)
            word = successor_keys{i};
            probability = (successor_counts(word) / total_count) * 100;
            fprintf('{ %s } : %.2f %%\n', word, probability);
            
            if probability > max_probability
                max_probability = probability;
                predicted_words = {word}; % Start new list
            elseif probability == max_probability
                predicted_words{end+1} = word; % Add to list
            end
        end
        
        if length(predicted_words) == 1
            fprintf('The next predicted word is: %s\n', predicted_words{1});
        else
            fprintf('The next predicted words (tie): %s\n', strjoin(predicted_words, ', '));
        end
    end
else
    fprintf('The input sequence "%s" is not valid in the graph.\n', strjoin(input_words, ' '));
end
