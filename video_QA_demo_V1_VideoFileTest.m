%% Video quality assessment demo V1
%������matlab�Դ���ȡ��Ƶ������ȡ��

clear;
videoPath = 'D:\��Ҷ�����ݼ�\2.1\';    % video file path
videoDir  = dir([videoPath '*.mp4']); % get all .mp4 file ���ʱ��videodir��һ���ṹ�壬����name,bytes,data�ȱ���
len = length(videoDir);
for i = 1:len         % �����ṹ��Ϳ���һһ����ͼƬ��
    %disp('input image......') 
    fileName = [videoPath videoDir(i).name]; % input filename;
    obj = VideoReader(fileName);
    % give necessary information
    vidWidth = obj.Width;
    vidHeight = obj.Height;
    score_frames=zeros(5100,len); % Ԥ�����ռ� ����ٶ�
    fea=zeros(5100,len);
    % for store the information
    mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
        'colormap',[]);

    % get the information %% mov(k).cdata
    disp('input video ......')
    k = 1;
    while hasFrame(obj)
        mov1.cdata = readFrame(obj); %��ȡobj��ÿһ֡
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
        sprintf('��������ͼ����ʱ��%.2f',etime(t2,t1))
%     disp('blur estimating ......')
        t3 = clock;
        [score_frames(k,i),fea(k,i)]=BlurEstimation_section_S3(frame,map.master_map_resized);
        t4 = clock;
        sprintf('����ģ��������ʱ��%.2f',etime(t4,t3))
        %sprintf('%d',k)  % �������һ��ans�������ƴ洢
        k = k+1
    %%%  direct feature *    
%     [score_frames(k),fea(k,:)]=BlurEstimation_section_nS(frame);
    end
    score(i)=mean(score_frames); % ֱ�Ӷ���һ�����󣬴洢��score���������
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