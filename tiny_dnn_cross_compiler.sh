

cd $HOME/Downloads

sudo apt-get install git wget

#followed from thi blog https://www.acmesystems.it/arm9_toolchain
sudo apt-get install libc6-armel-cross libc6-dev-armel-cross
sudo apt-get install binutils-arm-linux-gnueabi
sudo apt-get install libncurses5-dev

#hf stands for hardware floating units presence in ARM
#if no hf present in ARM chip remove hf here after.
sudo apt-get install gcc-arm-linux-gnueabihf
sudo apt-get install g++-arm-linux-gnueabihf
#------------------------------------------------------------#

#Let us cross compile Protobuf now
#first create a directory where we can store compiled protobuf for ARM as well as x86_64
mkdir compiled_protobuf
mkdir compiled_protobuf/ARM
#clone the protobuf repo from git
git clone https://github.com/google/protobuf.git
cd protobuf
git checkout v3.2.0  #checkout to stable build
#install what protobuf needs...https://github.com/google/protobuf/blob/master/src/README.md
sudo apt-get install autoconf automake libtool curl make g++ unzip
#generate the configure script
./autogen.sh
#create configure script with proper prefix where it installs library,and executable for x86_64
./configure --prefix=$HOME/compiled_protobuf
make
make install
#the protoc available in $HOME/compiled_protobuf/bin can be used against any .proto files to generate pb.cc and pb.h files in x86_64 and $HOME/compiled_protobuf/lib holds the static and shared library and $HOME/compiled_protobuf/include holds the include header files

#now create executable and library from ARM
make clean
make distclean
./configure --build=x86_64-linux-gnu --host=arm-linux-gnueabihf CC=arm-linux-gnueabihf-gcc CXX=arm-linux-gnueabihf-g++ --with-protoc=$HOME/compiled_protobuf/bin/protoc --prefix=$HOME/compiled_protobuf/ARM
#to understand what is host and build, please reffer http://stackoverflow.com/questions/5139403/whats-the-difference-of-configure-option-build-host-and-target
make
make install
#the protoc available in $HOME/compiled_protobuf/ARM/bin can be used against any .proto files to generate pb.cc and pb.h files in ARM and $HOME/compiled_protobuf/ARM/lib holds the static and shared library and $HOME/compiled_protobuf/ARM/include holds the include header files
#use $HOME/compiled_protobuf/ARM/lib while cross compiling 
#-------------------------------------------------------------------#

#lets create .pb.cc and .pb.h from .proto available in tiny-dnn
#clone the tiny dnn repo
cd $HOME/Downloads
git clone https://github.com/tiny-dnn/tiny-dnn.git
cd tiny-dnn/tiny_dnn/io/caffe
$HOME/compiled_protobuf/bin/protoc caffe.proto --cpp_out=./
#this creates those two files which can be used against cross compilation.
#-------------------------------------------------------------------#
#HOW TO CROSS COMPILE caffe_converter present in examples/caffe_converter/
#$arm-linux-gnueabihf-g++ -std=c++11 -I$HOME/tiny-dnn/tiny_dnn/io/caffe -I$HOME/tiny-dnn -I$HOME/compiled_protobuf/include -DDNN_USE_IMAGE_API -o caffe_converter caffe_converter.cpp $HOME/tiny-dnn/tiny_dnn/io/caffe/caffe.pb.cc -pthread -L$HOME/compiled_protobuf/ARM/lib -lprotobuf
