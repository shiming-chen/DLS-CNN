% In this file, we densely extract the feature
% We extract feature from 256,256 image and mirrored image.
% -----Please change the file path in this script. ----
clear;
addpath ..;
netStruct = load('../data/icdar2013_patches256_drop0.5_B128_LR0.1/net-epoch-55.mat');
%--------add L2-norm
net = dagnn.DagNN.loadobj(netStruct.net);
net.addLayer('lrn_test',dagnn.LRN('param',[4096,0,1,0.5]),{'pool5'},{'fc1n'},{});
clear netStruct;
net.mode = 'test';
net.move('gpu') ;
net.conserveMemory = true;
im_mean = net.meta(1).normalization.averageImage;
%im_mean = imresize(im_mean,[224,224]);
p = dir('/home/lab535-user1/chenshm/Writer_Ident/data/ICDAR2013/icdar2013_test_Line/icdar2013_test_all_Line_patches256_new/*jpg');
ff = [];
%------------------------------
for i = 1:200:numel(p)
    disp(i);
    oim = [];
    str=[];
    for j=1:min(200,numel(p)-i+1)
        str = strcat('/home/lab535-user1/chenshm/Writer_Ident/data/ICDAR2013/icdar2013_test_Line/icdar2013_test_all_Line_patches256_new/',p(i+j-1).name);
        %imt = imresize(imread(str),[256,256]);
	imt=imread(str);
        oim = cat(4,oim,imt);
    end
    f = getFeature2(net,oim,im_mean,'data','fc1n');
    f = sum(sum(f,1),2);
    f2 = getFeature2(net,fliplr(oim),im_mean,'data','fc1n');
    f2 = sum(sum(f2,1),2);
    f = f+f2;
    size4 = size(f,4);
    f = reshape(f,[],size4)';
    s = sqrt(sum(f.^2,2));
    dim = size(f,2);
    s = repmat(s,1,dim);
    f = f./s;
    ff = cat(1,ff,f);
end
save('../test/icdar2013_all_pool5_patches256.mat','ff','-v7.3');
%}



