function [C_out] = my_multi_sta(s, name)
%static scenes
% imgSeqColor= loadImg('Chinese_garden_Bartlomiej Okonek'); % [0,1]
%     imgSeqColor = downSample(imgSeqColor, 1024);

%% the finest scale
% tic

d_path=['./result/',name];
% disp(s);
% disp(name);
oe=double(imread([s,'oe/',name]));
ue=double(imread([s,'ue/',name]));
% figure,imshow(oe);
% figure,imshow(ue);
imgSeqColor1=[oe;ue];
imgSeqColor=cat(4, ue,oe);
disp(size(imgSeqColor1));
disp(size(imgSeqColor))

r1=4;
[ D1,i_mean1,aa1,N1] = scale_fine(imgSeqColor,r1);

%% the intermediate  scale
[w,h,~,~]=size(imgSeqColor);
nlev = floor(log(min(w,h)) / log(2))-5;

D2 = cell(nlev,1);
aa2= cell(nlev,1);
N2= cell(nlev,1);

r2=4;
for ii=1:nlev
    [ D2{ii},i_mean2,aa2{ii},N2{ii}] = scale_interm(i_mean1,r2);
    i_mean1=i_mean2;
end


%% the coarsest  scale
r3=4;
[fI3,i_mean3,aa3,N3] = scale_coarse(i_mean2,r3);

%% reconstruct
%% Intermediate layers
for ii=nlev:-1:1
    temp=aa2{ii};
    fI=zeros(size(temp));
    fI(1:2:size(temp,1),1:2:size(temp,2))=fI3;
    B2=boxfilter(fI, r2)./ N2{ii}+D2{ii};
    
    fI3=B2;
end
%% finest layers
fI=zeros(size(aa1));
fI(1:2:size(aa1,1),1:2:size(aa1,2))=B2;
B1=boxfilter(fI, r1)./ N1;
C_out=repmat(B1,[1 1 3])+D1;
% matlab输出前要手动用uint8做转换，不然会直接把浮点数据四舍五入写进去
% 有问题可以输出图像看一下
imwrite(uint8(C_out), d_path)
% toc

% figure,imshow(C_out)
end
