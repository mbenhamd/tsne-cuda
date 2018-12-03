export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
git submodule init
git submodule update 
cd ./build
cmake  .. -DBUILD_PYTHON=ON -DWITH_MKL=ON -DCMAKE_C_COMPILER=gcc-6 -DCMAKE_CXX_COMPILER=g++-6
pwd
make -j $grep -c ^processor /proc/cpuinfo)
make
cd python/
pwd
sudo python setup.py install --single-version-externally-managed --record=record.txt
sudo cp -r ../lib/* /lib/
