---
title: Hard-Codes Workflows vs AI Agents (ReAct) - The Difference That Actually Matters
---

When people first encounter AI agents, the reaction is usually:
> "Wait...isn't this just calling APIs with an LLM in between?"

Not quite.

There's a subtle but _very important_ shift happening - from you controlling the flow to the model controlling the flow.

Let's break it down properly, with real code.

---

## The Same Problem

Let’s solve a simple task:

> “What time is my dental appointment tomorrow?”

We’ll implement this in two ways:

1. Hard-coded workflow
2. Agent (ReAct style)

---

## 1. Hard-Coded Workflow (You Are in Control)

In this approach, you define the steps.

The LLM is just used to answer small questions.

```python
def get_calendar(date): 
    # Mock calendar API 
    return {"appointment": "9am"} 
    
def ask_llm(prompt): 
    # Mock LLM response 
    if "Will this query require fetching calendar data?" in prompt: 
        return "Yes" 
    elif "9am" in prompt: 
        return "Your dental appointment is at 9am" 
    return "Unknown" 
    
def handle_query(query): 
    # Step 1: Ask LLM if tool is needed 
    decision_prompt = f""" Will this query require fetching calendar data? QUERY: {query} """ 
    decision = ask_llm(decision_prompt) 
    
    # Step 2: YOU decide what to do 
    if decision == "Yes": 
        calendar_data = get_calendar("tomorrow") 
    
        # Step 3: Pass result back to LLM 
        final_prompt = f""" Calendar data: {calendar_data} Answer the user query: {query} """ 
    
        return ask_llm(final_prompt) 
    
    return "I cannot answer that."
```

### What's Actually Happening

- You control the flow
- You decide when tools are called
- The LLM is used in isolated steps

This is called **prompt chaining**.

### Mental Model

You are the manager:
> "First check the calendar. Then answer."

The LLM is just executing instructions.

---

## 2. Agent (ReAct Framework)

Now we flip the control.

The LLM:
- Decides what to do
- Calls tools
- Observes results
- Continues reasoning

```python
import re 

def get_calendar(date): 
    return {"appointment": "9am"} 

def llm_agent(prompt): 
    """ 
    Simulated LLM that outputs THOUGHT/ACTION/OBSERVATION 
    """ 
    
    if "User:" in prompt and "appointment" in prompt: 
        return """THOUGHT: I need to check the calendar ACTION: get_calendar("tomorrow")""" 
    
    if "OBSERVATION" in prompt: 
        return """THOUGHT: I now know the answer ACTION: final_answer("Your dental appointment is at 9am")""" 
        
    return "I don't understand" 
    
def run_agent(query): 
    state = f"User: {query}" 
    
    while True: 
        response = llm_agent(state) 
        print("\nLLM RESPONSE:\n", response) 
        
        # Parse ACTION 
        if "get_calendar" in response: 
            result = get_calendar("tomorrow") 
            state += f"\nOBSERVATION: {result}" 
        elif "final_answer" in response: match = re.search(r'final_answer\("(.*)"\)', response) 
            return match.group(1)
```

### What's Actually Happening
- The LLM decides the next step
- The system just executes tool calls
- The loop continues until the final answer

This is **reasoning + acting (ReAct)

### Mental Model

You hired an employee:
> "Figure out how to answer this."

The LLM:
- Thinks
- Acts
- Adjusts

---

## Side-by-Side Comparison

| **Aspect**         | **Hard-Coded Workflow** | **Agent(ReAct)** |
| ------------------ | ----------------------- | ---------------- |
| Wo decides steps   | You                     | LLM              |
| Flexibility        | Low                     | High             |
| Reliability        | High                    | Medium           |
| Complexity handled | Simple                  | Complex          |
| Debuggability      | Easy                    | Harder           |

---

## When Should You Use Each?

### Use Hard-Coded Workflows When:
- You know the exact flow
- You need reliability
- You're building MVPs
- The task is structured

### Use Agents When:
- The task is open-ended
- Steps are not known upfront
- You need adaptability
- You want autonomy

---

## The Trap Most People Fall Into

They jump straight into agents. It's a bad move.

Agents:
- Are harder to debug
- Need guardrails
- Can behave unpredictably

---

## The Smarter Approach

1. Start with hard-coded workflows
2. Identify where flexibility is needed
3. Introduce agent behavior *only there*

---

## Final Takeaway

This is not about "calling APIs with an LLM."

It's about **who is in control of the decision-making loops:**

- Hard-coded --> You are the brain
- Agent --> The LLM is the brain

That's the shift.

And once you see it, you'll start designing systems differently.

---

