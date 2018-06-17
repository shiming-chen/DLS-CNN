# A-Robust-Off-line-Writer-Identification-Method(DLS-CNN)
A method about writer identification with robust local features
![](https://github.com/KiM55/A-Robust-Off-line-Writer-Identification-Method/blob/master/Images/%E6%A8%A1%E5%9E%8B%E7%BB%93%E6%9E%84%E5%9B%BE.png)

###  Main Contributions:
We proposed a robust off-line writer identification (DLS-CNN),which can extract the robust local features effectively, so it achieves higher identification rate with few written contents, as well as achieves better retrieval result without depending on data augmentation and global encoding. It achieve exciting performance on ICDAR2013 and CVL benchmark datasets.


## 1.Line Segmentation
This process will accurately segment the image to line.
### Usage
```Console
mkdir build
cd build
cmake ..
make
./Image2Lines the_path_to_the_img
```


## 2.The improved ResNet
In order to make ResNet-50 model adapt to writer identification,we take some improvements for ResNet:
1. The global pool take place of average pool.
2. Add a relu layer and dropout layer.
