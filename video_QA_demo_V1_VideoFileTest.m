%% Video quality assessment demo V1
%这是用matlab自带读取视频库来读取的

clear;
videoPath = 'D:\朱叶凡数据集\2.1\';    % video file path
videoDir  = dir([videoPath '*.mp4']); % get all .mp4 file 这个时候videodir是一个结构体，含有name,bytes,data等变量
len = length(videoDir);
for i = 1:len         % 遍历结构体就可以一一处理图片了
    %disp('input image......') 
    fileName = [videoPath videoDir(i).name]; % input filename;
    obj = VideoReader(fileName);
    % give necessary information
    vidWidth = obj.Width;
    vidHeight = obj.Height;
    score_frames=zeros(5100,len); % 预先留空间 提高速度
    fea=zeros(5100,len);
    % for store the information
    mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
        'colormap',[]);

    % get the information %% mov(k).cdata
    disp('input video ......')
    k = 1;
    while hasFrame(obj)
        mov1.cdata = readFrame(obj); %读取obj中每一帧
     % set number of frames  %1; %
        disp('video input!')
    %play 
    % implay(mov);
    % try 
        tic;
        disp('blur estimating ......')
        frame = mov1.cdata;
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
        k = k+1
    %%%  direct feature *    
%     [score_frames(k),fea(k,:)]=BlurEstimation_section_nS(frame);
    end
    score(i)=mean(score_frames); % 直接定义一个矩阵，存储在score这个矩阵里
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