
% addition
I = imread('bottle.jpg');
J = imread('sky.jpg');
I = im2double(I);
J = imresize(J,[size(I,1), size(I,2)]);
J = im2double(J);
alpha = 0.1;
beta = 1 - alpha;
F = alpha*I + beta*J;
imshow(F,[])



%denoise via averaging noise images
I_denoise = zeros(size(I));
iter = 0;
for i = 1:9
I_noise = imnoise(I,'gaussian',0, i*0.01);
iter = iter + 1;
I_denoise = I_denoise + I_noise;
if mod(i,3) == 0
figure
imshow(I_noise)
end

end
figure
imshow(I_denoise/iter,[])

%substrction
I1 = im2double(imread('p1.jpg'));
I2 = im2double(imread('p2.jpg'));
I2 = imresize(I2,[size(I1,1),size(I1,2)]);
montage([I1 I2])

figure
imshow(I2-I1,[])

%logical operation
I = imread('butter.jpg');
mask = imread('mask.jpg');
imshow(I)
figure
imshow(mask)
mask = mask(:,:,1) > 1;
I_mask = I & mask;
I(~I_mask) = 0;
figure
imshow(I,[])

%dilation
mask = imread('mask.jpg');
mask = im2bw(mask);
se = strel('rectangle', [13 13]);
se.Neighborhood;
BW4 = imdilate(mask,se);
montage([mask BW4])

%erosion
BW5 = imerode(mask,se);
montage([mask BW5])


%dual relationship of dilate and erode
mask_c = ~mask;
Br = flip(se);
BW6 = imdilate(mask_c, Br);
sum(sum(BW6 == ~BW5))/size(BW5,1)/size(BW5,2)
montage([~BW5 BW6])

%open operation
Io = imdilate(imerode(mask,se), se);
montage([mask Io])

I_open = imopen(mask, se);
montage([Io I_open])

%close operation
Ic = imerode(imdilate(mask,se), se);
montage([mask Ic])

I_close = imclose(mask,se);
montage([Ic I_close])

%morphological for edge detection
BW1 = imread('circbw.tif');
imshow(BW1)
se = strel('rectangle',[3 3]);
BW1_d = imerode(BW1,se);
figure
imshow(BW1 - BW1_d,[])

BW_edge = bwmorph(BW1,'remove');
imshow(BW_edge,[])

I = imread('bw2.jpg');
I = im2bw(I);
imshow(I)
J = bwareaopen(I,25);

figure
imshow(double(J))

% help bwmorph
% mask_s = bwmorph(mask,'skel',inf);
mask_s = bwmorph(mask,'thin',inf);


montage([mask mask_s])

I = imread('finger.jpg');
if size(I,3) > 1
I = rgb2gray(I);
end
imshow(I)

hst = imhist(I);

bar(hst)

T = 100;
for iter = 1:50
mean_back = mean(I(I>T));
mean_fore = mean(I(I<T));
T = (mean_back + mean_fore)/2;
end
T
I_seg = I>T-1;
imshow(I_seg,[])


I = imread('coin.jpg');
I = im2double(I);
% I = rgb2gray(I);
ws = watershed(I);
whos ws

imshow(ws,[])
% help watershed

