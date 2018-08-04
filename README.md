# A-Robust-Off-line-Writer-Identification-Method(DLS-CNN)
A method about writer identification with robust local features
![](https://github.com/KiM55/A-Robust-Off-line-Writer-Identification-Method/blob/master/Images/model1.png)

###  Main Contributions:
We propose a robust off-line writer identification (DLS-CNN),which can extract the robust local features effectively, so it achieved higher identification rate with few written contents, as well as achieves better retrieval result without depending on data augmentation and global encoding. It achieved exciting performance on  [ICDAR2013](https://cvl.tuwien.ac.at/research/cvl-databases/an-off-line-database-for-writer-retrieval-writer-identification-and-word-spotting/) and  [CVL](http://rrc.cvc.uab.es/) benchmark datasets.


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
### Usage
#### Train
1. Make a dir called `data` by typing `mkdir ./data`.

2. Download [ResNet-50 model](http://www.vlfeat.org/matconvnet/models/imagenet-resnet-50-dag.mat) pretrained on Imagenet. Put it in the `data` dir. 

3. Add your dataset path into `prepare_data.m` and run it. Make sure the code outputs the right image path.
4. Run `train_id_net_res_market_new.m`. 
#### Feature extraction
 Run `test.m` in  the `test` dir.
 
