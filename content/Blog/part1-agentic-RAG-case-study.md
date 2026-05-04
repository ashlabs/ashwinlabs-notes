---
title: Explaining Procurement Decisions with Agentic RAG- A Case Study
---
> This is a 3-part case study on building a production-grade decision explanation system using agentic RAG.  
> 
> It covers system design ([[part1-agentic-RAG-case-study|Part 1]]), validation ([[part2-gate-checks| Part 2]]), and planning ([[part3-planning-in-agents| Part 3]]). 
> 
> There's a particular kind of question that looks simple---right up until you try to answer it.

It usually comes in some variation of this:

> "Why didn't I receive a purchase order this week?"

At first glance, it feels like something that should have a
straightforward explanation. A missed threshold. A system glitch. A
quick lookup.

But in reality, this question forces you to reconstruct a decision that
was never explicitly recorded in one place.

To answer it properly, you have to piece together a story.

You have to understand how demand evolved, whether inventory levels
justified replenishment, how reliable the vendor has been, and what the
purchase order system ultimately decided to do.

None of this lives in a single system.

So every time the question came up, someone had to investigate.

They would open multiple dashboards, run queries across systems,
cross-reference signals, and slowly build a mental model of what
happened.

On a good day, it took thirty minutes.

On a bad day, it stretched into hours.

And the pattern repeated.

Different vendors. Different products. Same investigation.

That's when it became clear:

This wasn't an efficiency problem.

It was a **missing capability**.

We didn't have a way to explain decisions.

------------------------------------------------------------------------

## Reframing the Problem

The initial instinct was to think in terms of automation.

Could we use an LLM to answer these questions?

Could we layer RAG on top of internal documentation?

That approach breaks quickly.

Because the answer doesn't live in documents.

It has to be constructed from **live, structured signals**.

What we needed was not a chatbot.

We needed a system that could take a question and turn it into an
investigation.

------------------------------------------------------------------------

## From Questions to Investigations

Instead of answering directly, the system gathers evidence first.

``` mermaid
flowchart TD
    A[Vendor Question] --> B[Understand Intent]
    B --> C[Plan Investigation]

    C --> D1[Fetch Demand]
    C --> D2[Check Inventory]
    C --> D3[Vendor Performance]
    C --> D4[PO Logs]

    D1 --> E[Aggregate Evidence]
    D2 --> E
    D3 --> E
    D4 --> E

    E --> F[Generate Explanation]
    F --> G[Validate]
    G --> H[Access Control]
    H --> I[Final Answer]
```

The system doesn't try to be clever upfront.

It behaves like a disciplined investigator.

------------------------------------------------------------------------

## A Concrete Example

Consider:

> "Why did ASIN X not receive a purchase order this week?"

A proper answer requires:

-   Demand trend analysis\
-   Inventory coverage evaluation\
-   Vendor reliability signals\
-   PO generation logic

The system retrieves each of these systematically.

Only then does it generate an explanation:

> "No purchase order was generated because forecasted demand declined,
> inventory coverage exceeded the reorder threshold, and vendor
> confirmation rates were below eligibility requirements."

This is not a guess.

It is a **constructed explanation backed by evidence**.

------------------------------------------------------------------------

## Where RAG Fits

RAG plays a supporting role.

It provides: - policy context\
- threshold definitions\
- business rules

But it does not replace structured data.

> Retrieval provides context\
> Tools provide evidence\
> The model explains

------------------------------------------------------------------------

## What Changed

Before: - 30 min -- 4 hr investigations\
- repetitive manual effort\
- fragmented understanding

After: - near-instant answers\
- consistent explanations\
- traceable reasoning

**This reduced investigation time from hours to seconds and allowed
teams to shift from reactive support to proactive system improvements.**

------------------------------------------------------------------------

## Final Thought

This started as:

"Can we answer vendor questions?"

It became:

"Can we explain decisions across complex systems?"

That shift is what made the system valuable.

---

## Next

--> [[part2-gate-checks| Designing Gate Checks]]

