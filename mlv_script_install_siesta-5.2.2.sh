#!/bin/bash
#=========================================================================#
# Script: Install recent siesta  using cmake                              #
#                  Dr. Mohan L Verma                                      #
#                  Computational Nanomaterials Research Lab,              #
#                  Department Of Applied Physics, SSTC-SSGI               # 
#                  Junwani, Bhilai (Chhattisgarh)  INDIA                  # 
# run this script by using the command :                                  #
# $chmod +x mlv_script_install_siesta-5.2.2                              #
# $ ./mlv_script_install_siesta-5.2.2                                     #
# make sure your internet connectivity is proper during this script run.  #
#=========================================================================#
# This script has been tested on ubuntu22.04. This will install  siesta-5.2.0 version.

start=`date +%s` 

sudo apt-get update
sudo apt-get install make
sudo apt-get install cmake
sudo apt-get install m4
sudo apt-get install gcc
sudo apt-get install g++
sudo apt-get install gfortran
sudo apt install git
sudo apt install pkg-config
sudo apt install libxc9
sudo apt install libxc-dev
sudo apt install libopenmpi-dev liblapack-dev libscalapack-openmpi-dev libnetcdff-dev
sudo apt install libreadline-dev
sudo apt install lua-readline
sudo apt install lua-readline-dev
sudo apt install libnetcdf-mpi-dev
sudo apt install libnetcdff-dev
sudo apt install libfftw3-dev
sudo apt install libfftw3-mpi-dev
sudo apt install python3-dev
sudo apt install libopenblas-dev 
sudo apt install --reinstall libscalapack-mpi-dev libscalapack-openmpi-dev

# Then clone the master SIESTA repository 

 wget  https://gitlab.com/siesta-project/siesta/-/releases/5.2.2/downloads/siesta-5.2.2.tar.gz
tar -xzvf siesta-5.2.2.tar.gz
 cd siesta-5.2.2 
  

# Export the variable to dowload the latest version of WANNIER90

 export WANNIER90_PACKAGE=https://github.com/wannier-developers/wannier90/archive/v3.1.0.tar.gz

# Create the directory where SIESTA will be installed.
 
# Create a build directory
mkdir build
cd build

 
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/siesta-5.2.2 \
    -DSIESTA_USE_MPI=ON \
    -DSIESTA_USE_NETCDF=ON \
    -DSIESTA_USE_OPENMP=ON \
    -DCMAKE_C_COMPILER=mpicc \
    -DCMAKE_Fortran_COMPILER=mpif90 \
    -DSCALAPACK_LIBRARY="/usr/lib/x86_64-linux-gnu/libscalapack-openmpi.so"

# And finally Install SIESTA

make -j$(nproc)
make install

# Clean-up the mess
 cd ..
 rm -rf _build

#The executable and all the utilities will be available in:

$HOME/siesta-5.2.2/bin

#And the required libraries (and include directories) are available in

$HOME/siesta-5.2.2/lib
$HOME/siesta-5.2.2/include

#If this directory $HOME/siesta/bin is included in your $PATH, then just typing 

#sudo ln -s $HOME/siesta-5.2.2/bin/* /usr/local/bin/

end=`date +%s`
echo Execution time was `expr $end - $start` seconds.

