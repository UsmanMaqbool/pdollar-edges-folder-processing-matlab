clc;
clear all;
% Dataset_path = "/home/leo/docker_ws/datasets/247_Tokyo_GSV ";
% Save_path = "/home/leo/docker_ws/datasets/NetvLad/247_Tokyo_GSV_grey";
% Save_path_vt = "/home/leo/docker_ws/datasets/NetvLad/247_Tokyo_GSV_grey_vt";
% Save_path_vt_3 = "/home/leo/docker_ws/datasets/NetvLad/247_Tokyo_GSV_grey_vt_3";
% Save_path_vt_rgb = "/home/leo/docker_ws/datasets/NetvLad/247_Tokyo_GSV_grey_vt_rgb";


Dataset_path = "/home/leo/docker_ws/datasets/Pittsburgh-all";
Save_path = "/home/leo/docker_ws/datasets/NetvLad/Pittsburgh-all_grey";
Save_path_vt = "/home/leo/docker_ws/datasets/NetvLad/Pittsburgh-all_grey_vt";
Save_path_vt_3 = "/home/leo/docker_ws/datasets/NetvLad/Pittsburgh-all_grey_vt_3";
Save_path_vt_rgb = "/home/leo/docker_ws/datasets/NetvLad/Pittsburgh-all_grey_vt_rgb";


%% load pre-trained edge detection model and set opts (see edgesDemo.m)

model=load('models/forest/modelBsds'); model=model.model;
model.opts.multiscale=0; model.opts.sharpen=2; model.opts.nThreads=4;

%% set up opts for edgeBoxes (see edgeBoxes.m)
opts = edgeBoxes;
opts.alpha = .85;     % step size of sliding window search0.65
opts.beta  = .8;     % nms threshold for object proposals0.75
opts.minScore = .01;  % min score of boxes to detect
opts.maxBoxes = 200;  % max number of boxes to detect 1e4

%%

% fn = getfn(Dataset_path, 'jpg$');
filelist = dir(fullfile(Dataset_path, '**/*.jpg'));  %get list of files and folders in any subfolder
fn = filelist(~[filelist.isdir]);  %remove folders from list
for i = 1:length(fn) %76227
    file_name = append(fn(i).folder,"/",fn(i).name); 
    file_path = regexprep(fn(i).folder,Dataset_path,'','ignorecase');
    new_filePath = Save_path + file_path; %filepath is between savepath (might need to create the directories)
    
    I = imread(file_name);
    
    [bboxes, E] =edgeBoxes(I,model);
    results = uint8(E * 255);
    
 %% Save the original edge image
    if exist(new_filePath, 'dir')==0
      mkdir(new_filePath)
    end
    new_filePath = append(new_filePath,"/",fn(i).name);
    imwrite(results, new_filePath)
    query_display = sprintf('%d out of %d is done so far %% %f',i,length(fn), i/length(fn)*100);
    disp(query_display)
    
%% Create View Tags
    
% Create Edge VT
    e8u_norml_values = norml_values_strict(E,1,0,1);

    e8u_c1 = e8u_norml_values;
    e8u_c1(e8u_c1>.33)  = 0;
    e8u_c1 = norml_values_strict(e8u_c1,1,0,0.33);

    BW_c1 = im2bw(e8u_c1,0.5);

    e8u_c2 = e8u_norml_values;
    e8u_c2(e8u_c2<.33)  = 0;
    e8u_c2(e8u_c2>.66)  = 0;
    e8u_c2 = norml_values_strict(e8u_c2,1,0.33,0.66);

    BW_c2 = im2bw(e8u_c2,0.5);

    e8u_c3 = e8u_norml_values;
    e8u_c1(e8u_c1<.66)  = 0;
    e8u_c3 = norml_values_strict(e8u_c3,1,.66,1);

    BW_c3 = im2bw(e8u_c3,0.5);

    sparse_edges_c1 = sparse(BW_c1);
    sparse_edges_c2 = sparse(BW_c2);
    sparse_edges_c3 = sparse(BW_c3);

    
    vt_filePath = Save_path_vt + file_path;
    % Save the original edge image
    if exist(vt_filePath, 'dir')==0
      mkdir(vt_filePath)
    end
    
    [folder, baseFileName, extension] = fileparts(fn(i).name);
    % Ignore extension and replace it with .txt
    vt_file_name = sprintf('%s.mat', baseFileName);
    vt_filePaths = append(vt_filePath,"/",vt_file_name);
    %Saving method
    save(vt_filePaths,'sparse_edges_c1','sparse_edges_c2','sparse_edges_c3');

    load_sparse_edges = load(vt_filePaths);
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
    
    vt_filePath = append(vt_filePath,"/",fn(i).name);
    imwrite(mat_255,vt_filePath);
    
    
    vt_filePath_3 = Save_path_vt_3 + file_path;
    % Save the original edge image
    if exist(vt_filePath_3, 'dir')==0
      mkdir(vt_filePath_3)
    end
    vt_filePath_3 = append(vt_filePath_3,"/",fn(i).name);
    
    mat_255_3 = I;
    
    mat_255_3(:,:,1) = uint8(c1_mat)*255;
    mat_255_3(:,:,2) = uint8(c2_mat)*255;
    mat_255_3(:,:,3) = uint8(c3_mat)*255;
    
    imwrite(mat_255_3,vt_filePath_3);

end

function y = norml_values_strict(xx,max_value,min1,max1)
    y=((xx-min1).*max_value)./(max1-min1);
end