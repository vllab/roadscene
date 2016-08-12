clear;

%% set your own path
DATA_PATH = ''; % folder path 
folder = 'test'; 


list = textread([DATA_PATH '/scripts/gt_data/list/' folder '.txt'], '%s');
load([DATA_PATH '/scripts/gt_data/' folder '_gt.mat']);

threshold_prob = [0.45 0.35]; 

c_matrix = zeros(3,3+1);
score = 0;
count = 0;
for i=1:length(list)
    load([DATA_PATH '/results/' folder '/' list{i} '.mat']);
    files = dir([DATA_PATH '/masks/' list{i} '*.png']);
    num_seg(i) = length(files);
    attr = zeros(size(output_attr,1), size(output_attr, 2), size(output_attr,3));
    mask1 = single(ind==9 | ind==10 | ind==8);
    tmp_output_attr = output_attr;
    tmp_output_attr(:,:,3) = zeros(size(output_attr,1), size(output_attr,2));
    tmp_label_attr = label_attr;
    tmp_label_attr(:,:,3) = zeros(size(output_attr,1), size(output_attr,2));
    
    for k=1:2
        attr(:,:,k) = mask1.*single(output_attr(:,:,k)>threshold_prob(k));
    end
    attr(:,:,3) = zeros(size(attr,1), size(attr,2));

    for j=1:length(files)
        mask = single(imread([DATA_PATH '/masks/' files(j).name])/255);
        
        seg(:,:,1) = mask.*(attr(:,:,1));
        seg(:,:,2) = mask.*(attr(:,:,2));
        seg(:,:,3) = zeros(size(attr,1), size(attr,2));
                
        %% method 3
        result = sum(seg, 3);
        seg_label(i,j) = mode(result(logical(mask)));
        
        c_matrix(seg_gt_label(i,j)+1, seg_label(i,j)+1) = c_matrix(seg_gt_label(i,j)+1, seg_label(i,j)+1) +1;
        
        if seg_label(i,j)==seg_gt_label(i,j)
            score = score+1;   
        end
        count = count+1;   
    end
end
display(score/count)

for n=1:size(c_matrix,1)
    c_matrix(n, end) = c_matrix(n,n)/sum(c_matrix(n,:));
end
confusion_matrix = c_matrix(:,1:end-1);
display(confusion_matrix);
recall = c_matrix(:, end);
display(recall);
mean_recall = mean(recall);
display(mean_recall);

% pairwise accuracy
s = 0;
for i=1:size(seg_label, 1)
    cmp_map_gt(i).map = zeros(num_seg(i), num_seg(i));
    cmp_map_pred(i).map = zeros(num_seg(i), num_seg(i));
    for j=1:num_seg(i)
        for k=1:num_seg(i)
           % seg_gt_label cmp matrix
           if seg_gt_label(i,j)>seg_gt_label(i,k)
               cmp_map_gt(i).map(j,k) = 1;
           elseif seg_gt_label(i,j)==seg_gt_label(i,k)
               cmp_map_gt(i).map(j,k) = 0;
           else
               cmp_map_gt(i).map(j,k) = -1;
           end
           % seg_label cmp matrix
           if seg_label(i,j)>seg_label(i,k)
               cmp_map_pred(i).map(j,k) = 1;
           elseif seg_label(i,j)==seg_label(i,k)
               cmp_map_pred(i).map(j,k) = 0;
           else
               cmp_map_pred(i).map(j,k) = -1;
           end
        end
    end
    cmp_result = cmp_map_gt(i).map==cmp_map_pred(i).map;
    cmp_result = and(cmp_result, ~eye(num_seg(i), num_seg(i)));
    [r c] = find(cmp_result==1);
    s = s+length(r);
end
pairwise_accuracy = s/(sum(num_seg.*num_seg)-sum(num_seg));
display(pairwise_accuracy);