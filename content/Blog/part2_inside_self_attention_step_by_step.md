# Inside Self-Attention Step-by-Step

*Part 2 of the Attention & Transformers Deep Dive Series*

---

# Introduction

In the previous post, we explored why attention mechanisms changed AI forever.

We looked at:
- Why older sequence models struggled
- Why long-range dependencies were difficult
- How attention introduced dynamic relevance weighting
- Why Transformers eventually dominated modern AI

Now we go deeper.

This is the post where we open the black box.

We are going to walk through:
- Embeddings
- Query, Key, and Value vectors
- Attention scores
- Dot products
- Softmax
- Attention matrices
- Contextual representations

step-by-step.

By the end of this article, the famous Transformer attention equation should stop looking mysterious and start feeling surprisingly elegant.

---

# The Core Problem Attention Solves

Consider this sentence:

> “The cat drank the milk because it was hungry.”

When the model reaches:

```text
it
```

it must determine:

> what does “it” refer to?

Humans naturally infer:

```text
it → cat
```

not:
```text
milk
```

Attention mechanisms help the model dynamically discover those relationships.

But how?

That is what we are going to unpack.

---

# Step 1: Tokens Become Numbers

Neural networks do not understand words directly.

Everything eventually becomes numbers.

The first stage is tokenization.

---

## Tokenization Example

Sentence:

```text
"The cat drank milk"
```

might become:

| Token | ID |
|---|---|
| the | 10 |
| cat | 25 |
| drank | 81 |
| milk | 42 |

Result:

```text
[10, 25, 81, 42]
```

At this stage:
- The model still has no semantic understanding
- These are simply integer identifiers

---

# Step 2: Embeddings

Now each token ID maps into a learned vector space.

The model maintains a giant embedding matrix:

$$
EmbeddingMatrix \in \mathbb{R}^{vocab\_size \times embedding\_dim}
$$

Example:

$$
50000 \times 768
$$

Each row corresponds to a token.

---

## Embedding Lookup

Suppose:

| Token | Embedding |
|---|---|
| cat | [0.2, 0.9, 0.1] |
| milk | [0.8, 0.1, 0.3] |

Initially:
- Embeddings are random
- They contain no semantic meaning

During training:
- Gradients reshape the embedding space
- Semantically related words drift closer together

Eventually:
- Cat and dog become nearby vectors
- Milk and water become related
- Airplane and banana drift far apart

This creates a learned semantic geometry.

---

# Static Embeddings vs Contextual Meaning

Traditional embeddings had a limitation.

The word:

```text
bank
```

always had the same representation.

But:

```text
river bank
```

and:

```text
bank account
```

mean completely different things.

This is where attention becomes powerful.

Attention creates:
- Context-aware representations
- Dynamically changing meaning

---

# Step 3: Query, Key, and Value Vectors

Embeddings alone are not enough.

The model needs separate representations for:
- Searching
- Describing
- Information transfer

So each embedding gets projected into:

| Vector    | Purpose                           |
| --------- | --------------------------------- |
| Query (Q) | What am I searching for?          |
| Key (K)   | What properties do I expose?      |
| Value (V) | What information do I contribute? |

---

# A Helpful Analogy

Think about a search engine.

| Attention Component | Search Engine Analogy  |
| ------------------- | ---------------------- |
| Query               | Search term            |
| Key                 | Indexed metadata       |
| Value               | Actual webpage content |

The Query asks:
> “What am I looking for?”

Keys describe:
> “What information do I contain?”

Values provide:
> “What information should actually be retrieved?”

---

# How Q/K/V Are Created

Each embedding gets multiplied by learned matrices.

$$
Q = XW_Q
$$

$$
K = XW_K
$$

$$
V = XW_V
$$

Where:
- $X$ = embedding matrix
- $W_Q$, $W_K$, $W_V$ are trainable parameter matrices

These matrices are:
- Initialized randomly
- Learned during training
- Shared across all tokens in a layer

---

# Important Insight

Embeddings answer:

> “What does this token generally mean?”

Q/K/V projections answer:

> “How should this token behave inside attention?”

Those are different problems.

---

# Step 4: Similarity Scoring

Now attention starts doing something interesting.

The model compares:
- Queries
against
- Keys

using dot products.

---

# Dot Product Intuition

Suppose:

$$
Q(it) = [2,1]
$$

and:

$$
K(cat) = [2,1]
$$

Dot product:

$$
(2\times2)+(1\times1)=5
$$

Now compare:

$$
K(milk) = [0,1]
$$

Dot product:

$$
(2\times0)+(1\times1)=1
$$

Higher score:
- Stronger semantic relevance
- Stronger contextual relationship

So:
- Cat becomes highly relevant to “it”
- Milk becomes less relevant

---

# Geometric Interpretation

Dot products measure vector alignment.

If vectors point in similar directions: scores become large
If vectors are unrelated: scores remain small

This is geometric similarity in high-dimensional semantic space.

---

# Step 5: Build the Attention Matrix

Now we scale this up.

Suppose sentence length is: $n$

Each token gets:
- A Query vector
- A Key vector
- A Value vector

Queries become matrix: $Q$

Keys become matrix: $K$

Values become matrix: $V$

---

# The Famous Operation

Attention computes:

$$
QK^T
$$

This creates the attention score matrix.

---

# Why Transpose K?

Suppose:

$$
Q \in \mathbb{R}^{4\times2}
$$

$$
K \in \mathbb{R}^{4\times2}
$$

To multiply, inner dimensions must match

So:

$$
K^T \in \mathbb{R}^{2\times4}
$$

Now multiplication works:

$$
(4\times2)(2\times4)=(4\times4)
$$

---

# What Does the Attention Matrix Mean?

If sequence length is 4:

```text
The cat drank milk
```

then attention matrix becomes:

$$
4 \times 4
$$

Each entry:

$$
[i,j]
$$

means:

> “How much token i attends to token j.”

---

# Example Intuition

| From / To | The | cat | drank | milk |
|---|---:|---:|---:|---:|
| The | 0.1 | 0.2 | 0.3 | 0.4 |
| cat | 0.0 | 0.7 | 0.2 | 0.1 |
| drank | 0.1 | 0.4 | 0.2 | 0.3 |
| milk | 0.0 | 0.1 | 0.2 | 0.7 |

Example:

$$
[1,3]
$$

means: “cat attends to milk with weight 0.1”

---

# Step 6: Scaling

Transformers divide scores by:

$$
\sqrt{d_k}
$$

where: $d_k$ = Key vector dimension

Full scaled score:

$$
\frac{QK^T}{\sqrt{d_k}}
$$

---

# Why Scaling Matters

Without scaling:
- Large dimensions create huge dot products
- Softmax becomes unstable
- Gradients become problematic

Scaling stabilizes training.

---

# Step 7: Softmax

Raw attention scores are not probabilities yet.

Softmax converts them into normalized weights.

Suppose scores:

```text
[5, 1, 6]
```

Softmax might produce:

```text
[0.42, 0.01, 0.57]
```

Meaning:

| Token | Attention Weight |
|---|---:|
| cat | 42% |
| milk | 1% |
| hungry | 57% |

Now the model knows where to focus.

---

# Why Softmax Is Important

Softmax ensures:
- All weights become positive
- All weights sum to 1

This creates probability-like attention distributions.

---

# Step 8: Weighted Value Aggregation

Now attention retrieves information.

Suppose:

| Token | Value |
|---|---|
| cat | [10,2] |
| milk | [1,8] |
| hungry | [9,1] |

Attention weights:

```text
[0.42, 0.01, 0.57]
```

Final output becomes:

$$
0.42[10,2]+0.01[1,8]+0.57[9,1]
$$

This creates a new contextual representation.

---

# This Is the Real Breakthrough

Originally: `milk` had one static embedding.

After attention: `milk in THIS sentence` gets a context-aware representation.

Meaning becomes dynamic.

---

# The Full Attention Equation

The famous Transformer equation:

$$
Attention(Q,K,V)=softmax\left(\frac{QK^T}{\sqrt{d_k}}\right)V
$$

looks intimidating at first.

But conceptually it is just:

1. Build semantic search queries
2. Compare semantic descriptors
3. Compute relevance
4. Retrieve weighted information
5. Build context-aware representations

That is attention.

---

# Why Self-Attention Was Revolutionary

Self-attention enabled:
- Direct token-to-token relationships
- Long-range context handling
- Dynamic contextual meaning
- Efficient parallelization

This became the foundation of:
- Transformers
- GPT
- BERT
- modern LLMs

---

# One Important Limitation

Self-attention itself has no understanding of word order.

The sentences:

```text
Dog bites man
```

and:

```text
Man bites dog
```

contain identical token sets.

So how do Transformers understand sequence structure?

That is where positional encoding enters the picture.

We’ll explore that in the next post.

---

# Final Thought

Attention mechanisms are fundamentally:

> learned semantic relevance systems.

Transformers repeatedly:
- search for relevant information
- retrieve useful context
- refine representations
- build contextual meaning

layer after layer.

That simple idea turned out to be one of the most important breakthroughs in modern AI.

---

# Next

-> [[part3_multi_head_attention_and_positional_encoding|Multi-head attention and positional encoding]]
