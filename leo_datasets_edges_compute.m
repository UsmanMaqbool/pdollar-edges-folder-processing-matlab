clc;
% clear all;
Dataset_path = "/home/leo/docker_ws/nordland";
Save_path = "/home/leo/docker_ws/nordland-grey";
% fn = getfn(Dataset_path, 'jpg$');
filelist = dir(fullfile(Dataset_path, '**/*.jpg'));  %get list of files and folders in any subfolder
fn = filelist(~[filelist.isdir]);  %remove folders from list
for i = 1:length(fn)
    file_name = append(fn(i).folder,"/",fn(i).name);
 
    file_path = regexprep(fn(i).folder,Dataset_path,'','ignorecase');
    new_filePath = Save_path + file_path;
    
    I = imread(file_name);
    
    
    if exist(new_filePath, 'dir')==0
      mkdir(new_filePath)
    end
    new_filePath = append(new_filePath,"/",fn(i).name);
    imwrite(I, new_filePath)
    query_display = sprintf('%d out of %d is done so far %% %f',i,length(fn), i/length(fn)*100);
    disp(query_display)
    
    
end

% for i = 1:length(fn)
%     file_name = fn(i);
%     file_path = regexprep(file_name,Dataset_path,'','ignorecase');
%     new_filePath = Save_path + file_path;
%     
%     mkdir(new_filePath)
%     I = imread(file_name);
%     if exist(new_filePath, 'dir')==0
%       mkdir(new_filePath)
%     end
%     
%     imwrite(I, new_filePath)
%     query_display = sprintf('%d out of %d is done so far %% %f',i,length(fn), i/length(fn)*100);
%     disp(query_display)
%     
%     
% end



