%% Video quality assessment demo V1
% use v3 feature(sum of gradient & delta gradient) classified into 5
% 这是用opencv中视频库来读的 虽然是bgr格式但是不影响结果，读取视频和matlab不一样 ，因为解码方式不同，会相差小于3
% matlab中用mexopencv也是rgb读取，不需要再改变通道
% 当读取ts文件时，总会有最后两帧左右无法读取
% 高斯模糊得分越高，越模糊

clear;

videoPath = 'D:\朱叶凡数据集\第三个\';    % video file path
videoDir  = dir(videoPath); % get all sub file 这个时候videodir是一个结构体，含有name,bytes,data等变量   若加上'*.mp4'则只会添加mp4结尾的文件
len = length(videoDir);  
score_frames=zeros(5100,len); % 预先留空间 提高速度
fea=zeros(5100,len);
score = zeros(1,len)
for i = 1:len         % 遍历结构体就可以一一处理图片了
    %disp('input image......') 
    fileName = [videoPath videoDir(i).name]; % input filename;

    obj = cv.VideoCapture(fileName);

    % give necessary information
    vidWidth = obj.FrameWidth;
    vidHeight = obj.FrameHeight;
    
   

    % for store the information
    mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
        'colormap',[]);

    % get the information %% mov(k).cdata
    disp('input video ......')

    k = 1;
    while k<= obj.FrameCount-5 % 注意FrameCount在ts文件中大于PosFrames
        frame = read(obj); %读取obj中每一帧
     
        %[b,g,r] = split(mov1.cdata);
        %mov1.cdata = merge([r,g,b]);
        
     % set number of frames  %1; %
    %play 
    % implay(mov);
    % try
        disp('blur estimating ......')
        %frame = mov1.cdata;
    %     imshow(frame);
    %%%  use saliency *
%     disp('computing saliency map ......')
        t1 = clock;
        map = gbvs_fast(frame);
        t2 = clock;
        sprintf('计算显著图所需时间%.2f',etime(t2,t1))
%     disp('blur estimating ......')
        t3 = clock;
        [score_frames(k,i),fea(k,i)]=BlurEstimation_section_S3(frame,map.master_map_resized);
        t4 = clock;
        sprintf('计算模糊度所需时间%.2f',etime(t4,t3))
        %sprintf('%d',k)  % 它会给他一个ans变量名称存储
        k = k+1;
        sprintf('%d--%d',i,k)
    %%%  direct feature *    
%     [score_frames(k),fea(k,:)]=BlurEstimation_section_nS(frame);
    end
    score(i)=mean(score_frames(1:k-1,i)); % 存储在score这个矩阵里
end




% save frames
% if ~exit('ImgTest')
%     mkdir('ImgTest');
% end
% 
% % write frame
% for k=1:numFrames
%     frame = read(obj,k);
%     imshow(frame);
%     imwrite(frame,strcat('./ImgTest/',sprint('%04d.jpg',k)),'jpg');% save frame
% end
% %% example
% clc
% clear
% videoObj = VideoReader('video1.avi');%读视频文件
% nframes = get(videoObj, 'NumberOfFrames');%获取视频文件帧个数
% for k = 1 : 30
%     currentFrame = read(videoObj, k);%读取第i帧
%     Frame1=read(videoObj, k+1);
%     Frame2=read(videoObj, k+2);   
%    % imshow(currentFrame);
% 
% 
%     grayFrame = rgb2gray(currentFrame);%灰度化
%     grayFrame_1 = rgb2gray(Frame1);%灰度化
%      grayFrame_2=rgb2gray(Frame2);
%     
%      difgrayFrame= grayFrame - grayFrame_1;%邻帧差
%     difgrayFrame2= grayFrame_1 - grayFrame_2;%邻帧差 
%      fdiff1=im2bw(uint8( difgrayFrame),0.05);%与阈值比较转换成二值图像
%       fdiff2=im2bw(uint8( difgrayFrame2),0.05);%与阈值比较转换成二值图像
%     f= fdiff1&fdiff2;
%      
%       figure(1);
%      imshow(f);
% end

% get exact number of frames
% numFrames = 0;
% while hasFrame(obj)
%     readFrame(obj);
%     numFrames = numFrames + 1;
% end

% estimate the frame number ==> not recommended
% numFrames_est = ceil(obj.FrameRate*obj.Duration);