---
title: Understanding Word Embeddings - How Machines Learn the Meaning of Words
---
## Why Word Embeddings Changed NLP Forever

There was a time when Natural Language Processing systems treated words almost like serial numbers.

The sentence:

> "I love machine learning"

might become:

```python
[1045, 2293, 3698, 4083]
```

To a computer, those numbers did not contain meaning.

The number for “love” was not mathematically closer to “like” than it was to “banana.” Every word was simply an isolated symbol.

Word embeddings changed that.

Instead of representing words as disconnected IDs, embeddings represent words as points in a high-dimensional mathematical space.

Modern systems like transformers, large language models, recommendation systems, semantic search engines, RAG pipelines, and AI assistants all depend heavily on embeddings.

---

# The Problem With One-Hot Encoding

Suppose our vocabulary contains:

```text
["cat", "dog", "car", "truck", "pizza"]
```

One-hot encoding represents them like this:

```python
cat   -> [1,0,0,0,0]
dog   -> [0,1,0,0,0]
car   -> [0,0,1,0,0]
truck -> [0,0,0,1,0]
pizza -> [0,0,0,0,1]
```

The problem:

```text
Distance(cat, dog)
=
Distance(cat, pizza)
```

There is no semantic understanding.

---

# The Core Idea Behind Word Embeddings

Embeddings create dense learned vectors.

```python
cat -> [0.21, -0.44, 0.81, 0.17]
dog -> [0.25, -0.41, 0.79, 0.11]
```

Notice how similar the vectors are.

Words that appear in similar contexts end up with similar embeddings.

This is based on the famous NLP idea:

> “You shall know a word by the company it keeps.”

---

# Mapping Words Into Space

Imagine every word being placed on a giant multidimensional map.

Semantic similarity becomes geometric proximity.

Conceptually:

```text
          queen
             \
              \
king -------- man
  |
  |
woman
```

---

# How Embeddings Are Learned

Embeddings are learned through prediction tasks.

The system repeatedly tries to predict words from context.

Over time:

- semantically similar words move closer together
- relationships emerge naturally
- language structure gets encoded numerically

---

# Word2Vec

Word2Vec introduced two major architectures:

1. CBOW
2. Skip-Gram

---

# CBOW (Continuous Bag of Words)

CBOW predicts a missing word from surrounding words.

Example:

```text
The cat sat on the mat
```

Input:

```text
["The", "cat", "on", "the", "mat"]
```

Target:

```text
"sat"
```

The model repeatedly performs this prediction task during training.

---

# Skip-Gram

Skip-Gram does the reverse.

Input:

```text
"sat"
```

Predictions:

```text
"cat"
"on"
```

Again, repeated prediction tasks force embeddings to become meaningful.

---

# The Embedding Matrix

Suppose:

```text
Vocabulary size = 10,000
Embedding dimension = 300
```

The model creates:

```text
(10000 x 300)
```

Every row corresponds to one word vector.

Initially random.

Training updates these vectors over time.

---

# Embedding Lookup

Suppose:

```python
"cat" -> token ID 42
```

The embedding layer retrieves:

```python
embedding_matrix[42]
```

Which returns:

```python
[0.12, -0.88, 0.31, ...]
```

That becomes the learned representation for the word.

---

# PyTorch Example

Using PyTorch:

```python
import torch
import torch.nn as nn

embedding = nn.Embedding(10000, 300)

input_tokens = torch.tensor([42, 88, 120])

embedded_vectors = embedding(input_tokens)

print(embedded_vectors.shape)
```

Output:

```python
torch.Size([3, 300])
```

---

# Famous Embedding Analogy

One famous observation:

```text
king - man + woman ≈ queen
```

The model learned semantic relationships without explicit programming.

That was a major breakthrough in NLP.

---

# Cosine Similarity

Cosine similarity measures how close embeddings are.

$$
\cos(\theta)=\frac{A \cdot B}{||A|| ||B||}
$$

Where:

- A and B are embedding vectors
- numerator = dot product
- denominator = normalization

Values closer to 1 mean higher semantic similarity.

---

# Static vs Contextual Embeddings

Older systems:

- Word2Vec
- GloVe
- FastText

used static embeddings.

Meaning:

```text
"apple"
```

always had the same vector.

But modern transformers changed that.

---

# Contextual Embeddings

Modern models like BERT and GPT generate embeddings based on context.

Example:

```text
I ate an apple
```

vs

```text
Apple released a new MacBook
```

The embedding changes depending on surrounding words.

This was a massive leap forward.

---

# Embeddings in Modern AI

Embeddings power:

- semantic search
- RAG systems
- recommendation engines
- fraud detection
- document similarity
- clustering
- retrieval systems

Most modern AI systems depend heavily on embeddings.

---

# Embeddings in RAG

In Retrieval-Augmented Generation systems:

1. documents are converted into embeddings
2. user queries are embedded
3. vector similarity retrieves relevant chunks

This is foundational to modern AI assistants.

---

# Embedding Pipeline in Transformers

A simplified transformer pipeline:

```text
Text
  ↓
Tokenizer
  ↓
Token IDs
  ↓
Embedding Layer
  ↓
Positional Encoding
  ↓
Transformer Layers
  ↓
Predictions
```

Without embeddings, transformers cannot operate.

---

# Positional Encoding

Embeddings alone do not contain word order.

Example:

```text
Dog bites man
```

vs

```text
Man bites dog
```

Positional encoding helps transformers understand sequence order.

---

# Challenges With Embeddings

## Bias

Embeddings can learn societal biases from training data.

## Domain Shift

General embeddings may not work well in medical or legal domains.

## Memory Cost

Large embedding matrices consume substantial GPU memory.

---

# Why This Matters

If you build:

- RAG systems
- semantic search
- recommendation engines
- AI assistants
- retrieval systems

then embeddings are foundational knowledge.

Many production AI systems are essentially:

> “Embedding pipelines with orchestration around them.”

---

# Mental Model

Think of embeddings as:

> “Compressed representations of meaning.”

Language becomes geometry.

Distance becomes meaning.

Similarity becomes proximity.

That idea powers much of modern AI.

---

# Interview Cram

## Key Concepts

- One-hot encoding creates sparse vectors
- Embeddings create dense semantic vectors
- Similar words appear close together in vector space
- Word2Vec introduced CBOW and Skip-Gram
- Modern transformers use contextual embeddings
- Cosine similarity measures vector similarity

## Important Models

- Word2Vec
- GloVe
- FastText
- BERT
- GPT

## Common Interview Question

### Why are embeddings better than one-hot encoding?

Because embeddings:

- reduce dimensionality
- capture semantic similarity
- generalize better
- enable neural learning
