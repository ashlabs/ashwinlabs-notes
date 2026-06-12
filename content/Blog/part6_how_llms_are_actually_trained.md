# How LLMs Are Actually Trained

*Part 6 of the Attention & Transformers Deep Dive Series*

---

# Introduction

At this point in the series, we understand:
- Attention mechanisms
- Self-attention
- Multi-head attention
- Positional encoding
- Causal masking
- Transformer blocks
- Encoder vs decoder architectures

But there is still one enormous question remaining:

> How do these models actually become intelligent?

A Transformer architecture by itself is just:
- Randomly initialized matrices
- Meaningless vector operations
- Statistical machinery

Nothing about a freshly initialized Transformer is useful.

Training is what changes everything.

Training is what turns random numbers into:
- ChatGPT
- Coding copilots
- Reasoning systems
- Conversational assistants

This post explains:
- Pre-training
- Fine-tuning
- RLHF
- Alignment
- Emergent capabilities
- Why LLMs behave the way they do

This is where Transformer theory becomes modern AI systems.

---

# The Big Picture

Modern LLM training usually happens in multiple stages.

Typical pipeline:

| Stage | Purpose |
|---|---|
| Pretraining | Learn language/world patterns |
| Supervised Fine-Tuning (SFT) | Learn instruction following |
| RLHF / Alignment | Learn preferred behavior |
| Specialized Tuning | Learn domain-specific skills |

Each stage reshapes the model in different ways.

---

# Stage 1: Pre-training

This is the foundation.

---

# The Core Objective

The model repeatedly learns:

> predict the next token

That’s it.

No symbolic reasoning engine.
No explicit logic system.
No manually programmed knowledge base.

Just:
- Next-token prediction
- At enormous scale.

---

# Example

Input: `"The cat sat on the"`

Target: `mat`

Then:

Input: `"The capital of France is"`

Target: `Paris`

Repeated:
- Billions
- Trillions
- Sometimes quadrillions

of times across huge datasets.

---

# Where the Data Comes From

Pretraining datasets often include:
- websites
- books
- Wikipedia
- code repositories
- forums
- documentation
- research papers
- educational content

The scale is massive.

Modern frontier models train on internet-scale corpora.

---

# Why Next-Token Prediction Becomes Powerful

At first glance next-token prediction sounds simplistic.

But to predict well, the model gradually learns:
- Syntax
- Grammar
- Semantics
- World knowledge
- Causal structure
- Coding patterns
- Reasoning-like behavior

because all of these help reduce prediction error.

---

# Example: Learning Facts

Suppose the model repeatedly sees:

```text
"The capital of France is Paris"
```

Gradients strengthen relationships between:
- France
- capital
- Paris

Eventually statistical associations become embedded in weights.

---

# Important Insight

LLMs do NOT store knowledge like databases.

Instead:
- knowledge becomes distributed across parameters.

This is one reason:
- retrieval is approximate
- hallucinations happen
- paraphrasing works naturally

Knowledge becomes compressed statistical structure.

---

# What Happens During Training

At every step:

1. The model predicts next-token probabilities
2. Prediction is compared to the correct answer
3. Loss gets computed
4. Gradients flow backward
5. Parameters update slightly

Then repeat.

Again.
And again.
And again.

Across:
- Enormous datasets
- Huge GPU clusters
- Massive compute budgets

---

# Loss Function Intuition

Suppose correct next token:

```text
mat
```

Model predicts:

| Token | Probability |
|---|---:|
| mat | 0.30 |
| floor | 0.25 |
| chair | 0.10 |

Loss penalizes low probability on the correct answer.

Training pushes:

```text
P(mat)
```

higher over time.

---

# Why Scale Matters So Much

One of the most surprising discoveries in AI research:

> many capabilities emerge only at scale.

Larger models trained on more data often suddenly develop:
- Coding
- Arithmetic
- Translation
- Chain-of-thought reasoning
- Tool-use behavior
- Long-range planning patterns

Researchers call these **emergent capabilities**.

---

# The Scaling Law Discovery

As researchers increased:
- Parameter count
- Dataset size
- Compute

performance improved surprisingly predictably.

This became known as **scaling laws**.

Scaling turned out to be one of the biggest drivers of modern AI progress.

---

# Raw Pre-trained Models Behave Strangely

A raw pre-trained model is basically:

> internet autocomplete.

It predicts plausible continuations.

But it does NOT naturally behave like:
- A helpful assistant
- A chatbot
- A coding copilot

---

# Example

Prompt:

```text
"Explain recursion"
```

Raw model may:
- Imitate random forum text
- Continue article fragments
- Produce messy formatting
- Generate incoherent continuation styles

because it only learned **statistical continuation behavior**. Not instruction following.

---

# Stage 2: Supervised Fine-Tuning (SFT)

This stage transforms the model into an assistant.

Humans create examples like:

| Prompt            | Desired Response    |
| ----------------- | ------------------- |
| Explain gravity   | Helpful explanation |
| Write Python code | Clean code          |
| Summarize article | Structured summary  |

The model trains on:
- `instruction → response` pairs.

---

# What SFT Changes

The model learns:
- Conversational structure
- Formatting
- Instruction obedience
- Response style
- Assistant behavior

This dramatically changes interaction quality.

---

# Important Insight

SFT does NOT fundamentally change:
- Architecture
- Core capabilities

It reshapes behavioral distributions.

The model becomes:
- More assistant-like
- More cooperative
- More structured

---

# Stage 3: RLHF (Reinforcement Learning from Human Feedback)

One of the most important modern alignment techniques.

---

# The Core Problem

Even after SFT many responses may technically be valid.

But some are:
- Clearer
- Safer
- More helpful
- More aligned with user expectations.

We need a way to teach preference.

---

# RLHF Pipeline

## Step 1: Human Ranking

Humans compare responses.

Example:

Prompt:

```text
Explain photosynthesis
```

Response A:
- Clear
- Structured
- Helpful

Response B:
- Confusing
- Disorganized

Humans prefer A.

---

# Step 2: Reward Model

A separate model learns:

> “What kinds of responses do humans prefer?”

This becomes the reward signal.

---

# Step 3: Reinforcement Learning

The LLM gets rewarded for:
- Helpfulness
- Clarity
- Safety
- Instruction following
- Conversational quality

and penalized for:
- Toxic outputs
- Dangerous behavior
- Low-quality responses

This heavily shapes assistant behavior.

---

# Why ChatGPT Feels Different From Raw GPT

Raw GPT predicts internet-like continuations.

ChatGPT:
- Underwent alignment training
- Learned conversational behavior
- learned assistant norms
- Learned preference optimization

This is why it feels:
- Cooperative
- Conversational
- Structured

instead of chaotic autocomplete.

---

# Another Important Idea: Synthetic Data

Modern LLMs increasingly train on:
- AI-generated examples
- Reasoning traces
- Synthetic conversations
- Self-generated chain-of-thought examples

This bootstraps capability development.

---

# Chain-of-Thought Training

Researchers discovered models often reason better when trained on `step-by-step explanations` instead of only final answers.

This encourages:
- Intermediate reasoning patterns
- Decomposition behavior
- Structured problem solving

---

# Why Reasoning Emerges

One of the most fascinating discoveries in modern AI:

LLMs were NOT explicitly programmed to:
- Reason
- Plan
- Code
- Translate

These behaviors emerged from:
- Scale
- Representation learning
- Statistical pattern compression
- Layered abstraction building

This surprised many researchers.

---

# But Important Caveat

LLMs are still fundamentally predictive systems.

They are NOT:
- Symbolic theorem provers
- Guaranteed truth systems
- Grounded reasoning engines

This distinction matters enormously.

---

# Why Hallucinations Exist

LLMs optimize for:

> plausible continuation

NOT:
- guaranteed factual correctness.

This is why:
- Fluent errors happen
- Fabricated citations appear
- Confident mistakes occur

The model learned statistical patterns not verified truth databases.

---

# Specialized Fine-Tuning

After general training, models may receive additional tuning for:
- Coding
- Medicine
- Legal tasks
- Finance
- Robotics
- Multimodal tasks
- Tool usage

This creates domain specialization.

---

# Why Instruction Tuning Changed Everything

Instruction tuning transformed LLMs from passive continuation systems into interactive assistants.

This dramatically expanded:
- Usability
- Accessibility
- Commercial viability

It was one of the biggest practical breakthroughs in modern AI.

---

# The Hidden Cost of Training

Training frontier models requires:
- Enormous GPU clusters
- Huge energy consumption
- Massive distributed systems
- Careful optimization
- Advanced data pipelines

Modern frontier training runs can cost:
- Millions of dollars
- Sometimes far more.

Training infrastructure became a major competitive advantage.

---

# The Bigger Picture

Modern LLM behavior emerges from:
- Transformer architectures
- Internet-scale pretraining
- Alignment tuning
- Reinforcement learning
- Massive compute scaling

None of these pieces alone would have created modern AI systems. It was the combination that changed everything.

---

# One Major Practical Problem Still Remains

Even after training:
- Inference remains expensive
- Long contexts become difficult
- Memory usage grows rapidly

How do production systems actually serve these giant models efficiently?

That is where:
- KV cache
- Flash Attention
- Inference optimization
- Memory engineering

become critically important.

We’ll explore that in the next post.

---

# Final Thought

Modern LLMs are not hand-coded reasoning systems.

They are large-scale statistical representation learners trained through:
- Prediction
- Feedback
- Optimization
- Scaling

Yet through enough scale and refinement, remarkably sophisticated behavior emerges.

That combination fundamentally changed AI.

---

# Next

--> [[part7_kv_cache_flash_attention_hidden_engineering| KV Cache, Flash Attention, and the Hidden Engineering Behind LLMs]]