
I = imread('cameraman.tif');
I = im2double(I);
imshow(I,[])


sigma = 3; 
width = 3 * sigma; 
support = -width : width; 
gauss2D = exp( - (support / sigma).^2 / 2); 
gauss2D = gauss2D / sum(gauss2D) 
figure 
line(1:length(gauss2D),gauss2D) 



smooth = conv2(I, gauss2D, 'same'); 
figure
imshow(smooth,[]); 



gauss3D = gauss2D' * gauss2D; 
figure
surf(gauss3D) 
smooth = conv2(I,gauss3D, 'same'); 
figure
imshow(smooth,[]) 


[dx,dy] = gradient(smooth); 
gradmag = sqrt(dx.^2 + dy.^2); 
gmax = max(max(gradmag)) 
imshow(gradmag,[]); 
hold on 
[m,n] = size(I); 
edges = (gradmag > 0.4 * gmax); 
imshow(edges,[]) 


unique(edges(:))

%% Sobel edge detection
smooth_kernel = fspecial('gaussian',5,1);
I_smooth = conv2(I, smooth_kernel,'same');
figure
montage([I I_smooth])


sobel_kernel = [-1 -2 -1; 0 0 0; 1 2 1];
Ix = conv2(I_smooth, sobel_kernel','same');
Iy = conv2(I_smooth, sobel_kernel, 'same');
figure
montage([Ix Iy])

I_mag = sqrt(Ix.^2 + Iy.^2);
montage([I I_mag])

I_max = max(I_mag(:));
edge_I = I_mag > 0.3*I_max;
montage([I edge_I])

%%matlab build-in sobel edge detection function
edge_sobel = edge(I,'sobel');
montage([edge_I edge_sobel])

prewitt_kernel = [-1 -1 -1;0 0 0; 1 1 1];
Ix = conv2(I, prewitt_kernel','same');
Iy = conv2(I, prewitt_kernel, 'same');
figure
montage([Ix Iy])

I_mag = sqrt(Ix.^2 + Iy.^2);
I_max = max(I_mag(:));
edge_prewitt = I_mag > 0.3*I_max;
montage([edge_I edge_prewitt])

smooth_kernel = fspecial('gaussian', 11,2);
surf(smooth_kernel)

[gx,gy] = gradient(smooth_kernel);
surf(gx)
figure
surf(gy)

Ix = conv2(I,gx,'same');
Iy = conv2(I,gy,'same');
imshow(Ix,[])
figure
imshow(Iy,[])

I_mag = sqrt(Ix.^2+Iy.^2);
imshow(I_mag,[])

edge_I = I_mag > 0.3*max(I_mag(:));
imshow(edge_I,[])

%% corner detection
% Harris Corner detector - by Kashif Shahzad
sigma=5; thresh=0.1; sze=11; disp=0;eps=0.0;
dy = [-1 0 1; -1 0 1; -1 0 1]; % Derivative masks
dx = dy'; %dx is the transpose matrix of dy
% Ix and Iy are the horizontal and vertical edges of image
I = imread('rice.png');
imshow(I);
title('\bf Original image');%use bold font for the title
bw=double(I);%convert uint8 to double
Ix = conv2(bw, dx, 'same'); % Calculating the gradient of the image
Iy = conv2(bw, dy, 'same'); %return a matrix the sane size as bw
figure
montage([Ix Iy])


g = fspecial('gaussian',max(1,fix(6*sigma)), sigma); %define Gaussian filter
Ix2 = conv2(Ix.^2, g, 'same'); %Smoothed squared image derivatives
Iy2 = conv2(Iy.^2, g, 'same');
Ixy = conv2(Ix.*Iy, g, 'same');
cornerness = (Ix2.*Iy2 - Ixy.^2)./(Ix2 + Iy2 + eps); %flexible formulations
figure
imshow(cornerness,[])


% help ordfilt2

mx = ordfilt2(cornerness,sze^2,ones(sze)); % Grey-scale dilate
figure
imshow(mx,[])


cornerness = (cornerness==mx)&(cornerness>thresh); % Find maxima
[rws,cols] = find(cornerness); % Find row,col coords.
figure;imshow(bw,[0 255]);
hold on;
p=[cols rws];
plot(p(:,1),p(:,2),'or'); % display corners as red circles
title('\bf Harris Corners');




%%Harris corner detection
[m,n] = size(I);

R=zeros(m,n);
for i=1:m
    for j=1:n
        M=[Ix2(i,j) Ixy(i,j);Ixy(i,j) Iy2(i,j)];
        R(i,j)=det(M)-0.06*(trace(M))^2;
    end
end
Rmax = max(R(:))


re=zeros(m+2,n+2);
tmp = zeros(m+2, n+2); 
tmp(2:m+1,2:n+1)=R;
img_re=zeros(m+2,n+2);
img_re(2:m+1,2:n+1)=I;

for i=2:m+1
    for j=2:n+1
        
        if tmp(i,j)>0.04*Rmax && ...
           tmp(i,j)>tmp(i-1,j-1) && tmp(i,j)>tmp(i-1,j) && tmp(i,j)>tmp(i-1,j+1) &&...
           tmp(i,j)>tmp(i,j-1) && tmp(i,j)>tmp(i,j+1) &&...
           tmp(i,j)>tmp(i+1,j-1) && tmp(i,j)>tmp(i+1,j) && tmp(i,j)>tmp(i+1,j+1)
                img_re(i,j)=255; 
                re(i,j) = 1;
        end   
    end
end

re = mat2gray(re(2:m+1,2:n+1));
img_re=mat2gray(img_re(2:m+1,2:n+1));
figure,imshow(img_re);
[cx,cy] = find(re);
hold on
plot(cy,cx,'r*')

