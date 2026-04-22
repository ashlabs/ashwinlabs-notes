---
title: CIFAR-10 Image Classification — Build vs Buy
---

## Overview

I built an image classification model on CIFAR-10 and used it to evaluate a common product decision:

> Should we build our own model or use a third-party solution?

A vendor (Detectocorp) claimed **70% accuracy** on CIFAR-10.  
My goal was to validate whether we could outperform that internally and understand the tradeoffs.

---

## The Decision Context

Imagine a self-driving car startup evaluating object detection capabilities.

The options:

- **Buy** → integrate Detectocorp’s model (70% accuracy)
- **Build** → develop an in-house model and iterate

This is not just a modeling problem. It’s a **product + engineering decision**:
- performance vs speed
- control vs convenience
- long-term vs short-term tradeoffs

---

## Dataset

- 60,000 images (50k train / 10k test)
- 32×32 RGB images
- 10 classes (cars, planes, animals, etc.)

CIFAR-10 is small but useful for controlled experimentation and comparing approaches.

---

## Approach

I started with a simple CNN baseline and improved it through controlled experiments.

### Model Architecture

- Conv(3 → 32) → ReLU → MaxPool  
- Conv(32 → 64) → ReLU → MaxPool  
- Flatten  
- FC → 256 → ReLU → Dropout  
- FC → 10  

### Training Setup

- Loss: CrossEntropyLoss  
- Optimizer: Adam (lr = 0.001)  
- Batch size: 64  
- Epochs: 10 → 25  

### Preprocessing

- ToTensor()  
- Normalize((0.5,0.5,0.5), (0.5,0.5,0.5))  

---

## Experiments

Instead of tuning everything at once, I ran **controlled experiments**, changing one variable at a time.

### Experiment 1 — Baseline

- No augmentation  
- 10 epochs  

**Result:**  
Accuracy = **74.35%**

Already higher than Detectocorp’s 70%.

---

### Experiment 2 — Strong Augmentation (Short Training)

- RandomHorizontalFlip + RandomCrop  
- 10 epochs  

**Result:**  
Accuracy = **73.90%**

**What happened:**
- Augmentation made the task harder  
- The model didn’t train long enough to benefit  

**Insight:**  
> Augmentation increases difficulty before it improves generalization.

---

### Experiment 3 — Light Augmentation + Longer Training

- RandomHorizontalFlip  
- 25 epochs  

**Result:**  
Accuracy = **76.14%**

**Insight:**
- Light augmentation + sufficient training improves generalization  
- Training duration is tightly coupled with augmentation strength  

---

## Results

| Model         | Accuracy |
|--------------|----------|
| Detectocorp  | 70.00%   |
| Baseline     | 74.35%   |
| Improved     | 76.14%   |

Even the baseline model outperformed the third-party solution.

---

## Key Insights

### 1. Augmentation is a tradeoff
- improves generalization  
- increases training difficulty  

### 2. Training time matters more than expected
- undertraining leads to wrong conclusions  
- especially with augmented data  

### 3. Metrics can mislead
- lower training loss ≠ better model  
- test accuracy is what matters  

### 4. Controlled experimentation is critical
- change one variable at a time  
- always compare to baseline  

---

## Recommendation: Build In-House

I would recommend building the model internally.

**Why:**

### Performance
- In-house model: **76.14%**
- Detectocorp: **70%**

### Strategic advantages
- full control over model behavior  
- ability to adapt to domain-specific data  
- faster iteration cycles  

### Product perspective
Buying is faster initially, but:
- locks you into vendor constraints  
- limits optimization  
- slows long-term improvement  

For a system like self-driving, where performance and adaptability are critical:

> Control is more valuable than convenience.

---

## What I Would Improve Next

- Deeper architectures (ResNet-style)  
- Batch normalization  
- Learning rate scheduling  
- Transfer learning on real-world driving data  

---

<!-- ## Interview Cram

- CNNs preserve spatial structure → better than fully connected models  
- CrossEntropyLoss expects logits (no softmax during training)  
- Augmentation improves generalization but needs longer training  
- Never augment test data  
- Evaluate on test set, not training loss  

--- -->

## One-line Summary

> I built a CNN model that outperformed a third-party solution and improved it through controlled experimentation, leading to a clear build-vs-buy recommendation.