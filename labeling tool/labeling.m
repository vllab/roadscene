clear;
metadata.root = '';
metadata.im_folder = 'images\';
metadata.maskim_folder = 'images_with_mask\';
if exist('labeldata_tmp.mat')
    load([metadata.root 'labeldata_tmp.mat']);
    untitled(metadata, list, image_id, maskim_id);
else
    load([metadata.root 'data_list.mat']);
    untitled(metadata, list, 1, 1);
end
