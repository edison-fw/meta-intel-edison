cmake_minimum_required(VERSION 3.10)

project(battery-voltage C)

# Set compiler flags for GCC
if (CMAKE_COMPILER_IS_GNUCC)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DIIO_CHECK_RET")
endif ()

# Add the executable
add_executable(battery-voltage battery-voltage.c)

# Link the executable with the libiio library
target_link_libraries(battery-voltage iio)

# Set C standard properties
set_target_properties(battery-voltage PROPERTIES
    C_STANDARD 99
    C_STANDARD_REQUIRED ON
    C_EXTENSIONS OFF
)

# Install rules for the executable
install(TARGETS battery-voltage
    RUNTIME DESTINATION bin         # For executable programs
    COMPONENT battery-voltage        # Optional: component grouping
)
