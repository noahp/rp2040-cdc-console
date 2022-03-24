# Preload.cmake is undocumented, but let's use it to set Ninja as the backend
# https://gitlab.kitware.com/cmake/cmake/-/issues/17231
set(CMAKE_GENERATOR "Ninja")
