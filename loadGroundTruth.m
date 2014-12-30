function [pos, target_sz, ground_truth] = loadGroundTruth(base_path, video)
%LOAD_VIDEO_INFO
%   Loads all the relevant information for the video in the given path:
%   the list of image files (cell array of strings), initial position
%   (1x2), target size (1x2), the ground truth information for precision
%   calculations (Nx2, for N frames), and the path where the images are
%   located. The ordering of coordinates and sizes is always [y, x].
%
% N = number of frames in the video
% coordinate ordering is [y, x]
% pos         [1 x 2] initial position
% target_sz [1 x 2] target size (heght x width)
% ground_truth [N x 2] positions of ground truth for precision calculation
% video_path [string] 

    sequencePath = fullfile(base_path, video);

	%try to load ground truth from text file (Benchmark's format)
    filename = fullfile(sequencePath, [video '.txt']);
	f = fopen(filename);
	assert(f ~= -1, ['No initial position or ground truth to load ("' filename '").'])
	
	%the format is [x, y, width, height]
	try
		ground_truth = textscan(f, '%f,%f,%f,%f,%f', 'ReturnOnError',false);  
	catch  %ok, try different format (no commas)
		frewind(f);
		ground_truth = textscan(f, '%f %f %f %f,%f');  
	end
    ground_truth = ground_truth(1:4); % ignore frame number (fifth entry)
	ground_truth = cat(2, ground_truth{:});
	fclose(f);
	
	%set initial position and size
	target_sz = [ground_truth(1,4), ground_truth(1,3)];
	pos = [ground_truth(1,2), ground_truth(1,1)] + floor(target_sz/2);
	
	if size(ground_truth,1) == 1,
		%we have ground truth for the first frame only (initial position)
		ground_truth = [];
	else
		%store positions instead of boxes
		ground_truth = ground_truth(:,[2,1]) + ground_truth(:,[4,3]) / 2;
	end
	
end % function
