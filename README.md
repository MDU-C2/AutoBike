# AutoBike

Autonomous+Self Balacing Bicycle

## Getting Started

Please read through the coding style guides we are using

* [CppStyleGuide](http://wiki.ros.org/CppStyleGuide) - ROS Cpp Style Guide
* [PyStyleGuide](http://wiki.ros.org/PyStyleGuide) - ROS Python Style Guide

## Dependencies

## How to Git

Please refer to this cheat sheet before doing anything.

* [GitCheatSheet](https://services.github.com/on-demand/downloads/github-git-cheat-sheet.pdf) - Git Cheat Sheet

Open a command window and run:

```
man git
```

To access the git manual.

And check out the Git Mannerism page under InfoWiki on our team site.

### Clone the repository

```
cd ~/catkin_ws/src

git clone https://github.com/notlochness/AutoBike.git
```

### Checkout the branch you want and make a local one

```
git branch --list

git checkout <branch>

git branch <new-branch>
```

### When your code is stable, merge the branches

```
git checkout <branch>

git pull

git merge <local-branch>
```