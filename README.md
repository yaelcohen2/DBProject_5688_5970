# 🏨 Project Report

This project represents a comprehensive Hotel Management System, with this specific unit dedicated to **Housekeeping**.

**Authors:** Shani Levy and Yael Cohen

## 📑 Table of Contents
- [Overview](#-overview)

---

איפיון המערכת - שנוצר על ידי Google AI Studio
https://aistudio.google.com/apps/45d4298d-a5b6-4634-97e4-b68336430388?showPreview=true&showAssistant=true

## 📋 Overview
The system is a platform for managing the Housekeeping department in a hotel, designed to streamline cleaning, maintenance, and supervision processes in a smart and organized manner.
The system allows tracking and management of the following entities:

  **Rooms (`ROOM`)**:
    Managing the list of physical rooms in the hotel and ongoing monitoring.

  **Tasks and Cleaning Types (`TASKTYPE`, `HOUSEKEPINGTASK`)**:
    Defining task types (such as deep cleaning, evening turndown) and scheduling specific tasks for rooms, including priority and deadlines.

  **Statuses (`HOUSEKEEPINGSTATUS`)**:
    Real-time tracking of room/task status (e.g., dirty, in progress, clean, inspected).

  **Employees (`HOUSEKEEPINGEMPLOYEE`)**:
    Managing housekeeping employee details and shift schedules.

  **Execution Log (`CLEANNINGLOG`)**:
    Real-time digital documentation of task execution, including start/end times and employee notes.

  **Quality Control (`ROOMCHECK`)**:
    Inspections performed by supervisors, assigning quality scores for cleaning, and maintaining inspection history for continuous improvement.

  **Inventory and Supplies (`CLEANNINGSUPPLIES`, `USES`)**:
    Managing inventory of cleaning supplies and tools, and precise tracking of quantities consumed per task.

  **Employee-Task Relations (`BELONGSTO`)**:
    Smart assignment of employees to specific tasks for efficient execution.

---
**Summary:** The system provides an up-to-date and transparent view of room status, improves employee efficiency, and optimizes resource utilization in the hotel.

## 📊 ERD & DSD

### 🔗 Entity Relationship Diagram (ERD)
![ERD](stage1/ERD.png)

### 📉 Data Structure Diagram (DSD)
![DSD](stage1/DSD.png)
