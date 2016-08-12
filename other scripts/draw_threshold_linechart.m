clear;

bit = 2;
t = textread(['iter_5_val_' num2str(bit) '.txt'], '%s');  % read the results of diary

% scores or accuracy
x1 = strmatch('score', t, 'exact');
x2 = strmatch('score_2', t, 'exact');
y = strmatch('accuracy', t, 'exact');

max_value = 0;
for i=1:length(x1)
    value(i) = str2num(t{x1(i)+2});
    value2(i) = str2num(t{x2(i)+2});
    iter(i) = str2num(t{x1(i)-1});
    threshold(i) = str2num(t{x1(i)-4});
    
    if str2num(t{x1(i)+2})>max_value
        max_value = str2num(t{x1(i)+2});
        iter_num = str2num(t{x1(i)-1});
        thres = str2num(t{x1(i)-4});
    end
end


figure(bit), plot(0.1:0.05:0.9, value, 'b-');