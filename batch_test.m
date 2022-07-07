clear;
close all;
addpath(genpath(pwd));

tic;
s='C:/data/SICE/train/';
%% get flist
% flist=dir(data_path);
fileFolder=fullfile([s,'oe']);
tmp=dir(fullfile(fileFolder,'*.png'));
% 这里用花括号括住才能拿到所有数据
flist={tmp.name};
% 从cell里拿数据要用花括号
% disp(flist{1});
% my_multi_sta(s, flist{1});
%% loop
for i = flist
    my_multi_sta(s,i{1})
end
toc;


