% estimate the gaussian blur paramters 

function [result para] = BlurEstimation_section_S3(Img,map)
%t1 = clock();
Img = double(Img);
[H W Nd] = size(Img);
if Nd == 3
    yuv = rgb2ycbcr(Img);% 转化成ycrbr格式
    y = yuv(:,:,1); % 返回h*w大小矩阵，也就是y分量
else
    y = Img;
end
clear Img;
clear yuv;
y = im2double(y)/255; % 将输入转换为double类.若输入是uint8类 uint16 类 logical类则函数将其转换为范围[0,1]之间的类.
I = y;
clear y;
[y x] = size(I);
Hv = [1 1 1 1 1 1 1 1 1]/9;
Hh = Hv';
B_Ver = imfilter(I,Hv);% one-direction 函数功能：对任意类型数组或多维图像进行滤波
B_Hor = imfilter(I,Hh);
%t2 = clock();
%sprintf('数据转换所需时间%.2f',etime(t2,t1))

%t3 = clock();
D_F_Ver = abs(I(:,1:x-1) - I(:,2:x)); % original image -y  abs函数：数值的绝对值和复数的幅值 return (h,w-1)
D_F_Hor = abs(I(1:y-1,:) - I(2:y,:)); % original image -x  return  (h-1,w)
D_B_Ver = abs(B_Ver(:,1:x-1)-B_Ver(:,2:x));% after filter -y 计算滤波后的图像的上述操作
D_B_Hor = abs(B_Hor(1:y-1,:)-B_Hor(2:y,:));% after filter -x
T_Ver = D_F_Ver - D_B_Ver; % y: original - filter
T_Hor = D_F_Hor - D_B_Hor; % x: original - filter
V_Ver = max(0,T_Ver);% keep positive -d 将比0小的变为0
V_Hor = max(0,T_Hor);% keep positive -d

% %global
% S_D_Ver0 = sum(sum(D_F_Ver(2:y-1,2:x-1)));% sum-ori y
% S_D_Hor0 = sum(sum(D_F_Hor(2:y-1,2:x-1)));% sum-ori x
% S_V_Ver0 = sum(sum(V_Ver(2:y-1,2:x-1)));  % sum-d y
% S_V_Hor0 = sum(sum(V_Hor(2:y-1,2:x-1)));  % sum-d x
% blur_F_Ver_all = (S_D_Ver0-S_V_Ver0)/(S_D_Ver0+0.0001);% delta yN sum_of_Ori-sum_of_filtered
% blur_F_Hor_all = (S_D_Hor0-S_V_Hor0)/(S_D_Hor0+0.0001);% delta xN sum_of_Ori-sum_of_filtered
% v_all = max(blur_F_Ver_all,blur_F_Hor_all);% max

S_D_Ver1 = 0;
S_D_Hor1 = 0;
S_V_Ver1 = 0;
S_V_Hor1 = 0;

theta = prctile(map,60);% 返回一个map矩阵的每列有60%元素小于theta的行向量
%t4 = clock();
%sprintf('滤波所需时间%.2f',etime(t4,t3))
%感兴趣区
%t5 = clock();
theta = max(theta);
map = map(1:H-1,1:W-1);
map = map-theta;
map(map>=0)=0;
map(map<0) = -10000;

D_F_Ver2 = D_F_Ver(1:H-1,1:W-1)+ map;


S_D_Ver1 = sum(D_F_Ver2(D_F_Ver2>0));


D_F_Hor2 = D_F_Hor(1:H-1,1:W-1) +map;
S_D_Hor1 = sum(D_F_Hor2(D_F_Hor2>0));


V_Ver2 = V_Ver(1:H-1,1:W-1)+map;
S_V_Ver1 = sum(V_Ver2(V_Ver2>0));


V_Hor2 = V_Hor(1:H-1,1:W-1)+map;
S_V_Hor1 = sum(V_Hor2(V_Hor2>0));


%t6 = clock();
%sprintf('rio所需时间%.2f',etime(t6,t5))
blur_F_Ver1 = (S_D_Ver1-S_V_Ver1)/(S_D_Ver1+0.0001);
blur_F_Hor1 = (S_D_Hor1-S_V_Hor1)/(S_D_Hor1+0.0001);
v1 = max(blur_F_Ver1,blur_F_Hor1);
%t6 = clock();
%sprintf('rio所需时间%.2f',etime(t6,t5))
if v1<=0.3
    result=1;
elseif v1<=0.4
    result=2;
elseif v1<=0.51
    result=3;
elseif v1<=0.72
    result=4;
else
    result=5;
end
       
para = v1;

        
        
        










