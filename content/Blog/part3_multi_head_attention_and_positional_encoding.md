# Multi-Head Attention and Positional Encoding

*Part 3 of the Attention & Transformers Deep Dive Series*

---

# Introduction

In the previous post, we unpacked the mechanics of self-attention step-by-step.

We explored:
- Embeddings
- Query, Key, and Value vectors
- Dot products
- Attention matrices
- Softmax weighting
- Contextual representations

By the end, one major question remained:

> If attention compares all tokens simultaneously, how does the model understand word order?

And there was another equally important question:

> Can a single attention mechanism really capture every kind of relationship in language?

The answer to both questions led to two of the most important Transformer innovations:

- Multi-Head Attention
- Positional Encoding

These ideas dramatically increased the expressive power of Transformers and became foundational to modern LLMs.

---

# The Limitation of Single-Head Attention

Suppose we have this sentence:

> “The animal didn’t cross the street because it was tired.”

When processing: `it` the model may need to simultaneously understand:
- Pronoun resolution
- Sentence grammar
- Semantic meaning
- Long-range context
- Sentence structure

That is a lot for one attention mechanism to handle.

A single attention head has limited representational capacity.

---

# The Big Idea Behind Multi-Head Attention

Instead of using: `one attention mechanism`

Transformers use: `many attention mechanisms in parallel`.

Each head learns:
- Different Q/K/V projections
- Different relevance patterns
- Different semantic relationships

---

# Intuition: A Team of Specialists

Single-head attention is like: `one analyst reviewing a document`
Multi-head attention is like: `a team of specialists reviewing it simultaneously`.

One head may focus on `grammar`
Another may focus on `entity relationships`
Another may focus on `long-range dependencies`
Another may focus on `semantic similarity`

---

# A Concrete Example

Consider:

> “The bank near the river flooded after the storm.”

Different attention heads may interpret `bank` differently.

---

## Head 1: Geography Context

Strongly attends to:

```text
bank ↔ river
```

This head helps identify `river bank meaning`

---

## Head 2: Structural Grammar

Tracks:
- Sentence structure
- Subject relationships
- Verb dependencies

---

## Head 3: Event Relationships

Focuses on:
- Flooded
- Storm
- Causal structure

---

# Nobody Explicitly Programs This

This is extremely important.

Researchers do NOT manually assign:
- “Head 1 handles pronouns”
- “Head 2 handles grammar”

These behaviors emerge naturally during training.

The model discovers:
- Specialized relationship patterns
- Because specialization improves prediction performance.

---

# How Multi-Head Attention Works

Instead of one set of matrices:

$$
\begin{bmatrix}
W_Q, W_K, W_V
\end{bmatrix}
$$

Transformers use multiple sets.

Example:

$$
\begin{bmatrix}
W_Q^1, W_K^1, W_V^1 \\
\end{bmatrix}
$$

$$
\begin{bmatrix}
W_Q^2, W_K^2, W_V^2
\end{bmatrix}
$$

$$
\begin{bmatrix}
W_Q^3, W_K^3, W_V^3
\end{bmatrix}
$$

and so on.

Each head learns different projections.

---

# Typical Dimensions

Suppose:
- Embedding size = 768
- Number of heads = 12

Each head often gets:

$$
768 / 12 = 64
$$

dimensions.

So:
- Every head operates in its own 64-dimensional attention space
- All heads run in parallel

---

# Why Split the Dimensions?

This allows:
- computational efficiency
- parallel specialization
- richer representational diversity

Instead of:
- one massive semantic search space

the model learns:
- multiple smaller semantic perspectives.

---

# The Full Flow

Each head independently performs:

1. Q/K/V projection
2. Attention score computation
3. Softmax weighting
4. Weighted value aggregation

Then all head outputs get concatenated together.

---

# Concatenation Step

Suppose:
- 12 heads
- Each produces 64-dimensional output

Concatenation creates:

$$
12 \times 64 = 768
$$

Now we are back to the original hidden size.

---

# Final Output Projection

After concatenation, Transformers apply another learned matrix:

$$
W_O
$$

This mixes information across heads.

The model now combines:
- Grammar
- Semantics
- Structure
- Entity relationships
- Long-range dependencies

into one refined contextual representation.

---

# Visualizing the Architecture

High-level flow:

```text
Input Embeddings
        ↓
Multiple Q/K/V Projections
        ↓
Parallel Attention Heads
        ↓
Concatenate Outputs
        ↓
Output Projection
```

---

# Why Multi-Head Attention Was So Powerful

Different heads can simultaneously capture:
- Syntax
- Semantics
- Topic structure
- Pronoun tracking
- Code indentation
- Bracket matching
- Citation linking

Researchers later visualized trained heads and found remarkable specialization patterns emerging automatically.

This was one of the most fascinating discoveries in Transformer research.

---

# The Next Big Problem

At this point, attention can:
- Compare tokens
- Compute relevance
- Build contextual meaning

But there is still a major issue. Attention itself has no inherent understanding of sequence order.

---

# Why Word Order Matters

These two sentences contain identical words:

```text
Dog bites man
```

```text
Man bites dog
```

Without order information, meaning collapses.

Self-attention alone treats tokens more like a set than an ordered sequence.

Transformers needed a way to inject positional information.

---

# Positional Encoding

Transformers solve this by adding position information directly into token representations.

Instead of:

$$
Input = WordEmbedding
$$

Transformers use:

$$
Input = WordEmbedding + PositionalEncoding
$$

Now each token contains:
- Semantic meaning
- Positional meaning
simultaneously.

---

# Simple Intuition Example

Suppose:

```text
cat
```

has embedding:

$$
[0.8,0.2]
$$

Position 0 might add:

$$
[0.1,0.0]
$$

Position 1 might add:

$$
[0.0,0.1]
$$

Now:

```text
cat at position 0
```

becomes:

$$
[0.9,0.2]
$$

while:

```text
cat at position 1
```

becomes:

$$
[0.8,0.3]
$$

Same word.
Different contextual identity.

---

# Original Transformer Positional Encoding

The original Transformer paper used sinusoidal positional encoding.

Formulas:

For even dimensions:

$$
PE(pos,2i)=\sin\left(\frac{pos}{10000^{2i/d}}\right)
$$

For odd dimensions:

$$
PE(pos,2i+1)=\cos\left(\frac{pos}{10000^{2i/d}}\right)
$$

At first glance, this looks intimidating.

But conceptually:
- Different dimensions oscillate at different frequencies
- Every position gets a unique signature
- Nearby positions remain mathematically related

---

# Why Sinusoids Were Clever

Sinusoidal encodings allow the model to infer:
- Relative distance
- Nearby positions
- Ordering relationships

without explicitly memorizing every sequence position.

This gave Transformers strong generalization properties.

---

# Visual Intuition

Imagine each position receives a unique barcode.

Position 1:

```text
[0.1,0.9,0.2,0.8]
```

Position 2:

```text
[0.2,0.8,0.3,0.7]
```

Position 100:

```text
[0.9,0.1,0.6,0.4]
```

These patterns encode location information continuously.

---

# Modern Positional Encoding Approaches

Modern LLMs often use:
- Learned positional embeddings
- RoPE (Rotary Position Embeddings)
- Relative positional biases

especially for:
- Longer context windows
- Improved extrapolation
- Better long-range reasoning

---

# Why Positional Encoding Matters So Much

Without positional encoding:
- Transformers behave closer to bag-of-words systems

With positional encoding:
- Sentence structure emerges
- Ordering relationships matter
- Local dependencies become understandable

This is essential for:
- Grammar
- Reasoning
- Coding
- Structured text understanding

---

# Putting Everything Together

At this point, a Transformer can:

1. Convert tokens into embeddings
2. Inject positional information
3. Project into Q/K/V spaces
4. Compute multiple attention perspectives
5. Aggregate contextual information
6. Build rich contextual representations

This combination became one of the most powerful representation-learning systems ever created.

---

# Why This Changed AI

Multi-head attention and positional encoding dramatically improved:
- contextual understanding
- long-range dependency handling
- representational richness
- training scalability

And because Transformers parallelized efficiently:
- researchers could scale them aggressively

That scaling eventually led to:
- GPT
- BERT
- Claude
- Gemini
- modern frontier models

---

# One Important Limitation Still Remains

So far, attention allows:
- every token to see every other token.

But GPT-style language generation has a special requirement:

> the model must NOT look into the future.

How do Transformers generate text one token at a time without cheating?

That is where masked attention enters the picture.

We’ll unpack that in the next post.

---

# Final Thought

Multi-head attention transformed attention from:
- a single relevance mechanism

into:
- a collection of specialized semantic search systems operating simultaneously.

Positional encoding then gave those systems:
- Sequence awareness
- Locality
- Structural understanding

Together, they formed the foundation of modern Transformer intelligence.

---

# Next
--> [[part4_how_gpt_actually_generates_text| How GPT actually generates text]]
