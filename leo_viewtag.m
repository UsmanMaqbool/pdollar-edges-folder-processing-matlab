% Demo for Edge Boxes (please see readme.txt first).
addpath(genpath('.'));
close all;
clear
dbstop if error;
close all;
clc;
clear mex;


%% load pre-trained edge detection model and set opts (see edgesDemo.m)

model=load('models/forest/modelBsds'); model=model.model;
model.opts.multiscale=0; model.opts.sharpen=2; model.opts.nThreads=4;
sav_dir = "output/";
%% set up opts for edgeBoxes (see edgeBoxes.m)
opts = edgeBoxes;
opts.alpha = .85;     % step size of sliding window search0.65
opts.beta  = .8;     % nms threshold for object proposals0.75
opts.minScore = .01;  % min score of boxes to detect
opts.maxBoxes = 200;  % max number of boxes to detect 1e4

%% detect Edge Box bounding box proposals (see edgeBoxes.m)
% Take two images (left image and right image)
I = imread('/home/leo/docker_ws/datasets/tinyTimeMachine/images/5z/5zMriAHoEUJ4FapNGZeEMw/_200909/5zMriAHoEUJ4FapNGZeEMw__200909_35.657311_139.687461_000_012.jpg');

% Calculate object boxes
[bboxes, E] =edgeBoxes(I,model);
figure; imshow(E)


e8u_norml_values = norml_values(E,1);
BW = im2bw(e8u_norml_values,0.5);

sparse_edges = sparse(BW);

e8u_c1 = e8u_norml_values;
e8u_c1(e8u_c1>.33)  = 0;
e8u_c1 = norml_values(e8u_c1,1);

BW_c1 = im2bw(e8u_c1,0.5);

e8u_c2 = e8u_norml_values;
e8u_c2(e8u_c2<.33)  = 0;
e8u_c2(e8u_c2>.66)  = 0;
e8u_c2 = norml_values(e8u_c2,1);

BW_c2 = im2bw(e8u_c2,0.5);

e8u_c3 = e8u_norml_values;
e8u_c1(e8u_c1<.66)  = 0;
e8u_c3 = norml_values(e8u_c3,1);

BW_c3 = im2bw(e8u_c3,0.5);


sparse_edges_c1 = sparse(BW_c1);
sparse_edges_c2 = sparse(BW_c2);
sparse_edges_c3 = sparse(BW_c3);


e8u_sparse = cat(3,e8u_c1,e8u_c2,e8u_c2);

BW_sparse = cat(3,BW_c1,BW_c2,BW_c3);

%saving sparse matrix
%[row col v] = find(sparse_edges_c1);
%dlmwrite('sparse_edges_c1.dat',[col row v], 'delimiter', '\t')

%Saving method
save('sparse_edges.mat','sparse_edges_c1','sparse_edges_c2','sparse_edges_c3');
% sparse_e8ue = cat(3,sparse_edges_c1,sparse_edges_c2,sparse_edges_c3);
load_sparse_edges = load('sparse_edges.mat');
load_sparse_edges_c1 = load_sparse_edges.sparse_edges_c1;
load_sparse_edges_c2 = load_sparse_edges.sparse_edges_c2;
load_sparse_edges_c3 = load_sparse_edges.sparse_edges_c3;

c1_mat = full(load_sparse_edges_c1);
c2_mat = full(load_sparse_edges_c2);
c3_mat = full(load_sparse_edges_c3);

c1_mat_255 = uint8(c1_mat)* 85;
c2_mat_255 = uint8(c2_mat)* 170;
c3_mat_255 = uint8(c3_mat)* 255;


mat_255 = c1_mat_255+c2_mat_255+c3_mat_255;
figure; imshow(mat_255)
imwrite(mat_255,'apg.jpg')
function y = norml_values(xx,max_value)
    
    min1=min(xx(:));
    max1=max(xx(:));
    y=((xx-min1).*max_value)./(max1-min1);

end

%figure, imshow(BW)
%figure, imshow(sparse_edges)



%test_enc = encode_edges(e8u);

%save_edge('save_edge.txt', e8u);
