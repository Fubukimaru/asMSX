# asMSX testing guide

We use [gtest](https://github.com/google/googletest/blob/master/googletest/docs/primer.md) framework for our test coverage.

Currently only one basic test for build_tape_file_name() function is implemented.
More should follow as the code is massaged into testable state.

## Set up gtest in Windows and Visual Studio 2019

You'll need to make sure that nuget package 

## Set up gtest in Ubuntu Linux

Update/upgrade:

    sudo apt update
    sudo apt upgrade

If you didn't already, install gcc, flex and bison

    sudo apt-get install build-essential flex bison

Install gtest from package repository:

    sudo apt-get install libgtest-dev

Install `cmake`, we'll need it to build gtest libraries.

    sudo apt-get install cmake

Build and install gtest:

    cd /usr/src/gtest
    sudo cmake CMakeLists.txt
    sudo make
    sudo make install

Clone asMSX repository:

    git clone https://github.com/Fubukimaru/asMSX

And here is the difficulty lol