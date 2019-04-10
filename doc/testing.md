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

Install prerequisite tools and libraries:

    sudo apt-get install build-essential cmake flex bison libpthread-stubs0-dev

Install gtest source package:

    sudo apt-get install libgtest-dev

Build and install gtest:

    cd /usr/src/gtest
    sudo cmake CMakeLists.txt
    sudo make
    sudo make install

Clone asMSX repository:

    git clone https://github.com/Fubukimaru/asMSX

And here is the difficulty lol