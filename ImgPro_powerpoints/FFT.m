
a=imread('cameraman.tif');b=im2double(a);
figure;imshow(b);
Fb= fft2(b); Fbshift=fftshift(Fb);
figure;imshow(log(abs(Fbshift)),[]);
figure;imshow(angle(Fbshift),[]);


rebuiltmb=ifft2(abs(Fb));
figure;imshow(rebuiltmb);
rebuiltpb=ifft2(Fb./abs(Fb));
figure;imshow(rebuiltpb,[]);


figure;imshow(log(abs(real(Fbshift))),[]);
rebuiltrb=ifft2(real(Fb));
figure;imshow(rebuiltrb,[]);



figure;imshow(log(abs(imag(Fbshift))),[]);
rebuiltib=ifft2(Fb-real(Fb));
figure;imshow(rebuiltib,[]);

a=imread('testpat1.png');b=im2double(a);
figure;imshow(b);


Fb= fft2(b);Fbshift=fftshift(Fb);
figure;imshow(log(abs(Fbshift)+0.00000001),[]);

FMask=zeros(256,256);FMask([96:160],[96:160])=1.0;
Fbband=Fbshift.*FMask;
figure;imshow(log(abs(Fbband)+0.0000001),[]);


Fbband=ifftshift(Fbband);bandrebuilt=ifft2(Fbband);
figure;imshow(bandrebuilt);

FMask=zeros(256,256);FMask([64:192],[64:192])=1.0;
Fbband=Fbshift.*FMask;
figure;imshow(log(abs(Fbband)+0.0000001),[]);

Fbband=ifftshift(Fbband);bandrebuilt=ifft2(Fbband);
figure;imshow(bandrebuilt);

FMask=zeros(256,256);FMask([32:224],[32:224])=1.0;
Fbband=Fbshift.*FMask;
figure;imshow(log(abs(Fbband)+0.0000001),[]);

Fbband=ifftshift(Fbband);bandrebuilt=ifft2(Fbband);
figure;imshow(bandrebuilt);

I = imread('duck.jpg');
I = im2double(I);
imshow(I)

J= fft2(I);Jshift=fftshift(J);
figure;imshow(log(abs(Jshift)+0.00000001),[]);

Ir = ifft2(J);
imshow(Ir,[])

[m,n,o] = size(Jshift);
Jshift2 = Jshift;
Jshift2(m/2-10:m/2+10, n/2-10:n/2+10,:) = 0;
imshow(log(abs(Jshift2)+0.00000001),[]);

Ir2 = ifft2(fftshift(Jshift2));
imshow(Ir2,[])

Jshift3 = zeros(size(Jshift));
Jshift3(m/2-10:m/2+10, n/2-10:n/2+10,:) = Jshift(m/2-10:m/2+10, n/2-10:n/2+10,:);
imshow(log(abs(Jshift3)+0.00000001),[]);


Ir3 = ifft2(fftshift(Jshift3));
imshow(Ir3,[])

I = imread('bp1.jpg');
I = im2double(rgb2gray(I));
F = fft2(I);
Fshift = ifftshift(F);
imshow(log(abs(Fshift)+0.00000001),[]);
Ic = ifft2(F);
figure
montage([log(abs(Fshift)+0.00000001) Ic])

[m,n] = size(Fshift);
Fshift2 = zeros(size(Fshift));
w = 60;
Fshift2(m/2-w:m/2+w, n/2-w:n/2+w) = Fshift(m/2-w:m/2+w, n/2-w:n/2+w);
Ic2 = ifft2(fftshift(Fshift2));
imshow(log(abs(Fshift2)+0.00000001),[]);
montage([log(abs(Fshift2)+0.00000001) Ic2])

Ic2 = ifft2(fftshift(Fshift2));
imshow(Ic2,[])
