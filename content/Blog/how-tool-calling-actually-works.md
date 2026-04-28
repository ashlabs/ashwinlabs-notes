---
title: How Tool Calling Actually Works (Under the Hood)
---

By now, you’ve seen the ReAct pattern:

Think → Act → Observe

It *looks* like the model is calling tools.

But here’s the uncomfortable truth:

> The model never actually calls anything.

That’s your system’s job.

---

## The Illusion Most People Believe

When you see something like:

```text
ACT:
call_weather_api(date="2024-01-10")
```

It feels like the model is executing code.

It’s not.

What it’s really doing is:

> Generating structured text that *represents an intent to act*

That distinction matters more than it seems.

---

## The Actual Flow (Step by Step)

Let’s break down what really happens.

### 1. User Input

```text
What was the weather one week ago?
```

---

### 2. Model Decides to Use a Tool

The model responds with something like:

```json
{
  "tool_calls": [
    {
      "name": "call_weather_api",
      "arguments": { "date": "2024-01-10" }
    }
  ]
}
```

Important:

👉 This is NOT execution  
👉 This is a **decision**

---

### 3. Your System Intercepts This

Your application reads that output and says:

> “Got it. The model wants to call this tool.”

Then your code does the real work:

- Parses arguments  
- Calls the API  
- Gets the result  

---

### 4. Tool Executes (Outside the Model)

Example result:

```json
{
  "date": "2024-01-10",
  "weather": "Sunny"
}
```

This step is completely external.

The model is not involved.

---

### 5. You Feed Result Back to the Model

Now you send:

```json
{
  "role": "tool",
  "content": "{...result...}"
}
```

---

### 6. Model Continues Reasoning

Now the model can say:

> “The weather on Jan 10 was sunny.”

---

## The Key Insight

Let’s make this explicit:

| Step | Who does it |
|------|------------|
| Decide to call tool | Model |
| Execute tool | Your system |
| Return result | Your system |
| Interpret result | Model |

---

## Why This Architecture Exists

You might wonder:

> “Why not just let the model execute directly?”

Because that would be a mess.

You need:

- Security (don’t let model run arbitrary code)
- Control (validate inputs)
- Observability (log everything)
- Reliability (retry failures)

So the model:
👉 **decides**

Your system:
👉 **executes**

---

## This Is Where Product Thinking Comes In

At this point, you’re not just “using AI.”

You’re designing:

- Tool interfaces  
- Data contracts  
- Failure handling  
- Decision boundaries  

This is exactly where PM-T + systems thinking becomes valuable.

---

## Common Mistakes

### 1. Blind Execution

Developers just execute whatever the model says.

Bad idea.

Fix:
- Validate arguments
- Add guardrails

---

### 2. Weak Tool Design

If tools are vague, the model struggles.

Bad:
```text
analyze_data(data)
```

Better:
```text
get_top_anomalies(data, count=3)
```

Clearer intent → better usage.

---

### 3. Poor Error Handling

What happens if:
- API fails?
- Data is missing?

If you don’t handle this, your agent breaks.

---

## Mental Model (Keep This)

> The model is a decision engine.  
> Your system is the execution engine.

Mixing these up is where most designs fail.

---

## Final Thought

When people say:

> “The model called an API”

That’s shorthand.

What actually happened is:

> The model *asked* to call an API.  
> Your system *decided to honor that request.*

That distinction is everything.

