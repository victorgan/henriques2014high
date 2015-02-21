function x = get_features(im, features, cell_size, cos_window)
%GET_FEATURES
%   Extracts dense features from image.
%
%   X = GET_FEATURES(IM, FEATURES, CELL_SIZE)
%   Extracts features specified in struct FEATURES, from image IM. The
%   features should be densely sampled, in cells or intervals of CELL_SIZE.
%   The output has size [height in cells, width in cells, features].
%
%   To specify HOG features, set field 'hog' to true, and
%   'hog_orientations' to the number of bins.
%
%   To experiment with other features simply add them to this function
%   and include any needed parameters in the FEATURES struct. To allow
%   combinations of features, stack them with x = cat(3, x, new_feat).
%
%   Joao F. Henriques, 2014
%   http://www.isr.uc.pt/~henriques/

    if size(im,3) > 1,
        im = rgb2gray(im);
    end

	if features.hog,
		%HOG features, from Piotr's Toolbox
% 		x = double(fhog(single(im) / 255, cell_size, features.hog_orientations));
% 		x(:,:,end) = [];  %remove all-zeros channel ("truncation feature")

        pChns = get_pChns(cell_size, features.hog_orientations);
        if size(im,3) == 1
            pChns.pColor.colorSpace = 'gray'; % default 'luv'. 'rgb' 'gray'
        end
        chns = chnsCompute( single(im)/255, pChns );
        imFeatures = cat(3,chns.data{:});
        x = double(imFeatures);
		x(:,:,end) = [];  %remove all-zeros channel ("truncation feature")

%         size(x)
	end
	
	if features.gray,
		%gray-level (scalar feature)
		x = double(im) / 255;
		
        means = mean(mean(x,1),2);
        x = bsxfun(@minus,x,means); % x = x - means for each channel
	end
	x(:,:,end+1:end+3) = 0;
	%process with cosine window if needed
	if ~isempty(cos_window),
		x = bsxfun(@times, x, cos_window);
	end
	
end % function

% Requires Piotr's toolbox
function imFeatures = featuresFromPchns(im, pChns)
    chns = chnsCompute( im, pChns );
    imFeatures = cat(3,chns.data{:});
end % function

function pChns = get_pChns(cell_size, hog_orientations)
    pChns = chnsCompute(); % default values
    pChns.shrink = cell_size;
    pChns.pColor.enabled = true;
    pChns.pColor.colorSpace = 'luv'; % default 'luv'. 'rgb' 'gray'

    pChns.pGradMag.enabled = true;
    pChns.pGradMag.colorChn = 0;
    pChns.pGradMag.normRad = 0;
    pChns.pGradMag.normConst = 0;
    pChns.pGradMag.full = 1;
    
    pChns.pGradHist.enabled = true;
    pChns.pGradHist.binSize = cell_size;
    pChns.pGradHist.nOrients = hog_orientations;
    pChns.pGradHist.useHog = 2; % 4 way normalization
    pChns.pGradHist.softBin = -1;
end % function
