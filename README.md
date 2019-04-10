# A-Robust-Off-line-Writer-Identification-Method(DLS-CNN)



###  Main Contributions:
We propose a robust off-line writer identification (DLS-CNN),which can extract the robust local features effectively, so it achieved higher identification rate with few handwritten contents, as well as achieves better retrieval result without depending on data augmentation and global encoding. It achieved exciting performance on  [ICDAR2013](https://cvl.tuwien.ac.at/research/cvl-databases/an-off-line-database-for-writer-retrieval-writer-identification-and-word-spotting/) and  [CVL](http://rrc.cvc.uab.es/) benchmark datasets.

## 1.Dependences 
- Matlab, Matconvnet, Opencv, NVIDIA GPU
- **(Note that I have included my Matconvnet in https://github.com/KiM55/Writer-Identification-WLSR, you should download and compile it. I has changed some codes comparing with the original version. For example, one of the difference is in `/matlab/+dagnn/@DagNN/initParams.m`. If one layer has params, I will not initialize it again, especially for pretrained model.)**

	You just need to uncomment and modify some lines in `compile.m` and run it in Matlab. Try it~
	(The code does not support cudnn 6.0. You may just turn off the Enablecudnn or try cudnn5.1)

	If you fail in compilation, you may refer to http://www.vlfeat.org/matconvnet/install/

## 2.Line Segmentation
This process will accurately segment the image to line.
### Usage
```Console
mkdir build
cd build
cmake ..
make
./Image2Lines the_path_to_the_img
```


## 3.The improved ResNet
In order to make ResNet-50 model adapt to writer identification,we take some improvements for ResNet:
1. The global pool take place of average pool.
2. Add a relu layer and dropout layer.
### Usage
#### Train
1. Make a dir called `data` by typing `mkdir ./data`.

2. Download [ResNet-50 model](http://www.vlfeat.org/matconvnet/models/imagenet-resnet-50-dag.mat) pretrained on Imagenet. Put it in the `data` dir. 

3. Add your dataset path into `prepare_data.m` and run it. Make sure the code outputs the right image path.
4. Run `train_id_net_res_market_new.m` for training. 
#### Feature extraction
 Run `test.m` in  the `test` dir for feature extraction.
 
