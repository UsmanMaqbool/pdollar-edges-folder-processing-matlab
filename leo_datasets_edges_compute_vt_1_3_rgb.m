clc;
clear all;

% 1 Channel Merged all (simplex)                | Viewtag_1_e 
% 3 channel Level Edges Alone                   | Viewtag_3_e 
% 3 Channel Rrr-ggg-bbb (without normalization)   | Viewtag_3_rbg 
% 3 Channel rrr-ggg-bbb -> Edges-> normalization  | Viewtag_3_rgb_n
addpath(genpath('/mnt/0287D1936157598A/docker_ws/Visual-place-Recognition-edgesbox'));

Dataset_path = '/mnt/0287D1936157598A/docker_ws/datasets/NetvLad/Pittsburgh';
addpath(genpath(Dataset_path));

Save_path_1_e ='/mnt/0287D1936157598A/docker_ws/datasets/NetvLad/view-tags/Pittsburgh_Viewtag_1_e';
Save_path_vt_3_e = '/mnt/0287D1936157598A/docker_ws/datasets/NetvLad/view-tags/Pittsburgh_Viewtag_3_e';
Save_path_vt_3_rgb = '/mnt/0287D1936157598A/docker_ws/datasets/NetvLad/view-tags/Pittsburgh_Viewtag_3_rbg';
Save_path_vt_3_rgb_n = '/mnt/0287D1936157598A/docker_ws/datasets/NetvLad/view-tags/Pittsburgh_Viewtag_3_rgb_n';


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
size(fn)
tElapsed = zeros(10,1)
time_i = 1
for i = 1:length(fn) %76227
    tStart = tic; 
    file_name = strcat(fn(i).folder,"/",fn(i).name); 
    file_path = regexprep(fn(i).folder,Dataset_path,'','ignorecase');
    
    full_path_1_e = create_filepath_file(Save_path_1_e, file_path, fn(i).name);
    full_path_3_e = create_filepath_file(Save_path_vt_3_e, file_path, fn(i).name);
    full_path_3_rgb = create_filepath_file(Save_path_vt_3_rgb, file_path, fn(i).name);
    full_path_3_rgb_n = create_filepath_file(Save_path_vt_3_rgb_n, file_path, fn(i).name);
   
    %% for Matfile
    [folder, baseFileName, extension] = fileparts(fn(i).name);
    % Ignore extension and replace it with .txt
    vt_file_name = sprintf('%s.mat', baseFileName);
    
    vt_filePaths_1_e = create_filepath_file(Save_path_1_e, file_path, vt_file_name);
    vt_filePaths3_rgb = create_filepath_file(Save_path_1_e, file_path, vt_file_name);


    %% Read and Process Image
    
    
    
    I = imread(char(file_name));
  %  [bboxes, E] =edgeBoxes(I,model);
  %  results = uint8(E * 255);

%% Create View Tags
    
% Create Edge VT
  %  e8u_norml_values = norml_values_strict(E,1,0,1);     % (xx,max_value,min1,max1)

  %  e8u_c1 = e8u_norml_values;
  %  e8u_c1(e8u_c1>.33)  = 0;
  %  e8u_c1 = norml_values_strict(e8u_c1,1,0,0.33);

  %  e8u_c2 = e8u_norml_values;
  %  e8u_c2(e8u_c2<.33)  = 0;
  %  e8u_c2(e8u_c2>.66)  = 0;
  %  e8u_c2 = norml_values_strict(e8u_c2,1,0.33,0.66);

  %  e8u_c3 = e8u_norml_values;
  %  e8u_c3(e8u_c3<.66)  = 0;
  %  e8u_c3 = norml_values_strict(e8u_c3,1,.66,1);

  %  c1_mat_255 = uint8(e8u_c1* 255);
  %  c2_mat_255 = uint8(e8u_c2* 255);
  %  c3_mat_255 = uint8(e8u_c3* 255);
    
    

  %  mat_255 = c1_mat_255+c2_mat_255+c3_mat_255;
    
  %  imwrite(mat_255, char(full_path_1_e))

  %  % Saving method
  %  save(vt_filePaths_1_e,'bboxes');
    
    
  %  Viewtag_3_e = I;
    
  %  Viewtag_3_e(:,:,1) = c1_mat_255;
  %  Viewtag_3_e(:,:,2) = c2_mat_255;
  %  Viewtag_3_e(:,:,3) = c3_mat_255;
    
    
  %  imwrite(Viewtag_3_e,char(full_path_3_e));
    
    %% RGB



    % Create three channels images
    I_r = I; I_g = I; I_b = I;
    I_r(:,:,2) = I(:,:,1); I_r(:,:,3) = I(:,:,1); 
    I_g(:,:,1) = I(:,:,2); I_g(:,:,3) = I(:,:,2); 
    I_b(:,:,1) = I(:,:,3); I_b(:,:,2) = I(:,:,3); 
    
    [bboxes_r, E_r] =edgeBoxes(I_r,model);
    [bboxes_g, E_g] =edgeBoxes(I_g,model);
    [bboxes_b, E_b] =edgeBoxes(I_b,model);

    Viewtag_3_rgb = I;
      
    Viewtag_3_rgb(:,:,1) = uint8(E_r * 255);
    Viewtag_3_rgb(:,:,2) = uint8(E_g * 255);
    Viewtag_3_rgb(:,:,3) = uint8(E_b * 255);
      
    imwrite(Viewtag_3_rgb,char(full_path_3_rgb));
      % Saving method
    save(vt_filePaths3_rgb,'bboxes_r','bboxes_g','bboxes_b');
      
      %% RGB with normalization
      
    e8u_norml_values_r_n = norml_values_strict(E_r,1,0,1);     % (xx,max_value,min1,max1)
    e8u_norml_values_g_n = norml_values_strict(E_g,1,0,1);     % (xx,max_value,min1,max1)
    e8u_norml_values_b_n = norml_values_strict(E_b,1,0,1);     % (xx,max_value,min1,max1)
      
    Viewtag_3_rgb_n = I;
      
      
    Viewtag_3_rgb_n(:,:,1) = uint8(e8u_norml_values_r_n * 255);
    Viewtag_3_rgb_n(:,:,2) = uint8(e8u_norml_values_g_n * 255);
    Viewtag_3_rgb_n(:,:,3) = uint8(e8u_norml_values_b_n * 255);
      
    imwrite(Viewtag_3_rgb_n,char(full_path_3_rgb_n));
    
    query_display = sprintf('%d out of %d is done so far %% %f',i,length(fn), i/length(fn)*100);
    disp(query_display)
    
    tElapsed(time_i) = toc(tStart);
    avg_tElapsed =  sum(tElapsed)/100;
    time_estimated = avg_tElapsed*(length(fn)-i);
    datestr(seconds(time_estimated),'HH:MM:SS')
    time_i = time_i+1;
    if time_i == 100
      time_i = 1;
    end

end

function new_filePath = create_filepath_file(Parent_dir, file_dir, file_name)
new_filePath = strcat(Parent_dir,file_dir); %filepath is between savepath (might need to create the directories)
     %% Save the original edge image
    if exist(new_filePath, 'dir')==0
      mkdir(char(new_filePath))
    end
    new_filePath = strcat(new_filePath,"/",file_name);
end

function y = norml_values_strict(xx,max_value,min1,max1)
    y=((xx-min1).*max_value)./(max1-min1);
end
