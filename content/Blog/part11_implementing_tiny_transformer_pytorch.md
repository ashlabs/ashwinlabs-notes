# Implementing a Tiny Transformer in PyTorch

*Part 11 of the Attention & Transformers Deep Dive Series*

---

# Introduction

In the previous post, we conceptually assembled a miniature GPT architecture.

We walked through:
- Tokenization
- Embeddings
- Positional encoding
- Self-attention
- Transformer blocks
- Autoregressive generation

But conceptual understanding and implementation understanding are different levels of mastery.

This post bridges that gap.

We are going to walk through:
- How a tiny Transformer is implemented in PyTorch
- What each major component looks like in code
- How tensors flow through the network
- How attention becomes actual matrix operations

This is NOT production-grade GPT engineering.

The goal is:
- Architectural clarity
- Implementation intuition
- Understanding tensor flow

By the end, Transformer code should feel dramatically less intimidating.

---

# The Big Picture

A minimal GPT implementation usually contains:

```text
Tokenizer
    ↓
Embedding Layer
    ↓
Positional Embeddings
    ↓
Transformer Blocks
        ├── Attention
        ├── FFN
        ├── Residuals
        └── LayerNorm
    ↓
Output Projection
    ↓
Softmax
```

The implementation maps surprisingly cleanly to the architecture diagrams we studied earlier.

---

# Step 1 — Imports

Typical minimal setup:

```python
import torch
import torch.nn as nn
import torch.nn.functional as F
```

PyTorch provides:
- Tensors
- Automatic differentiation
- GPU acceleration
- Neural network modules

---

# Step 2 — Hyperparameters

A tiny GPT usually starts with small dimensions.

```python
vocab_size = 5000
embed_dim = 128
num_heads = 4
num_layers = 4
context_length = 128
```

These are intentionally tiny compared to frontier models.

For comparison:

| Model | Hidden Size |
|---|---:|
| Tiny GPT | 128 |
| GPT-2 | 768 |
| GPT-4-class systems | thousands |

---

# Step 3 — Token Embeddings

Embedding layer:

```python
self.token_embedding = nn.Embedding(
    vocab_size,
    embed_dim
)
```

This creates a learnable lookup table.

Input:

```python
[10, 25, 81]
```

Output:

```python
(3 × embed_dim)
```

tensor.

---

# Step 4 — Positional Embeddings

Transformers need sequence awareness.

Simplified learned positional embeddings:

```python
self.position_embedding = nn.Embedding(
    context_length,
    embed_dim
)
```

During forward pass:

```python
positions = torch.arange(seq_len)
```

Then:

```python
x = token_embeddings + position_embeddings
```

Now each token contains:
- Semantic meaning
- Positional information

simultaneously.

---

# Step 5 — Understanding Tensor Shapes

This is one of the most important Transformer skills.

Suppose:
- batch size = 32
- sequence length = 128
- embedding dim = 128

Tensor shape becomes:

```python
(32, 128, 128)
```

Meaning:

```text
(batch, sequence, embedding)
```

Understanding these dimensions is critical for debugging Transformer code.

---

# Step 6 — Q/K/V Projections

Attention begins by projecting embeddings into:
- Queries
- Keys
- Values

Typical implementation:

```python
self.query = nn.Linear(embed_dim, embed_dim)
self.key = nn.Linear(embed_dim, embed_dim)
self.value = nn.Linear(embed_dim, embed_dim)
```

Forward pass:

```python
Q = self.query(x)
K = self.key(x)
V = self.value(x)
```

Now every token has Q/K/V representations.

---

# Step 7 — Attention Scores

Attention similarity computation:

```python
scores = Q @ K.transpose(-2, -1)
```

This computes: $QK^T$

Result shape:

```python
(batch, seq_len, seq_len)
```

Each entry represents token-to-token attention relevance.

---

# Step 8 — Scaling

Transformer scaling step:

```python
scores = scores / (K.size(-1) ** 0.5)
```

Equivalent to:

$$
\frac{QK^T}{\sqrt{d_k}}
$$

This stabilizes:
- Gradients
- Softmax behavior
- Training dynamics

---

# Step 9 — Causal Masking

GPT must hide future tokens.

Typical mask:

```python
mask = torch.tril(torch.ones(seq_len, seq_len))
```

Example:

```text
1 0 0
1 1 0
1 1 1
```

Apply mask:

```python
scores = scores.masked_fill(mask == 0, float('-inf'))
```

Future positions now receive zero attention probability after softmax.

---

# Step 10 — Softmax

Attention probabilities:

```python
weights = F.softmax(scores, dim=-1)
```

Now attention weights sum to 1 for every token.

---

# Step 11 — Weighted Aggregation

Final attention output:

```python
attention_output = weights @ V
```

This retrieves weighted contextual information.

Now each token becomes context-aware.

---

# Step 12 — Multi-Head Attention

Instead of one attention mechanism:

Transformers split embeddings across multiple heads.

Typical reshape:

```python
x.view(batch, seq_len, num_heads, head_dim)
```

Then transpose:

```python
x.transpose(1, 2)
```

Result:

```python
(batch, heads, seq_len, head_dim)
```

Each head now learns different semantic relationships.

---

# Step 13 — Feed Forward Network

Typical FFN:

```python
self.ffn = nn.Sequential(
    nn.Linear(embed_dim, 4 * embed_dim),
    nn.GELU(),
    nn.Linear(4 * embed_dim, embed_dim)
)
```

Why expand first?

Because wider hidden spaces improve representational capacity.

---

# Step 14 — Residual Connections

Residuals stabilize deep learning.

Implementation:

```python
x = x + attention_output
```

and later:

```python
x = x + ffn_output
```

Residuals:
- Preserve information
- Improve gradient flow
- Enable deep scaling

---

# Step 15 — Layer Normalization

Typical implementation:

```python
self.ln = nn.LayerNorm(embed_dim)
```

Applied as:

```python
x = self.ln(x)
```

This stabilizes:
- Activations
- Gradients
- Optimization

---

# Step 16 — Transformer Block

A minimal Transformer block:

```python
class Block(nn.Module):

    def __init__(self):
        super().__init__()

        self.attn = Attention()
        self.ffn = FFN()
        self.ln1 = nn.LayerNorm(embed_dim)
        self.ln2 = nn.LayerNorm(embed_dim)

    def forward(self, x):

        x = x + self.attn(self.ln1(x))
        x = x + self.ffn(self.ln2(x))

        return x
```

This compact structure powers modern LLMs.

---

# Step 17 — Stacking Blocks

GPT stacks many Transformer blocks:

```python
self.blocks = nn.Sequential(
    *[Block() for _ in range(num_layers)]
)
```

Depth enables:
- Progressively richer representations
- Hierarchical abstraction building
- Complex reasoning patterns

---

# Step 18 — Final Output Layer

Eventually hidden states project into vocabulary logits.

Implementation:

```python
self.lm_head = nn.Linear(embed_dim, vocab_size)
```

Output shape:

```python
(batch, seq_len, vocab_size)
```

Each token position now predicts next-token probabilities.

---

# Step 19 — Cross Entropy Loss

Training objective:

```python
loss = F.cross_entropy(
    logits.view(-1, vocab_size),
    targets.view(-1)
)
```

This teaches next-token prediction.

---

# Step 20 — Generation Loop

Inference becomes iterative.

Simplified generation:

```python
for _ in range(max_tokens):

    logits = model(tokens)

    next_token = sample(logits)

    tokens.append(next_token)
```

This loop powers GPT-style generation.

---

# Why Tensor Shapes Matter So Much

Most Transformer debugging problems involve:
- Incorrect dimensions
- Reshaping mistakes
- Masking issues
- Head-splitting errors

Understanding tensor flow is one of the biggest implementation skills.

---

# What Production Systems Add

Real-world systems add:
- KV cache
- Flash Attention
- Mixed precision
- Distributed training
- Tensor parallelism
- Quantization
- Speculative decoding

Production Transformer engineering becomes significantly more complex.

---

# Why Building Tiny Transformers Is Valuable

Implementing even a tiny GPT teaches:
- Architecture flow
- Tensor reasoning
- Attention mechanics
- Optimization bottlenecks
- Inference behavior

This dramatically improves:
- Research comprehension
- Debugging ability
- Systems intuition

---

# One Important Realization

Modern LLMs ultimately reduce to:
- Matrix operations
- Probabilistic optimization
- Representation learning

The sophistication emerges from:
- Scale
- Optimization
- Training
- Systems engineering

not hidden symbolic magic.

---

# Suggested Next Steps

After implementing a tiny Transformer, strong next projects include:

## Practical Projects
- Character-level GPT
- Toy chatbot
- Attention visualization tool
- Mini RAG pipeline
- Prompt experimentation

## Advanced Topics
- LoRA fine-tuning
- Quantization
- Distributed training
- Inference serving
- Flash Attention internals

---

# Final Thought

One of the most powerful moments in learning Transformers is realizing:

> the architecture is elegant underneath the complexity.

The intimidating diagrams eventually collapse into:
- Embeddings
- Matrix multiplications
- Normalization
- Attention
- Probabilistic generation

repeated at massive scale. And that combination became the foundation of modern AI.

---

## Critical Mental Model

Transformer implementations are fundamentally:

> large-scale tensor manipulation systems performing iterative contextual representation refinement.
