# Matlab_BlurEstimation
================   VQA readme file   ================
The code contains 
	BlurEstimation_selection_nS.m, 
	BlurEstimation_selection_S.m, 
	[gbvs] file folder, 
	readme.txt, 
	video_QA_demo_V1_VedioFileTest.m
	BlurEstimation_section_S2.m
	video_QA_demo_V1_VedioFileTest2.m
----------------
    BlurEstimation_selection_nS.m    -> without using saliency map to estimate blur
    BlurEstimation_selection_S.m     -> using saliency map to estimate blur
    BlurEstimation_section_S2.m   ->  using saliency map to estimate blur efficiently	(This is improvement of BlurEstimation_selection_S.m  )
    [gbvs] file folder               -> gbps tool box to obtain the saliency map
    Readme.txt                       -> readme
    video_QA_demo_V1_VedioFileTest.m -> video quality assessment demo
    video_QA_demo_V1_VedioFileTest2.m -> video quality assessment demo with opencv to solve Unsupported video style( HEVC video )
----------------
gbvs（Graph-Based Visual Saliency） is used to obtain the saliency map. First, you should do some preperations. Then, run video_QA_demo_V1_VideoFileTest.m 

[Preperation]
1. You should add the [gbvs]'s path to matlab default search path;
    *** ! to use [gbvs] please refer to the readme file in [gbvs]
2. Remember to edit the xxx/gbvs/util/mypath.mat which save the path of [gbvs], then save the path.
    ***  like I:\VQA2018\DB_VQA_test\VQA_bin\VQA_achieved\gbvs
3.If you need run video_QA_demo_V1_VedioFileTest2.m,  you should install mexopencv and opencv 

[run]
1. Change the video file path;
2. Run video_QA_demo_V1_VideoFileTest.m or Run video_QA_demo_V1_VedioFileTest2.m  
