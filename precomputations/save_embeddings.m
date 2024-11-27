corpus = readtable('corpus.csv');
emb = fastTextWordEmbedding;
text_column = corpus.text;

if ~isstring(text_column)
    text_column = string(text_column);  
end

processed_corpus = lower(text_column);
processed_corpus = erasePunctuation(processed_corpus);

all_words = unique(split(join(processed_corpus)));
all_words = all_words(~ismissing(all_words));

word_embeddings = zeros(length(all_words), emb.Dimension);
for i = 1:length(all_words)
    word_embeddings(i, :) = word2vec(emb, all_words{i});
end

emb_table = table(all_words, word_embeddings);
writetable(emb_table, 'corpus_embeddings.csv');
