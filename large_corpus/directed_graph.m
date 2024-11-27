load('../precomputations/directed_graph.mat', 'G', 'edge_counts');

input_words = ["is"];

valid_path = true;
current_word = input_words(1);

for i = 2:length(input_words)
    if any(strcmp(G.Nodes.Name, current_word))
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
                predicted_words = {word};
            elseif probability == max_probability
                predicted_words{end+1} = word;
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
