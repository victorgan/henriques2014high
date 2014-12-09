
% Hack to get paths to Song's RGBD images. The filenames are based on 'time' + % 'f'
% sequencePath [string] of image filenames (eg. 'r-0-1.png')
% img_files    [1 x N] cell array of strings image filenames
function [img_files, imgDepthFiles] = loadImageFiles(sequencePath)
    RGB_FOLDER_NAME = 'img';
    DEPTH_FOLDER_NAME = 'depth';

    % Load frame number
    load(fullfile(sequencePath, 'frames'), 'frames');
    assert(exist('frames') == 1, 'sequencePath struct must contain frames');

    % Frame number
    numFrames = frames.length;
    assert(numFrames == size(frames.imageTimestamp,2), 'frames struct corrupted');
    assert(numFrames == size(frames.imageFrameID,2), 'frames struct corrupted');

    rgbFolderName = RGB_FOLDER_NAME;
    for f = 1:numFrames
        filename = sprintf('r-%d-%d.png', frames.imageTimestamp(f), frames.imageFrameID(f));
        % img_files{f} = fullfile(sequencePath, rgbFolderName, filename); % full path
        img_files{f} = filename;
    end % for f
    assert(~isempty(img_files), 'No RGB images to load.')

    depthFolderName = DEPTH_FOLDER_NAME;
    for f = 1:numFrames
        filename = sprintf('r-%d-%d.png', frames.imageTimestamp(f), frames.imageFrameID(f));
        % img_files{f} = fullfile(sequencePath, depthFolderName, filename); % full path
        imgDepthFiles{f} = filename;
    end % for f
    assert(size(imgDepthFiles, 1) ~= 0);
    assert(~isempty(img_files), 'No Depth images to load.')
end % function
