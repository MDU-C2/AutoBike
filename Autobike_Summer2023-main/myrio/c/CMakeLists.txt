set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR armv71)

set(toolchainpath C:/build/18.0/arm/sysroots)

set(CMAKE_C_COMPILER ${toolchainpath}/i686-nilrtsdk-mingw32/usr/bin/arm-nilrt-linux-gnueabi/arm-nilrt-linux-gnueabi-gcc.exe)
set(CMAKE_CXX_COMPILER ${toolchainpath}/i686-nilrtsdk-mingw32/usr/bin/arm-nilrt-linux-gnueabi/arm-nilrt-linux-gnueabi-g++.exe)

set(CMAKE_SYSROOT ${toolchainpath}/cortexa9-vfpv3-nilrt-linux-gnueabi)
set(CMAKE_C_STANDARD_INCLUDE_DIRECTORIES ${toolchainpath}/cortexa9-vfpv3-nilrt-linuxgnueabi/usr/include/c++/6.3.0 ${toolchainpath}/cortexa9-vfpv3-nilrt-linuxgnueabi/usr/include/c++/6.3.0/arm-nilrt-linux-gnueabi)
set(CMAKE_C_FLAGS "-Wall -fmessage-length=0 -mfpu=vfpv3 -mfloat-abi=softfp")
set(CMAKE_C_FLAGS_DEBUG "-O0 -g3")
set(CMAKE_C_FLAGS_RELEASE "-O3")
set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES ${toolchainpath}/cortexa9-vfpv3-nilrt-linuxgnueabi/usr/include/c++/6.3.0 ${toolchainpath}/cortexa9-vfpv3-nilrt-linuxgnueabi/usr/include/c++/6.3.0/arm-nilrt-linux-gnueabi)
set(CMAKE_CXX_FLAGS "-Wall -fmessage-length=0 -mfpu=vfpv3 -mfloat-abi=softfp")
set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g3")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# project specific information
cmake_minimum_required(VERSION 3.14)
project(autobike)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY bin)
set(CMAKE_BUILD_TYPE Debug)
add_library(balancing_controller SHARED src/balancing_controller.c)
#add_library(genAbortTraj SHARED src/generateAbortTrajectory.c)
add_library(trajectory_controller SHARED src/trajectory_controller.c
	src/trajectory_selector.c
    src/generateAbortTrajectory.c)
add_library(trajectory_selector SHARED src/trajectory_selector.c
    src/generateAbortTrajectory.c)
add_library(state_estimator SHARED src/state_estimator.c)
add_library(vesc_communication SHARED src/vesc_communication.c
    submodules/bldc_uart_comm_stm32f4_discovery/bldc_interface_uart.c
    submodules/bldc_uart_comm_stm32f4_discovery/packet.c
    submodules/bldc_uart_comm_stm32f4_discovery/crc.c
    submodules/bldc_uart_comm_stm32f4_discovery/bldc_interface.c
    submodules/bldc_uart_comm_stm32f4_discovery/buffer.c)
add_library(kalman_filter SHARED src/kalman_filter.c)
add_library(pid_speed SHARED src/pid_speed_controller.c)
target_include_directories(vesc_communication PRIVATE src/include/ChibiOS)

