# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.17

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Disable VCS-based implicit rules.
% : %,v


# Disable VCS-based implicit rules.
% : RCS/%


# Disable VCS-based implicit rules.
% : RCS/%,v


# Disable VCS-based implicit rules.
% : SCCS/s.%


# Disable VCS-based implicit rules.
% : s.%


.SUFFIXES: .hpux_make_needs_suffix_list


# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /Applications/CLion.app/Contents/bin/cmake/mac/bin/cmake

# The command to remove a file.
RM = /Applications/CLion.app/Contents/bin/cmake/mac/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/toomanyquestions/Desktop/2_курс/Архитектура_Вычислительных_Систем/HSE-FASM/MultithreadedApplication/code

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/toomanyquestions/Desktop/2_курс/Архитектура_Вычислительных_Систем/HSE-FASM/MultithreadedApplication/code/cmake-build-debug

# Include any dependencies generated for this target.
include CMakeFiles/Multithreaded_application.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/Multithreaded_application.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/Multithreaded_application.dir/flags.make

CMakeFiles/Multithreaded_application.dir/main.cpp.o: CMakeFiles/Multithreaded_application.dir/flags.make
CMakeFiles/Multithreaded_application.dir/main.cpp.o: ../main.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/toomanyquestions/Desktop/2_курс/Архитектура_Вычислительных_Систем/HSE-FASM/MultithreadedApplication/code/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/Multithreaded_application.dir/main.cpp.o"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/Multithreaded_application.dir/main.cpp.o -c /Users/toomanyquestions/Desktop/2_курс/Архитектура_Вычислительных_Систем/HSE-FASM/MultithreadedApplication/code/main.cpp

CMakeFiles/Multithreaded_application.dir/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/Multithreaded_application.dir/main.cpp.i"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/toomanyquestions/Desktop/2_курс/Архитектура_Вычислительных_Систем/HSE-FASM/MultithreadedApplication/code/main.cpp > CMakeFiles/Multithreaded_application.dir/main.cpp.i

CMakeFiles/Multithreaded_application.dir/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/Multithreaded_application.dir/main.cpp.s"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/toomanyquestions/Desktop/2_курс/Архитектура_Вычислительных_Систем/HSE-FASM/MultithreadedApplication/code/main.cpp -o CMakeFiles/Multithreaded_application.dir/main.cpp.s

# Object files for target Multithreaded_application
Multithreaded_application_OBJECTS = \
"CMakeFiles/Multithreaded_application.dir/main.cpp.o"

# External object files for target Multithreaded_application
Multithreaded_application_EXTERNAL_OBJECTS =

Multithreaded_application: CMakeFiles/Multithreaded_application.dir/main.cpp.o
Multithreaded_application: CMakeFiles/Multithreaded_application.dir/build.make
Multithreaded_application: CMakeFiles/Multithreaded_application.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/toomanyquestions/Desktop/2_курс/Архитектура_Вычислительных_Систем/HSE-FASM/MultithreadedApplication/code/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable Multithreaded_application"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/Multithreaded_application.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/Multithreaded_application.dir/build: Multithreaded_application

.PHONY : CMakeFiles/Multithreaded_application.dir/build

CMakeFiles/Multithreaded_application.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/Multithreaded_application.dir/cmake_clean.cmake
.PHONY : CMakeFiles/Multithreaded_application.dir/clean

CMakeFiles/Multithreaded_application.dir/depend:
	cd /Users/toomanyquestions/Desktop/2_курс/Архитектура_Вычислительных_Систем/HSE-FASM/MultithreadedApplication/code/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/toomanyquestions/Desktop/2_курс/Архитектура_Вычислительных_Систем/HSE-FASM/MultithreadedApplication/code /Users/toomanyquestions/Desktop/2_курс/Архитектура_Вычислительных_Систем/HSE-FASM/MultithreadedApplication/code /Users/toomanyquestions/Desktop/2_курс/Архитектура_Вычислительных_Систем/HSE-FASM/MultithreadedApplication/code/cmake-build-debug /Users/toomanyquestions/Desktop/2_курс/Архитектура_Вычислительных_Систем/HSE-FASM/MultithreadedApplication/code/cmake-build-debug /Users/toomanyquestions/Desktop/2_курс/Архитектура_Вычислительных_Систем/HSE-FASM/MultithreadedApplication/code/cmake-build-debug/CMakeFiles/Multithreaded_application.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/Multithreaded_application.dir/depend
