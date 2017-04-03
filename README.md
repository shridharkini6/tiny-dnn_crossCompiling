# tiny-dnn_crossCompiling
Effective guide to cross compile Tiny-DNN for ARM boards

tiny-dnn is a C++11 implementation of deep learning. It is suitable for deep learning on limited computational resource, embedded systems and IoT devices.

For More info: https://github.com/tiny-dnn/tiny-dnn

If you have caffe's .prototxt and .caffemodal, then you probably need protobuf cross compiled on ARM architecture.
For More info: https://github.com/google/protobuf

Here is a simple script file which gets all the necessery package and cross compiles it to ARM arch which has Hard Floating units(arm-gnueabihf). If you dont have Hard Floating, remove hf from the script.

Script is self explanatory.
