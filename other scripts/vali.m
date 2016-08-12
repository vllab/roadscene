clear;

folder = 'val';
list = textread(['/mnt/data/amy_data/SegNet/final_model/list/' folder '.txt'], '%s');
load(['/mnt/data/amy_data/SegNet/final_model/new_' folder '_gt.mat']);

threshold_prob = [0 0];
% threshold = [0.5 0.5];
bit = 1;
diary(['cmp_val_' num2str(bit) '.txt']);

for thres = 0.1:0.05:0.9
    threshold_prob(bit) = thres;
    display(thres)
for iter = 7:7
    c_matrix = zeros(3,3);
    score = 0;
    score_2 = 0;
    count = 0;
for i=1:length(list)
%     load(['/mnt/data/amy_data/SegNet/final_model/0703/result/' folder '/' num2str(10000*iter) '/' list{i} '.mat']);
    load(['/mnt/data/amy_data/SegNet/cmp_model/SALICON/result/cmp/' folder '/' list{i} '.mat']);
    files = dir(['/mnt/data/amy_data/SegNet/final_model/mask_all/' list{i} '*.png']);
    num_seg(i) = length(files);
    attr = zeros(size(output_attr,1), size(output_attr, 2), size(output_attr,3));
    
    mask1 = single(ind==9 | ind==10 | ind==8);

    for k=1:2
        attr(:,:,k) = mask1.*single(output_attr(:,:,k)>threshold_prob(k));
    end
    for j=1:length(files)
        mask = single(imread(['/mnt/data/amy_data/SegNet/final_model/mask_all/' files(j).name])/255);
        
        seg = mask.*(attr(:,:,bit));

%         tmp_map = seg;
%         t = tabulate(tmp_map(logical(mask)));
%         if (t(t(:,1)==1,3)/100)>threshold(bit)
%             tmp_map(logical(mask)) = 1;
%         end
%         seg = tmp_map;
        seg_label(i,j) = mode(seg(logical(mask)));
        
        if bit==2
            if ((seg_gt_label(i,j)==1 | seg_gt_label(i,j)==0) & seg_label(i,j)==0) | (seg_gt_label(i,j)==2 & seg_label(i,j)==1) %seg_label(i,j)<=seg_gt_label(i,j)
                score = score+1;   
            end
            if (seg_gt_label(i,j)==2 & seg_label(i,j)==1) 
                score_2 = score_2+1;
            end
        elseif bit==1
            if ((seg_gt_label(i,j)==1 | seg_gt_label(i,j)==2) & seg_label(i,j)==1) | (seg_gt_label(i,j)==0 & seg_label(i,j)==0) %seg_label(i,j)<=seg_gt_label(i,j)
                score = score+1;   
            end
        end
        count = count+1;   
    end
end
display(thres)
display(iter)
accuracy = score/count;
display(score)
display(score_2)
display(accuracy)
% display(c_matrix)
end
end
diary off