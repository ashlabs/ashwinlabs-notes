# How GPT Actually Generates Text

*Part 4 of the Attention & Transformers Deep Dive Series*

---

# Introduction

At this point in the series, we understand:
- Embeddings
- Self-attention
- Query, Key, and Value vectors
- Multi-head attention
- Positional encoding

But we still have not answered one of the biggest practical questions:

> How does GPT actually generate text?

When you type:

```text
Explain quantum computing
```

how does the model continue producing:
- Coherent paragraphs
- Code
- Reasoning
- Structured responses

one token at a time?

And perhaps even more importantly:

> How does the model avoid cheating during training?

That is where:
- Masked attention
- Autoregressive generation
- Inference sampling

enter the picture.

This post explains the mechanics behind modern GPT-style text generation.

---

# The Core Challenge

Regular self-attention allows every token to attend to every other token.

That works well for understanding text.

But generation introduces a problem.

Suppose the model is training on:

```text
"The cat sat on the mat"
```

When predicting:

```text
mat
```

the model must NOT already see:

```text
mat
```

Otherwise the task becomes trivial.

The model would simply copy the answer.

---

# GPT’s Solution: Causal Masking

GPT uses `masked self-attention` also called `causal attention`

The rule is simple:

> tokens can only attend to previous tokens.

Future tokens are hidden.

---

# Visual Intuition

Suppose sequence:

```text
The cat sat
```

Attention permissions become:

| Token | Can Attend To |
|---|---|
| The | The |
| cat | The, cat |
| sat | The, cat, sat |

Future positions remain inaccessible.

---

# Attention Matrix View

Normal bidirectional attention:

```text
✓ ✓ ✓
✓ ✓ ✓
✓ ✓ ✓
```

Causal masked attention:

```text
✓ ✗ ✗
✓ ✓ ✗
✓ ✓ ✓
```

This creates an upper-triangular masking structure.

---

# Why This Matters

Causal masking transforms the Transformer into an autoregressive model

Meaning:

> predict the next token from previous tokens.

This became the foundation of:
- GPT
- Modern chat models
- Coding copilots
- Text generation systems

---

# How Masking Works Internally

Before softmax forbidden positions receive huge negative values.

Conceptually $-\infty$

Suppose raw attention scores:

```text
[2,5,1]
```

If third position is forbidden:

```text
[2,5,-\infty]
```

After softmax:

```text
[0.05,0.95,0]
```

The forbidden token receives:
- Zero probability
- Zero attention weight

This is how the model avoids peeking into the future.

---

# GPT Training Objective

The training task becomes:

> predict the next token

repeated billions or trillions of times.

---

# Example

Input: `"The cat sat on the"`
Target: `mat`

Then:

Input: `"The cat sat on the mat"`
Target: `and`

and so on.

---

# A Huge Transformer Advantage

Even though generation is sequential, training remains highly parallelizable.

This was one of the biggest Transformer breakthroughs.

---

# Why Parallel Training Matters

RNNs process sequences step-by-step.

Transformers can process entire sequences simultaneously during training because masking preserves causality mathematically.

This dramatically improved:
- GPU utilization
- Scaling efficiency
- Training throughput

And that enabled internet-scale language modeling.

---

# What GPT Is Really Learning

GPT is fundamentally learning:

> probability distributions over next tokens.

At every step, the model predicts a probability distribution across the vocabulary.

Example:

| Token | Probability |
|---|---:|
| mat | 0.62 |
| floor | 0.18 |
| chair | 0.05 |
| moon | 0.001 |

The model does not directly generate text.

It generates probability distributions

Text emerges through sampling.

---

# Generation Happens Token-by-Token

Suppose prompt: `"The cat"`

The model predicts:

| Token | Probability |
| ----- | ----------: |
| sat   |        0.55 |
| ran   |        0.20 |
| slept |        0.10 |

Suppose: `sat` gets selected.

Now prompt becomes:

```text
"The cat sat"
```

Then the process repeats.

This loop continues:
- One token at a time
- Until stopping conditions occur.

---

# Why GPT Feels Intelligent

This is one of the most misunderstood aspects of LLMs.

GPT is not:
- Explicitly reasoning symbolically
- Searching a database internally
- Executing logical proofs

Instead sophisticated reasoning patterns emerge from large-scale next-token prediction.

This distinction matters enormously.

---

# Temperature: Controlling Randomness

One of the most important inference settings is temperature.

Temperature controls:
- Randomness
- Creativity
- Confidence

---

# Low Temperature

Example:

```text
T = 0.2
```

Effects:
- More deterministic
- Safer
- More factual
- Less creative

Probability distributions become sharper.

---

# High Temperature

Example:

```text
T = 1.5
```

Effects:
- More exploratory
- More creative
- More surprising
- Higher hallucination risk

Probability distributions become flatter.

---

# Intuition Example

Original probabilities:

| Token | Probability |
|---|---:|
| mat | 0.60 |
| floor | 0.25 |
| moon | 0.01 |

Low temperature:

| Token | Probability |
|---|---:|
| mat | 0.90 |
| floor | 0.09 |
| moon | ~0 |

High temperature:

| Token | Probability |
|---|---:|
| mat | 0.40 |
| floor | 0.30 |
| moon | 0.10 |

---

# Why Temperature Matters

Low temperature is useful for:
- Coding
- Structured outputs
- Factual tasks
- Deterministic workflows

High temperature is useful for:
- Brainstorming
- Storytelling
- Creativity
- Divergent exploration

---

# Top-k Sampling

Vocabulary sizes can exceed:
- 50,000
- 100,000
- even larger

Most tokens are irrelevant at any given step.

Top-k sampling keeps only the K most likely tokens.

Everything else becomes probability 0.

---

# Example

Before top-k:

| Token | Probability |
|---|---:|
| mat | 0.50 |
| floor | 0.20 |
| table | 0.10 |
| elephant | 0.0001 |

If:

```text
top-k = 3
```

only:
- mat
- floor
- table

remain selectable.

---

# Top-p Sampling (Nucleus Sampling)

Top-p is more adaptive.

Instead of fixed number of tokens, the model keeps the smallest set whose cumulative probability exceeds:

$$
p
$$

Example:

```text
p = 0.9
```

---

# Why Top-p Became Popular

Easy prompts:
- small candidate set

Ambiguous prompts:
- larger candidate set

This creates more natural generation behavior than fixed top-k.

Modern chat systems frequently use:
- Temperature
- Top-p
- Repetition penalties

together.

---

# Hallucinations

One of the most important realities of LLMs.

---

# Critical Truth

LLMs optimize for:

> plausible next-token prediction

NOT:
- Truth
- Grounded factual retrieval
- Perfect reasoning

This is why hallucinations occur.

---

# Example

Prompt:

```text
"What did Napoleon say in 2022?"
```

The model may still confidently produce output because:
- fluent continuation patterns exist

not because:
- factual grounding exists.

---

# Why Hallucinations Increase at Higher Temperature

Higher randomness:
- Increases low-probability token selection
- Weakens factual precision
- Encourages creative continuation

This can:
- Improve brainstorming
- Worsen reliability

---

# Context Conditioning

LLMs are extremely sensitive to context.

Small prompt changes can dramatically alter:
- Probability distributions
- Tone
- Reasoning style
- Formatting
- Verbosity
- Behavior

---

# Example

Prompt A:

```text
"Write Python code"
```

Prompt B:

```text
"You are a senior Python engineer. Write production-grade code."
```

The second prompt shifts:
- Output distributions
- Structure expectations
- Stylistic patterns

This is why prompt engineering matters.

---

# Why System Prompts Matter So Much

System prompts strongly bias:
- Behavior priors
- Assistant personality
- Formatting rules
- Safety behavior
- Response style

They shape generation before user input even arrives.

---

# Beam Search

Another generation strategy.

Mostly used in:
- Translation
- Structured generation
- Seq2seq systems

instead of chat models.

Beam search explores multiple candidate continuations simultaneously and keeps highest-scoring sequences.

---

# Why Beam Search Is Less Common in Chatbots

Beam search often produces:
- Repetitive outputs
- Generic phrasing
- Lower creativity

Modern chat systems usually prefer sampling-based approaches.

---

# Deterministic vs Probabilistic Generation

Even temperature 0 is not perfectly deterministic in practice.

Tiny differences in:
- Floating point math
- GPU execution
- Implementation details

can still slightly alter outputs.

---

# The Bigger Picture

Generation is fundamentally **controlled probabilistic sampling**

The art of LLM engineering largely involves shaping probability distributions effectively.

---

# Why GPT Scaled So Well

Autoregressive Transformers:
- Parallelized training efficiently
- Scaled with data and compute
- Learned rich statistical structures
- Generalized surprisingly well

This eventually led to:
- GPT-3
- GPT-4
- Claude
- Gemini
- modern frontier models

---

# One Massive Practical Problem Still Remains

Autoregressive generation has a computational challenge.

As conversations become longer:
- Attention computation becomes expensive
- Inference slows down
- Memory usage grows rapidly

How do production LLMs remain efficient while generating long outputs?

That is where:
- KV cache
- Inference optimization
- Memory reuse

enter the picture.

We’ll unpack that in the next post.

---

# Final Thought

GPT-style generation is fundamentally **iterative probabilistic sequence continuation**.

But when scaled across:
- Massive datasets
- Enormous parameter counts
- Deep Transformer architectures

surprisingly sophisticated behaviors emerge.

That combination became one of the most important breakthroughs in modern AI.

---

# Next

--> [[part5_full_transformer_block_residuals_ffn_layernorm| The Full Transformer Block: Residuals, FFNs, and LayerNorm]]



