# A-Robust-Off-line-Writer-Identification-Method(DLS-CNN)
A method about writer identification with robust local features


##  Main Contributions:
### We proposed a robust off-line writer identification (DLS-CNN),which can extract the robust local features effectively, so it achieves higher identification rate with few written contents, as well as achieves better retrieval result without depending on data augmentation and global encoding. It achieve exciting performance on ICDAR2013 and CVL benchmark datasets.


# 1.Line Segmentation
This process will segment the image to line.
## Usage
```Console
mkdir build
cd build
cmake ..
make
./Image2Lines the_path_to_the_img
```
