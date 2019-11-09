 % For each pixel on vertical edges of the window specified by its half size
for k = max(1, j - windowHalfSearchSize):min(w, j + windowHalfSearchSize)
	
	% For left edge of the window
	if 1 <= i - windowHalfSearchSize
		% Get a patch around that particular pixel on the left edge of the window 
		py = img_n(max(1, k - halfPatchSize):min(w, k + halfPatchSize), max(1, i - windowHalfSearchSize - halfPatchSize):min(h, i - windowHalfSearchSize + halfPatchSize)); 
		% Find out minimum SSD
		if size(px) == size(py)
			s = (px - py).^2;
			s = s(:);
			d = sqrt(sum(s)); 
			d1 = exp(-1 * gamma * d);
			sum_dn = sum_dn + d1;
			sum_up = sum_up + d1 * img_n(j, i);
		end
	end
end