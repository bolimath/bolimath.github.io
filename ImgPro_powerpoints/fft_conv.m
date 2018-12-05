close all;
f = imread('bp1.jpg');
f = rgb2gray(f);
f = im2double(f);
f = imresize(f,0.5);
[m,n,o] = size(f)
figure
imshow(f,[])


w = 5;
s = fspecial('average',2*w+1);
h = zeros(m,n);
h(m/2 - w : m/2 + w, n/2 - w : n/2 + w) = s;
imshow(h,[])
h = ifftshift(h);
figure
imshow(h,[])

tic
F = fft2(f);
H = fft2(h);

FJ = F.*H;
J = real(ifft2(FJ));
t1 = toc

figure
imshow(J,[])

Jc = zeros(size(f));
tic
for i = w+1:m-w
    for j = w+1:n-w
        tmp = f(i-w:i+w, j-w:j+w).*s;
        Jc(i,j) = sum(tmp(:));
    end
end
t2 = toc
figure
imshow(Jc,[])

tic
J2 = imfilter(f,s,'same');
t3 = toc