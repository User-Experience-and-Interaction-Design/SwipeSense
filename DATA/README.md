# DATA

[![Status](https://img.shields.io/badge/Status-Will%20be%20released%20soon-blue)](STATUS)

---

## Overview

This directory will soon host the dataset collected as part of the SwipeSense project. Upon release, the dataset will provide comprehensive sensor data captured during our user study on back-of-device swipe interactions. The dataset is intended to support further research on gesture recognition and facilitate the evaluation of alternative recognition techniques.

## What to Expect

- **Participant Data:**  
  Data was collected from 12 participants. Each participant performed 800 swipe gestures (both perpendicular and diagonal), totaling 9600 swipe events across the study.

- **Sensor Readings:**  
  The dataset includes raw inertial measurement unit (IMU) sensor data recorded from the built-in accelerometer and gyroscope. Each gesture event is represented by six channels (three axes from the accelerometer and three from the gyroscope).

- **Sampling Rate and Data Format:**  
  IMU signals were captured at a 10Hz sampling rate over short time windows (approximately 3000 ms per swipe), resulting in detailed time series data that reflects the dynamic characteristics of the swipe gestures.

- **Data Annotations:**  
  Each recorded swipe gesture is annotated with labels indicating:
  - **Swipe Detection:** Binary indication of whether a swipe occurred.
  - **Swipe Classification:** The directional label of the swipe (e.g., perpendicular: up, down, left, right; diagonal: upper-left, upper-right, lower-left, lower-right).

- **Usage:**  
  The data has been collected under controlled conditions in a lab study and can be used to train, validate, and compare machine learning models for gesture recognition.

## Data Format

Data will be provided in commonly used formats (e.g., CSV or JSON) with detailed documentation explaining the structure, features, and annotation scheme. This documentation will accompany the dataset release to assist researchers in understanding and utilizing the data effectively.

## Citation

When using this dataset in your work, please cite the original SwipeSense paper:

> *SwipeSense: Exploring the Feasibility of Back-of-Device Swipe Interaction Using Built-In IMU Sensors.*

For further details and updates, please refer to the main repository or the project webpage.

---

*This dataset will be made publicly available upon paper acceptance. Stay tuned for updates!*
