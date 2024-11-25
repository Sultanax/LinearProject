% Corpus dictionary
corpus = [
    "i'm going to the park.",
    "which one are you going to",
    "is it the park near the deli",
    "yea the one near the deli",
    "the blue deli",
    "ohh i got confused",
    "i thought u were going to the one near the white deli",
    "noo no im going to the blue deli first and then the park"
];

% Preprocess corpus: Convert to lowercase, remove punctuation, and split into sentences
processed_corpus = lower(corpus);
processed_corpus = erasePunctuation(processed_corpus);

% Create a directed graph from the corpus
edges = {}; % Store edges as pairs of words
for s = 1:length(processed_corpus)
    words = split(processed_corpus{s}); % Split the sentence into words
    for i = 1:length(words)-1
        edges = [edges; words(i), words(i+1)]; % Add directed edge from current word to next word
    end
end

% Convert edges to a directed graph
G = digraph(edges(:, 1), edges(:, 2));

% Plot the directed graph
figure;
plot(G, 'Layout', 'force'); % Use 'force' layout for better visualization
title('Directed Word Graph');
grid on;

% Input words (user's current text)
input_words = ["confused"];

% Call the function to find the next word
predicted_word = find_next_word(G, input_words);

% Output the predicted word
fprintf('The next predicted word is: %s\n', predicted_word);

% Function to find the next word based on input sequence
function predicted_word = find_next_word(G, input_words)
    % Initialize current_word
    current_word = input_words(1);
    valid_path = true;
    
    % Traverse through the input words to check for a valid path
    for i = 2:length(input_words)
        if any(strcmp(G.Nodes.Name, current_word))
            % Find successors of the current word
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
    
    % If valid path, find the successor of the last word
    if valid_path && any(strcmp(G.Nodes.Name, current_word))
        succ = successors(G, current_word);
        if ~isempty(succ)
            predicted_word = succ{1}; % Take the first successor
        else
            predicted_word = '(no successor found)';
        end
    else
        predicted_word = '(invalid path)';
    end
end