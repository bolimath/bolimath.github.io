
%template matching

onion = imread('onion.png');%template image
peppers = imread('peppers.png');%src image
subplot(121)
imshow(onion);
subplot(122)
imshow(peppers)

%compute the correlation matrix
c = normxcorr2(onion(:,:,1),peppers(:,:,1));
figure
% imshow(peppers,[])
imshow(c,[])
% mesh(c) %show correlation as a surface

%find the pixel with biggest correlation coffecient
[max_c, imax] = max(abs(c(:)));
[ypeak, xpeak] = ind2sub(size(c),imax(1));

hold on
plot(xpeak, ypeak, 'r*')

%extract the matching result
extracted_onion = peppers(ypeak-size(onion,1)+1:ypeak, xpeak-size(onion,2)+1:xpeak,:);
figure
imshow(extracted_onion)
s = [xpeak-size(onion,2)+1, ypeak-size(onion,1)+1,  size(onion,2), size(onion,1)];
figure
imshow(peppers)
hold on
rectangle('position', s, 'LineWidth', 2)

I = imread('lena.jpg');
I = im2double(rgb2gray(I));
imshow(I)

help conv2

a = [1 2 3 4; 5 6 7 8; 2 4 6 8; 1 3 5 7]
b = ones(3)
c = conv2(a,b,'valid')

b = [1 0 0 0 0];
I1 = conv2(I,b);
imshow(I1)

b = b';
I2 = conv2(I1,b);
imshow(I2)

b2 = b*b'
I3 = conv2(I,b2);
imshow(I3)

b = [0 1 0;1 0 1; 0 1 0]/4
I3 = conv2(I,b,'same');
imshow(I3,[])

% generate convolutional kernel matrix
s = fspecial('gaussian', 5, 4)
mesh(s)

I1 = conv2(I,s);
imshow(I1)

I1 = imnoise(I,'gaussian');
imshow(I1)

J = conv2(I1,s);
imshow(J)

s1 = fspecial('average',5)
J = conv2(I1,s1);
imshow(J)

I2 = imnoise(I,'salt & pepper');
imshow(I2)

J = conv2(I2,s);
J2 = conv2(I2,s1);
montage([J J2])


J3 = medfilt2(I2,[5 5]);
imshow(J3)

%edge detection
J = conv2(I,s,'same');
edge = J - I;
imshow(edge,[])

x_edge = conv2(I,[-1 0 1]);
imshow(x_edge,[])

y_edge = conv2(I,[-1; 0; 1]);
imshow(y_edge,[])
