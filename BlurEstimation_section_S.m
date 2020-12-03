% estimate the gaussian blur paramters 

function [result para] = BlurEstimation_section_S(Img,map)
Img = double(Img);
[H W Nd] = size(Img);
if Nd == 3
    yuv = rgb2ycbcr(Img); % 这个不管是rgb还是bgr都一样结果
    y = yuv(:,:,1);
else
    y = Img;
end
clear Img;
clear yuv;
y = im2double(y)/255;
I = y;
clear y;
[y x] = size(I);
Hv = [1 1 1 1 1 1 1 1 1]/9;
Hh = Hv';
B_Ver = imfilter(I,Hv);% one-direction
B_Hor = imfilter(I,Hh);
D_F_Ver = abs(I(:,1:x-1) - I(:,2:x)); % original image -y 
D_F_Hor = abs(I(1:y-1,:) - I(2:y,:)); % original image -x
D_B_Ver = abs(B_Ver(:,1:x-1)-B_Ver(:,2:x));% after filter -y
D_B_Hor = abs(B_Hor(1:y-1,:)-B_Hor(2:y,:));% after filter -x
T_Ver = D_F_Ver - D_B_Ver; % y: original - filter
T_Hor = D_F_Hor - D_B_Hor; % x: original - filter
V_Ver = max(0,T_Ver);% keep positive -d
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

theta = prctile(map,60);
%感兴趣区
for i = 1:H-1
    for j=1:W-1
    if map(i,j)>=theta
        S_D_Ver1 = S_D_Ver1+D_F_Ver(i,j);
        S_D_Hor1 = S_D_Hor1+D_F_Hor(i,j);
        S_V_Ver1 = S_V_Ver1+V_Ver(i,j);
        S_V_Hor1 = S_V_Hor1+V_Hor(i,j);
    end
    end
end
blur_F_Ver1 = (S_D_Ver1-S_V_Ver1)/(S_D_Ver1+0.0001);
blur_F_Hor1 = (S_D_Hor1-S_V_Hor1)/(S_D_Hor1+0.0001);
v1 = max(blur_F_Ver1,blur_F_Hor1);

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

        
        
        










