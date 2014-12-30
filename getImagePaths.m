% BASE_PATH/video/rgbFolderName/img_files{1}.jpg
% sequencePath/rgbFolderName/img_files{1}.jpg
% seqeuncePath: BASE_PATH/video
% rgbVideoPath: BASE_PATH/video/rgbFolderName 
% img_files   [1 x N] cell array of strings image filenames
function img_files = getImagePaths(rgbVideoPath, video)

	%for these sequences, we must limit ourselves to a range of frames.
	%for all others, we just load all png/jpg files in the folder.
	frames = {'David', 300, 770;
			  'Football1', 1, 74;
			  'Freeman3', 1, 460;
			  'Freeman4', 1, 283};
	
	idx = find(strcmpi(video, frames(:,1)));
	
	if isempty(idx),
		%general case, just list all images
		img_files = dir( fullfile(rgbVideoPath, '*.png') );
		if isempty(img_files),
			img_files = dir( fullfile(rgbVideoPath, '*.jpg') );
			assert(~isempty(img_files), 'No image files to load.')
		end
		img_files = sort({img_files.name});
	else
		%list specified frames. try png first, then jpg.
		if exist(sprintf('%s/%04i.png', rgbVideoPath, frames{idx,2}), 'file'),
			img_files = num2str((frames{idx,2} : frames{idx,3})', '%04i.png');
			
		elseif exist(sprintf('%s/%04i.jpg', rgbVideoPath, frames{idx,2}), 'file'),
			img_files = num2str((frames{idx,2} : frames{idx,3})', '%04i.jpg');
			
		else
			error('No image files to load.')
		end
		
		img_files = cellstr(img_files);
	end
end % function
