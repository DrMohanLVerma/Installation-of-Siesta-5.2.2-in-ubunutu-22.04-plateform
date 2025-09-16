#!/bin/bash
#=========================================================================#
# Script: Install Siesta 5.4.0 using CMake                                #
# Author: Dr. Mohan L Verma                                               #
# Institution: SSTC, Bhilai, INDIA                                        #
# Date: June 2025                                                         #
#=========================================================================#

start=$(date +%s)

echo "Updating system and installing dependencies..."
sudo apt-get update
sudo apt-get install -y make cmake m4 gcc g++ gfortran git pkg-config \
    libxc9 libxc-dev libopenmpi-dev liblapack-dev libscalapack-openmpi-dev \
    libnetcdff-dev libreadline-dev lua-readline lua-readline-dev \
    libnetcdf-mpi-dev libfftw3-dev libfftw3-mpi-dev python3-dev libopenblas-dev

# Download Siesta 5.4.0
echo "Downloading Siesta 5.4.0..."
wget https://gitlab.com/siesta-project/siesta/-/archive/5.4.0/siesta-5.4.0.tar.gz || { echo "Download failed!"; exit 1; }

tar -xzf siesta-5.4.0.tar.gz
cd siesta-5.4.0 || { echo "Extraction failed!"; exit 1; }

# Export Wannier90 URL
export WANNIER90_PACKAGE=https://github.com/wannier-developers/wannier90/archive/v3.1.0.tar.gz

# Create build directory
mkdir build && cd build

echo "Running CMake configuration..."
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/siesta-5.4.0 \
    -DSIESTA_USE_MPI=ON \
    -DSIESTA_USE_NETCDF=ON \
    -DSIESTA_USE_OPENMP=ON \
    -DCMAKE_C_COMPILER=mpicc \
    -DCMAKE_Fortran_COMPILER=mpif90 \
    -DSCALAPACK_LIBRARY="/usr/lib/x86_64-linux-gnu/libscalapack-openmpi.so" || { echo "CMake failed!"; exit 1; }

echo "Compiling Siesta..."
make -j$(nproc) || { echo "Compilation failed!"; exit 1; }

echo "Installing Siesta..."
make install || { echo "Installation failed!"; exit 1; }

# Optional: Symlink to /usr/local/bin
sudo ln -s $HOME/siesta-5.4.0/bin/* /usr/local/bin/

# Optional: Update PATH in .bashrc
if ! grep -q 'siesta-5.4.0/bin' ~/.bashrc; then
    echo 'export PATH=$HOME/siesta-5.4.0/bin:$PATH' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=$HOME/siesta-5.4.0/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
    echo "Environment variables added to ~/.bashrc. Please run 'source ~/.bashrc'."
fi

# Clean up
cd ..
rm -rf siesta-5.4.0.tar.gz

end=$(date +%s)
echo "SIESTA 5.4.0 installed successfully!"
echo "Total execution time: $((end - start)) seconds."

