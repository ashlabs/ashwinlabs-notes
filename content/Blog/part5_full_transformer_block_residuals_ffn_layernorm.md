# The Full Transformer Block: Residuals, FFNs, and LayerNorm

*Part 5 of the Attention & Transformers Deep Dive Series*

---

# Introduction

At this point in the series, we understand:
- Embeddings
- Self-attention
- Query, Key, and Value vectors
- Multi-head attention
- Positional encoding
- Causal masking
- Autoregressive generation

But there is still an important misconception we need to correct.

A lot of people think:

> “Transformers are just attention.”

They are not.

Attention is only one component inside a much larger architecture.

Real Transformers also rely heavily on:
- Feed Forward Networks (FFNs)
- Residual Connections
- Layer Normalization

Without these components:
- Deep Transformers would train poorly
- Gradients would destabilize
- Information would degrade
- Large-scale models would become impractical

This post explains the hidden infrastructure that makes Transformers stable, scalable, and trainable at massive depth.

---

# The High-Level Transformer Block

A Transformer block roughly looks like this:

```text
Input
  ↓
Multi-Head Attention
  ↓
Add & Normalize
  ↓
Feed Forward Network
  ↓
Add & Normalize
  ↓
Output
```

This block gets repeated:
- 12 times
- 24 times
- 48 times
- sometimes over 100 times

depending on model size.

Modern LLMs are essentially **giant stacks of Transformer blocks**.

---

# Why Attention Alone Is Not Enough

Attention is excellent at:

> moving information between tokens.

Examples:
- Pronoun resolution
- Long-range dependencies
- Semantic relationships
- Contextual understanding

But attention itself is mostly:
- Communication
- Routing
- Relevance weighting

It is NOT especially good at:
- Deep nonlinear feature transformation
- Representation refinement
- Abstraction building

That is where FFNs enter the picture.

---

# Feed Forward Networks (FFNs)

After attention, each token independently passes through a neural network.

Typical FFN equation:

$$
FFN(x)=W_2\sigma(W_1x+b_1)+b_2
$$

At first glance this looks intimidating.

Conceptually it is simply:

```text
Linear Layer
    ↓
Activation Function
    ↓
Linear Layer
```

That’s it.

---

# Important Distinction

Attention exchanges information ACROSS tokens

FFNs process EACH token independently

This distinction is critical.

---

# Intuition: Team Discussion vs Individual Thinking

A useful analogy:

Attention is like a team discussion

FFN is like each individual privately processing the discussion afterward.

The token:
1. Gathers contextual information
2. Internally transforms and refines it

---

# Why FFNs Are Surprisingly Important

One of the most surprising facts about Transformers:

> FFNs often contain MOST of the parameters.

Not attention.

This surprises many people because attention receives most of the public attention.

But FFNs are where enormous representational capacity lives.

---

# Typical FFN Dimensions

Suppose hidden size:

$$
768
$$

FFN may expand:

$$
768 \rightarrow 3072 \rightarrow 768
$$

Why expand first?

Because larger intermediate spaces:
- Increase expressive power
- Allow richer feature interactions
- Improve nonlinear transformation capacity

---

# Why Nonlinearity Matters

Without activation functions:

```text
linear → linear → linear
```

collapses into one giant linear transformation.

No deep representational power emerges.

Activation functions introduce:
- Nonlinear reasoning capacity
- Hierarchical representation learning
- Complex feature interactions

Common activations:
- ReLU
- GELU
- SwiGLU

Modern LLMs heavily rely on these nonlinearities.

---

# Residual Connections

Now we hit one of the most important deep learning innovations.

---

# The Deep Network Problem

As networks become deeper:
- Gradients weaken
- Information degrades
- Optimization becomes unstable

Very deep models become difficult to train.

This problem nearly killed many early deep architectures.

---

# Residual Solution

Instead of:

$$
output = layer(x)
$$

Transformers use:

$$
output = x + layer(x)
$$

This is called **a residual connection** or **skip connection**

---

# Visual Intuition

Instead of forcing information through every transformation:

```text
x → layer → output
```

Residuals allow:

```text
x ─────────────→ +
      ↓
    layer(x)
```

The original information bypasses the layer.

---

# Why This Is Powerful

Residuals dramatically improve:
- Gradient flow
- Optimization stability
- Information preservation
- Deep scaling

Without residuals **training 100-layer Transformers would be extremely difficult**.

---

# Important Mental Shift

Residual layers do not need to completely rewrite representations.

They only need to learn:

> “What should I add or refine?”

This is much easier.

---

# Residuals Preserve Earlier Information

Even if:
- One layer performs poorly
- Gradients become noisy

the original signal can still propagate.

This makes deep learning much more stable.

---

# Layer Normalization

Another critical stabilization mechanism.

---

# The Activation Drift Problem

During training:
- Activations can grow unpredictably
- Distributions shift between layers
- Optimization becomes unstable

This creates difficult training dynamics.

---

# LayerNorm Solution

LayerNorm normalizes activations.

Conceptually:

$$
\frac{x-\mu}{\sigma}
$$

where:
$\mu$ = mean
$\sigma$ = standard deviation

The result:
- Activations become more stable
- Gradients behave more predictably
- Training becomes smoother

---

# Why This Matters

LayerNorm helps:
- Prevent exploding activations
- Stabilize optimization
- Enable deep Transformer stacks

Without normalization training large Transformers becomes much harder.

---

# Why Transformers Use LayerNorm Instead of BatchNorm

CNNs frequently use Batch Normalization

Transformers usually use Layer Normalization

Why?

Because:
- Sequence processing behaves differently
- Batch statistics are less reliable for language modeling
- Token-level normalization works better

---

# Putting the Full Transformer Block Together Stp-by-Step

Now let’s assemble everything.
## Step 1: Input Representations

Tokens become:
- Embeddings
- Plus positional encodings
## Step 2: Multi-Head Attention

The model:
- Exchanges information between tokens
- Computes relevance
- Builds contextual meaning
## Step 3: Residual Connection

The model adds:

$$
X + Attention(X)
$$

This preserves original information.
## Step 4: Layer Normalization

Activations become stabilized.
## Step 5: Feed Forward Network

Each token independently:
- Transforms
- Refines
- Expands representations
## Step 6: Another Residual

The model adds:

$$
X + FFN(X)
$$

Again preserving stability.
## Step 7: Another LayerNorm

Activations are stabilized again.

---
# Why Transformers Can Become So Deep

Because of:
- Residuals
- Normalization
- Modular block design

Transformers scale remarkably well.

This was one of the biggest breakthroughs in modern deep learning.

---

# What Different Layers Learn

As Transformer depth increases:

Early layers often learn:
- Local syntax
- Grammar
- Nearby relationships

Middle layers often learn:
- Phrase structure
- Semantic interactions
- Entity relationships

Later layers often learn:
- Abstract reasoning
- Long-range dependencies
- High-level representations

Meaning becomes progressively richer through the stack.

---

# Attention Is Not “Intelligence”

This is an important realization.

Attention alone is not:
- Reasoning
- Planning
- Intelligence

The power emerges from:
- Repeated refinement
- Layered abstraction building
- Nonlinear transformation
- Iterative contextual processing

Transformers become powerful because **many layers repeatedly refine representations**.

---

# Encoder vs Decoder Transformers

At this point we can finally understand the major Transformer families.

---

# Encoder-Only Models (BERT)

Encoder models use bidirectional attention

Tokens can see both left and right context

Excellent for:
- Embeddings
- Semantic search
- Classification
- Retrieval systems

---

# Decoder-Only Models (GPT)

Decoder models use causal masked attention

Tokens can only see previous tokens

Excellent for:
- Generation
- Conversation
- Coding
- Autoregressive tasks

---

# Encoder-Decoder Models (T5)

Encoder-decoder architectures:
- Deeply understand input
- Then generate output

Excellent for:
- Translation
- Summarization
- Seq2seq tasks

---

# Why GPT-Style Models Became Dominant

Decoder-only architectures:
- Scaled extraordinarily well
- Generalized broadly
- Simplified training pipelines
- Handled many tasks using one objective

This led to:
- GPT-3
- GPT-4
- modern frontier chat systems

---

# The Bigger Picture

A Transformer is not one attention mechanism

It is a deep iterative representation refinement system

built from:
- Attention
- Nonlinear processing
- Residual learning
- Normalization
- Repeated abstraction building

That combination became extraordinarily powerful at scale.

---

# One Major Piece Still Missing

So far we understand:
- Architecture
- Generation
- Transformer internals

But we still have not discussed:

> how these giant models are actually trained.

How do randomly initialized Transformers become:
- Conversational assistants
- Coding copilots
- Reasoning systems
- AI chatbots

That is where:
- Pre-training
- Fine-tuning
- RLHF
- Alignment

enter the picture.

We’ll unpack that in the next post.

---

# Final Thought

Attention may have sparked the Transformer revolution.

But:
- Residuals
- FFNs
- Normalization

are what made deep scalable Transformers practical.

Without them modern LLMs would likely not exist.

---

# Next

--> [[part6_how_llms_are_actually_trained| How LLMs are actually trained]]

