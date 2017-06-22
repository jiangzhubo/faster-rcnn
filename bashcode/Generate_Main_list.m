clc; clear all;
%% generate train.txt val.txt trainval.txt test.txt
file = dir('/home/graymatics/py-faster-rcnn/prepared_data/activaty_dection/Annotations');
len = length(file)-2;

num_trainval=sort(randperm(len, floor(9*len/10)));
num_train=sort(num_trainval(randperm(length(num_trainval), floor(4*length(num_trainval)/6))));
num_val=setdiff(num_trainval,num_train);
num_test=setdiff(1:len,num_trainval);
path = '/home/graymatics/py-faster-rcnn/prepared_data/activaty_dection/ImageSets/Main/';
mkdir(path)


fid=fopen(strcat(path, 'trainval.txt'),'a+');
for i=1:length(num_trainval)
    s = sprintf('%s',file(num_trainval(i)+2).name);
    fprintf(fid,[s(1:length(s)-4) '\n']);
end
fclose(fid);

fid=fopen(strcat(path, 'train.txt'),'a+');
for i=1:length(num_train)
    s = sprintf('%s',file(num_train(i)+2).name);
    fprintf(fid,[s(1:length(s)-4) '\n']);
end
fclose(fid); 

fid=fopen(strcat(path, 'val.txt'),'a+');
for i=1:length(num_val)
    s = sprintf('%s',file(num_val(i)+2).name);
    fprintf(fid,[s(1:length(s)-4) '\n']);
end
fclose(fid);

fid=fopen(strcat(path, 'test.txt'),'a+');
for i=1:length(num_test)
    s = sprintf('%s',file(num_test(i)+2).name);
    fprintf(fid,[s(1:length(s)-4) '\n']);
end 
fclose(fid);

