
I = imread('bottle.jpg');
J = imread('sky.jpg');
I = im2double(I);
J = imresize(J,[size(I,1), size(I,2)]);
J = im2double(J);
alpha = 0.5;
beta = 1 - alpha;
F = alpha*I + beta*J;
imshow(F,[])




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


% iptsetpref('ImshowBorder','tight');
BW1 = imread('circbw.tif');
figure,imshow(BW1);
SE = strel('rectangle',[40 30]);


%open operation equals erode_dilate
BW3 = imopen(BW1,SE);
figure,imshow(BW3);


BW4 = imdilate(BW1,SE);
imshow(BW4,[])

BW5 = imerode(BW1,SE);
imshow(BW5)

se = strel('rectangle',[3 3]);
BW1_d = imerode(BW1,se);
imshow(BW1 - BW1_d,[])

BW_edge = bwmorph(BW1,'remove');
imshow(BW_edge,[])

I = imread('bw2.jpg');
I = im2bw(I);
imshow(I)
J = bwareaopen(I,25);

figure
imshow(double(J))

%close operation equals dilate_erode
BW4 = imclose(BW1,SE);
figure,imshow(BW4);

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

