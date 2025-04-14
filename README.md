# SwipeSense : Exploring the Feasibility of Back-of-Device Swipe Interaction Using Built-In IMU Sensors
**Neel Shah, Dr. Marinana Shimabukuro, Dr. Ali Neshati**  
*Ontario Tech University*
<br>

[![ACM MobileHCI](https://img.shields.io/badge/Work%20submitted%20to%20ACM%20MobileHCI-Under%20Review%20%7C%20Do%20Not%20Share%20or%20Distribute-red)](https://shields.io/) [![Data](https://img.shields.io/badge/Data-Will%20be%20released%20soon-blue)](DATA)

<figure>
  <img src="assets/Teaser.jpg" alt="Teaser Image">
  <figcaption style="font-size: 0.8em; font-style: italic;">
    Figure 1: a. Common “fat finger” problem during direct touchscreen interaction where the user’s finger blocks the display content. b. One-handed scrolling using a back-of-device swipe, which allows seamless interaction while holding another object. c. Answering an incoming call with a diagonal back-of-device swipe, enabling quick interaction while holding onto a support handle in a busy environment.
  </figcaption>
</figure>

<br>

The growing dimensions of smartphones have intensified the challenges associated with screen reachability. Back-of-device (BoD) interaction expands the range of reachability and offers a promising solution to mitigate screen occlusion while enhancing one-handed interactions. However, much of the existing research relies on incorporating additional hardware components. In this paper, we present SwipeSense, a technique for exploring the feasibility of directional swipe interactions on the back of devices, utilizing built-in inertial measurement unit (IMU) sensors and machine learning models. We conducted a user study with 12 participants who performed 9600 BoD swipes in 8 distinct directions while holding the device naturally. The results of our machine learning models indicate that various directional swipes on the back of the device can be accurately distinguished using only the built-in IMU sensors of the phone, achieving a range of model accuracy between 72% and 93%. Furthermore, we showcase potential applications for these gestures.

---
### Demo Video
The video below demonstrates the SwipeSense interaction in action. Click play to watch the demo:

<p align="center">
  <a href="https://youtu.be/JErq3_347tg">
    <img src="assets/Teaser.jpg" alt="Click to watch video" width="300px" />
  </a>
</p>
---

## SwipeSenseNet: The Multi-Task Model

<figure>
  <img src="assets/SwipeSenseNet.jpg" alt="SwipeSenseNet">
  <figcaption style="font-size: 0.8em; font-style: italic;">
    Figure 2: Overview of the multi-task learning model for back-of-device swipe classification. The model processes accelerometer and gyroscope data (X, Y, Z axes) using a series of 1D convolution layers, batch normalization, max pooling, dense and dropout layers. It detects swipe gestures and classifies them into N swipe categories.
  </figcaption>
</figure>

SwipeSenseNet is the multi-task neural network model developed for this project. It is designed to simultaneously perform two critical tasks:

- **Swipe Detection:** Determines whether a swipe gesture is present in the input from the smartphone’s built-in IMU sensors.
- **Swipe Classification:** Identifies the direction of the detected swipe from among multiple possible classes.

By leveraging a multi-task learning approach, SwipeSenseNet shares feature extraction layers for both tasks, resulting in efficient processing and high classification accuracy (ranging between 72% and 93%). This model is a key component that demonstrates the feasibility of using back-of-device swipe interactions to enhance one-handed smartphone usability.

---


## SwipeSenseUserStudy

This directory contains the complete codebase for the user study described in the SwipeSense paper. The code is organized into subdirectories that handle different aspects of the application:

**Directory Structure**

**DirectionalSwipe**  
*Purpose:*  
Presents random swipe prompts to the user in a balanced manner. The display order is controlled using a Latin square design to ensure each swipe direction appears with even frequency.  
*Highlights:*  
- Randomized (yet balanced) selection of swipe directions.  
- UI components for presenting on-screen swipe gestures.  
- Animation and timing for each gesture prompt.

**SwipeController**  
*Purpose:*  
Handles user input via a connected mobile keyboard. This module tracks the timing of user actions, marking when a gesture starts and stops, and facilitating transitions between swipe prompts.  
*Highlights:*  
- Listens for key strokes from the mobile keyboard.  
- Marks the start and stop of each gesture.  
- Manages transitions from one swipe prompt to the next.  
- Logs and processes user input data for later analysis.
