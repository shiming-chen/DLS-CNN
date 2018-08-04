clc;clear all;close all;
addpath ../test
addpath ..
addpath CM_Curve

%net.conserveMemory = false;


%% add necessary paths
query_dir = '/home/lab535-user1/chenshm/Writer_Ident/data/ICDAR2013/icdar2013_test_Line/icdar2013_all/';% query directory
test_dir = '/home/lab535-user1/chenshm/Writer_Ident/data/ICDAR2013/icdar2013_test_Line/icdar2013_test_all_Line_patches64_new/';% database directory

%% calculate query features
% Hist_query = importdata('../test/HistoricalWI_bianry_resnet_query_new2.mat')';
% nQuery = size(Hist_query, 2);
%nQuery=3600;
%% calculate database features
Hist_test = importdata('../test/icdar2013_all_pool5_patches64_drop0.5_B64.mat')';

%pca 
Hist_test=Hist_test' ;
[COEFF,SCORE,latent,tsquare] = pca(Hist_test);
latent1=latent;
latent1=sqrt(latent1);
A=length(latent);
sum1=0;
for i=1:A
   sum1=sum1+latent(i);
   SCORE(:,i)=SCORE(:,i)/latent1(i);
end
latent=100*latent/sum1;
percent_threshold=99;           
percents=0;                          
for n=1:A
    percents=percents+latent(n);
    if percents>percent_threshold
        break;
    end
end
Hist_test=SCORE(:,1:n);
Hist_test=Hist_test' ;


nTest = size(Hist_test, 2);
nTest1 = size(Hist_test, 1);

%% calculate the ID and camera for database images
%mkdir('./data')
test_files = dir([test_dir '*.jpg']);
testID = zeros(length(test_files), 1);
testCAM = zeros(length(test_files), 1);
if ~exist('data_pool5/testID_new.mat')
    for n = 1:length(test_files)
        img_name = test_files(n).name;
	C1 = strsplit(img_name,{'_'});
        testID(n) = str2double(cell2mat(C1(1)));
	testCAM(n)=str2double(cell2mat(C1(2)));
        % if strcmp(img_name(1), '-') % junk images
            % testID(n) = -1;
            % testCAM(n) = str2num(img_name(5));
        % else
            % %img_name
            % testID(n) = str2num(img_name(1:4));
            % testCAM(n) = str2num(img_name(7));
        % end
    end
    save('data_pool5/testID_new.mat', 'testID');
    save('data_pool5/testCAM.mat', 'testCAM');
else
    testID = importdata('data_pool5/testID_new.mat');
    testCAM = importdata('datapool5/testCAM.mat');    
end

%% calculate the ID and camera for query images
query_files = dir([query_dir '*.tif']);
queryID = zeros(length(query_files), 1);
nQuery=length(query_files);
rank_size = nQuery;

queryCAM = zeros(length(query_files), 1);
if ~exist('data_pool5/queryID_new.mat')
    for n = 1:length(query_files)
        img_name = query_files(n).name;
        C1 = strsplit(img_name,{'_','.'});
        queryID(n) = str2double(cell2mat(C1(1)));
	queryCAM(n)= str2double(cell2mat(C1(2)));
        % if strcmp(img_name(1), '-') % junk images
            % queryID(n) = -1;
            % queryCAM(n) = str2num(img_name(5));
        % else
            % queryID(n) = str2num(img_name(1:4));
            % queryCAM(n) = str2num(img_name(7));
        % end
    end
    save('data_pool5/queryID_new.mat', 'queryID');
    save('data_pool5/queryCAM.mat', 'queryCAM');
else
    queryID = importdata('data_pool5/queryID_new.mat');
    queryCAM = importdata('data_pool5/queryCAM.mat');    
end

%% search the database and calcuate re-id accuracy
ap = zeros(nQuery, 1); % average precision
ap_max_rerank  = zeros(nQuery, 1); % average precision with MultiQ_max + re-ranking 
ap_pairwise = zeros(nQuery, 4); % pairwise average precision with single query (see Fig. 7 in the paper)

hard=zeros(nQuery, rank_size);
CMC = zeros(nQuery, rank_size);
CMC_max_rerank = zeros(nQuery, rank_size);

r1 = 0; % rank 1 precision with single query
r1_max_rerank = 0; % rank 1 precision with MultiQ_max + re-ranking
r1_pairwise = zeros(nQuery, 5);% pairwise rank 1 precision with single query (see Fig. 7 in the paper)

% dist3600_3600=sqdist(Hist_test,Hist_test);
% dist = sqdist(Hist_test, Hist_query); % distance calculate with single query. Note that Euclidean distance is equivalent to cosine distance if vectors are l2-normalized
%dist_cos_max = (2-dist_max)./2; % cosine distance with MultiQ_max, used for re-ranking

knn = 1; % number of expanded queries. knn = 1 yields best result
%queryCam = importdata('data/queryCAM_duke.mat'); % camera ID for each query
%testCam = importdata('data/testCAM_duke.mat'); % camera ID for each database image
%true_image=zeros(5,nQuery);
rank_index=zeros(rank_size,nQuery);
f=[];
numbers = zeros(nQuery, 1);

%feature encoding
for k = 1:nQuery
     junk_index2 = intersect(find(testID == queryID(k)), find(testCAM == queryCAM(k)));
     number_patches=length(junk_index2);
     sum=zeros(nTest1,1);
     %sum=[];
     save('data_pool5/junk_index2.mat', 'junk_index2');
     for i=1:number_patches
	j=junk_index2(i);
	fff=Hist_test(:,j);
	save('data_pool5/fff.mat', 'fff');
	sum=sum+fff;
	%sum=cat(1,sum,fff);
	%save('data/sum.mat', 'sum');
     end
     sum=sum/number_patches;
     f=cat(2,f,sum);
     numbers(k)=number_patches;
     %save('data_pool5/numbers.mat', 'numbers');
end
save('data_pool5/f.mat', 'f');
dist=sqdist(f,f);
save('data_pool5/dist.mat', 'dist');
for k = 1:nQuery
    good_index = find(queryID == queryID(k));
    % junk_index1 = find(testID == -1);% images neither good nor bad in terms of bbox quality
    % junk_index2 = intersect(find(testID == queryID(k)), find(testCAM == queryCAM(k))); % images with the same ID and the same camera as the query
    % junk_index = [junk_index1; junk_index2]';
    score = dist(:, k);
    %score_avg = dist_avg(:, k); 
    %score_max = dist_max(:, k);
    
    % sort database images according Euclidean distance
    [~, index] = sort(score, 'ascend');  % single query
     
    
    % re-rank  select rank_size=1000 index
    index = index(1:rank_size);    
    %true_image(:,k)=good_index;
    rank_index(:,k)=index;
     %save('data/true_image.mat', 'true_image');
     save('data_pool5/rank_index.mat', 'rank_index');
    [ap(k), CMC(k, :),hard(k,:)] = compute_AP_rerank(good_index,index);% compute AP for single query
    %ap_pairwise(k, :) = compute_AP_multiCam(good_index, junk_index1,junk_index2, index, queryCAM(k), testCAM); % compute pairwise AP for single query
    fprintf('%d::%f\n',k,ap(k));
    %%%%%%%%%%% calculate pairwise r1 precision %%%%%%%%%%%%%%%%%%%%
    %r1_pairwise(k, :) = compute_r1_multiCam(good_index, junk_index1,junk_index2, index, queryCAM(k), testCAM); % pairwise rank 1 precision with single query
    %%%%%%%%%%%%%% calculate r1 precision %%%%%%%%%%%%%%%%%%%%
end
CMC = mean(CMC);
hard=mean(hard);
%% print result
fprintf('single query:                                    mAP = %f, r1 precision = %f,hard-2=%f\r\n', mean(ap), CMC(2),hard(3));
%[ap_CM, r1_CM] = draw_confusion_matrix(ap_pairwise, r1_pairwise, queryCam);
%fprintf('average of confusion matrix with single query:  mAP = %f, r1 precision = %f\r\n', (sum(ap_CM(:))-sum(diag(ap_CM)))/30, (sum(r1_CM(:))-sum(diag(r1_CM)))/30);
save('data_pool5/CMC1.mat', 'CMC');
save('data_pool5/hard.mat', 'hard');

%% plot CMC curves
%figure;
%s = 10;
%CMC_curve = CMC ;
%plot(1:s, CMC_curve(:, 1:s));
