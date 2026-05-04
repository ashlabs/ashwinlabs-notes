---
title: AI Systems Thinking
tags:
  - ai-systems
  - agents
  - prompting
---

## Start Here

If you read only one thing on this site, start with the Core System Design section below.

Most people approach AI like this:

- Write a prompt  
- Hope it works  
- Tweak wording  

That works… until it doesn’t.

This series is about a different approach:

> Treat AI systems like engineered systems, not magic boxes.

---

## The Core Idea

Real-world AI systems are not just prompts or models.

They are **composed systems** with interacting layers:

```
Retrieval → Validation → Planning → Memory → Evaluation
```

Each layer solves a different problem.

Most failures happen when one of these layers is missing.

---

## Core System Design (Start Here if You Want Depth)

This is the most important part of this site.

- [[part1-agentic-RAG-case-study|Part 1: Explaining Procurement Decisions with Agentic RAG]]
- [[part2-gate-checks|Part 2: Gate Checks in AI Systems]]
- [[part3-planning-in-agents|Part 3: Planning in Agents]]
- [[part4-agentic-memory|Part 4: Agentic Memory]]
- [[part5-learning-agents|Part 5: Learning Agents (Evaluation & Feedback)]]

---

## Foundations

Start here if you are new to system-level thinking:

- [[prompt-engineering|Prompt Engineering Is Not About Prompts]]
- [[why-prompts-fail|Why Prompts Fail (And How to Debug Them)]]
- [[prompt-engineering-techniques|Prompt Engineering Techniques That Actually Work]]

---

## From Prompts to Systems

- [[from-prompts-to-agents|From Prompts to Agents]]
- [[hard-coded-workflows-vs-agents|Hardcoded Workflows vs Agents]]

---

## Core Agent Mechanics

- [[deconstructing-ai-agent|Deconstructing the AI Agent]]
- [[inside-the-react-pattern|Inside the ReAct Pattern]]
- [[how-tool-calling-actually-works|How Tool Calling Actually Works]]

---

## Building Real Systems

- [[how-agents-plan|How AI Agents Plan]]
- [[memory-in-agents|Memory in AI Agents]]
- [[reliable-agents|Building Reliable Agent Workflows]]

---

## System Design Decisions

- [[agent-types|Agent Types]]
- [[when-not-to-use-agents|When Not to Use Agents]]

---

## How to Read This

This is not a set of independent posts.

Each layer builds on the previous:

1. Learn prompting  
2. Understand agents  
3. Learn system design  
4. Study real implementations  

If something feels unclear:
- Go back one step  
- Revisit the mental model  
- Then continue  

---

## Final Thought

AI is not about getting the model to say the right thing.

It’s about designing systems where:

> The model has no choice but to behave correctly.
