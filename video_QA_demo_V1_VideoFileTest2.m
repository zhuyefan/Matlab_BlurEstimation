%% Video quality assessment demo V1
% use v3 feature(sum of gradient & delta gradient) classified into 5
% ������opencv����Ƶ�������� ��Ȼ��bgr��ʽ���ǲ�Ӱ��������ȡ��Ƶ��matlab��һ�� ����Ϊ���뷽ʽ��ͬ�������С��3
% matlab����mexopencvҲ��rgb��ȡ������Ҫ�ٸı�ͨ��
% ����ȡts�ļ�ʱ���ܻ��������֡�����޷���ȡ
% ��˹ģ���÷�Խ�ߣ�Խģ��

clear;

videoPath = 'D:\��Ҷ�����ݼ�\������\';    % video file path
videoDir  = dir(videoPath); % get all sub file ���ʱ��videodir��һ���ṹ�壬����name,bytes,data�ȱ���   ������'*.mp4'��ֻ�����mp4��β���ļ�
len = length(videoDir);  
score_frames=zeros(5100,len); % Ԥ�����ռ� ����ٶ�
fea=zeros(5100,len);
score = zeros(1,len)
for i = 1:len         % �����ṹ��Ϳ���һһ����ͼƬ��
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
    while k<= obj.FrameCount-5 % ע��FrameCount��ts�ļ��д���PosFrames
        frame = read(obj); %��ȡobj��ÿһ֡
     
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
        sprintf('��������ͼ����ʱ��%.2f',etime(t2,t1))
%     disp('blur estimating ......')
        t3 = clock;
        [score_frames(k,i),fea(k,i)]=BlurEstimation_section_S3(frame,map.master_map_resized);
        t4 = clock;
        sprintf('����ģ��������ʱ��%.2f',etime(t4,t3))
        %sprintf('%d',k)  % �������һ��ans�������ƴ洢
        k = k+1;
        sprintf('%d--%d',i,k)
    %%%  direct feature *    
%     [score_frames(k),fea(k,:)]=BlurEstimation_section_nS(frame);
    end
    score(i)=mean(score_frames(1:k-1,i)); % �洢��score���������
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
% videoObj = VideoReader('video1.avi');%����Ƶ�ļ�
% nframes = get(videoObj, 'NumberOfFrames');%��ȡ��Ƶ�ļ�֡����
% for k = 1 : 30
%     currentFrame = read(videoObj, k);%��ȡ��i֡
%     Frame1=read(videoObj, k+1);
%     Frame2=read(videoObj, k+2);   
%    % imshow(currentFrame);
% 
% 
%     grayFrame = rgb2gray(currentFrame);%�ҶȻ�
%     grayFrame_1 = rgb2gray(Frame1);%�ҶȻ�
%      grayFrame_2=rgb2gray(Frame2);
%     
%      difgrayFrame= grayFrame - grayFrame_1;%��֡��
%     difgrayFrame2= grayFrame_1 - grayFrame_2;%��֡�� 
%      fdiff1=im2bw(uint8( difgrayFrame),0.05);%����ֵ�Ƚ�ת���ɶ�ֵͼ��
%       fdiff2=im2bw(uint8( difgrayFrame2),0.05);%����ֵ�Ƚ�ת���ɶ�ֵͼ��
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