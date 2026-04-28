---
title: Inside the ReAct Pattern (Think → Act → Observe)
---

At some point, prompting stops being about writing better instructions.

You start asking a different question:

> “How do I make the model *do things*, not just say things?”

That’s where the ReAct pattern comes in.

---

## The Core Idea

ReAct stands for:

- **Think** → Reason about what to do  
- **Act** → Take an action (usually call a tool)  
- **Observe** → Receive the result  

And then repeat.

It turns a language model into something that behaves more like an **agent**.

---

## Why This Matters

Without ReAct, the model is limited to:
- What it already knows
- What fits in context

With ReAct, it can:
- Query APIs
- Fetch real-time data
- Perform calculations
- Iterate on results

It moves from **static answering → dynamic problem solving**

---

## A Simple Example

Let’s take a question:

> What was the weather one week ago?

### Step 1: THINK

The model reasons:

- Today is Jan 17  
- One week ago = Jan 10  
- I need weather data  
- I should call a weather API  

---

### Step 2: ACT

```text
call_weather_api(date="2024-01-10")
```

---

### Step 3: OBSERVE

```text
{"date": "2024-01-10", "weather": "Sunny"}
```

---

### Step 4: THINK AGAIN

- I now have the data  
- I can answer the question  

---

### Step 5: FINAL ANSWER

> The weather on Jan 10 was sunny.

---

## What’s Really Happening Under the Hood

This is not magic.

It’s a loop:

1. Model generates reasoning  
2. Model decides an action  
3. External system executes it  
4. Result is fed back  
5. Model continues  

The key insight:

> The model is not executing tools.  
> It is *deciding* to use them.

---

## The Role Trick (Important)

In many implementations, the observation is passed as a **user message**.

That feels wrong at first.

It’s not actually the user.

But it works because:

- The model treats it as **new external input**
- Not as instruction
- Not as system control

It’s basically:

> Environment → Model: “Here’s what happened”

---

## Why Not Use System?

System messages are:
- High authority
- Meant for rules

If you put observations there, you risk:
- Overriding behavior
- Confusing control flow

So we keep:
- System → rules  
- Assistant → decisions  
- User → new information  

---

## The Big Shift

Without ReAct:

> Prompt → Response

With ReAct:

> Loop → Decision → Action → Feedback → Decision

That’s a completely different paradigm.

---

## Where This Becomes Powerful

ReAct enables:

- Multi-step reasoning  
- Tool integration  
- Error correction  
- Iterative refinement  

Example:

> “Find the cheapest flight, convert price to USD, compare with last week”

This requires:
- API calls  
- Calculations  
- Multiple steps  

Not possible with simple prompting.

---

## Common Mistakes

### 1. No Clear Action Format

If the model doesn’t know how to call tools → it won’t.

---

### 2. Weak Observation Handling

If observations are unclear → reasoning breaks.

---

### 3. Mixing Roles

If system/user/assistant boundaries blur → behavior becomes unpredictable.

---

## Final Thought

ReAct is the moment prompting becomes **system design**.

You’re no longer asking:

> “What should the model say?”

You’re asking:

> “What should the model *do next*?”

That’s a higher-level skill.
