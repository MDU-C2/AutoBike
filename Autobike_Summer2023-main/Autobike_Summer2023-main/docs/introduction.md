# Introduction to the project

The Autobike project is a research project at Chalmers University of Technology in collaboration with several partners within the automotive industry. The goal of the project is to construct and program self-driving bikes able to track a reference trajectory for use in automotive vehicle testing. In current automotive vehicle tests involving bikes and bikers, it is common to mount a normal bike to a mobile platform or track whose movement can be programmed. However, with the bike balancing on its own the motion will be more natural and better suited to replecating biker behaviour such as wiggling.

This document is ment to give a brief overview of the project, enough to understand most of the [manual](./manual.md). At the end of this document, there are recommended steps to get further introduced to the project and the bikes.

## Hardware

As a hardware platform, ordinary commercial electrical bikes are used. These are then fitted with a combination of the following components:

- A motor and encoder to actuate the steering bar
- An ESCON unit, a motor controller for the steering motor
- A FSESC (VESC) unit, a motor controller for the drive motor
- An IMU
- GNSS antennass and a GNSS board by u-blox with RTK capability
- A LabVIEW myRIO, a microcontroller
- An I/O distribution board ("green PCB") through which the myRIO communicates with the other hardware
- A RUT955, a 4G router providing RTK corrections to the u-blox board through an USB connection and WiFi for communication between a lab computer and the myRIO
- A LiPo battery
- A power distribution board

## The bikes

There are currently four very similar sets of control hardware:

- The hardware mounted permanently to the **Black Bike**, which is still runnning old software written in python which is kept separate from this repository. The control electronics is the same or similar to the other sets, but the documents within this repository are still mostly written with the other two sets of hardware in mind.
- The hardware mounted permanently to the **Red Bike**. This is the bike most commonly used for testing the code and routines in this repository.
- The **Portable Bike** constitutes a set of hardware which has been designed to be easially unmounted and mounted to the frame of a bike. It is most commonly either mounted to the **Green Bike**, a commercia electric bike, or the **Plastic Bike**, a bike built by students from 3D printed parts and plastic tubes so as to be cheapily replaced after a destructive test.
- The hardware mounted to the **E-scooter**, an electric scooter also running the code in this repository.

## The control algorithm

The control of the bike is split into five steps:

1. Read sensors
2. Estimate the state (position, orientation, speed, etc.) of the bike using a Kalman Filter
3. The trajectory controller compares the estimated position with a reference trajectory and generates a desired bike roll angle in order to track the trajectory
4. The balancing controller generates a desired steering angle rate to track the desired roll angle, thus balancing the bike
5. Send the desired steering angle rate to the steering motor controller

## The work flow

Much of the work in the project is carried out as part of master's or bachelor's thesis projects or internships, each with their own sub-goals.

Modification to the electronics is carried out in the caselab at Chalmers.

The software of the bikes is written in LabVIEW, with heavy use of C code which is called from within LabVIEW. In particular, C is used for implementing control algorithms, while LabVIEW is used for communication with sensors and motor controllers, timing and logging. For developing new software features, typically the algorithms will first be tested using MATLAB and Simulink. A Simulink model of the bike exists, but is not present in this repository. Then the algorithm is transfered to C code and verified on the bikes. The surrounding LabVIEW framework is also updated if neccessary.

## Papers and reports

Multiple reports and papers have been written by past or current groups working within the bike project. There is no single report giving a good overview of the status of the bikes as students have worked on specific parts of the functionalities in different projects. However, the we aim to keep the information in this repository up to date. So **if you notice something lacking or out of date in this repository**, please do not hesitate to update it!

Below are a list of some relevant report. If you are new to the project, it is adviced to only skim through these at first and only return to them later when you need the detailed information within them. Keep in mind that some of the descriptions of the current state of the hardware or software in these documents may be out of date.

- _Paper on the trajectory controller which is implemented on the bike. The implementation was done by another set of students after the paper was written_  
  Conference paper:  
  [Lateral Control of a Self-driving Bike](https://ieeexplore.ieee.org/document/9986548)  
  G Wen, J Sjöberg  
  2022 IEEE International Conference on Vehicular Electronics and Safety
- _Report on, among other thins, the hardware and software used for RTK corrections. In despite of the title of the report, no trajectory controller was implemented by the author_  
  Master's thesis report:  
  Trajectory control implementation in autonomous bicycles  
  A Ricou Pujal

## Next steps

The following steps are recommended for getting further introduction to the Autobike project. If you are joining the project, you are especially recommended to go through these steps:

1. Read this document
2. Skim the documents under [Papers and reports](#papers-and-reports) which are relevant to your work
3. Read the entire [Running the bike](./manual.md#running-the-bike) section of the manual. Install all the software neccessary to run the bikes to your own laptop (if you have one). Skim the rest of the manual, to return to it when you know which information in there you need.
4. Find someone to give you a physical tour of the bike lab, the bike hardware, and who can give you a demostration of the bikes. Try to apply what you learned from the manual to run the bikes yourself from your own laptop.
5. If you are going to program the bikes in some way, find someone who can introduce you further to the code contained in this repository.
