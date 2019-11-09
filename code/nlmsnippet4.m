% Get the new value for the pixel (i, j)
if sum_dn ~= 0
	img_f(j, i) = sum_up/sum_dn;
	disp(img_f(j,i))
end