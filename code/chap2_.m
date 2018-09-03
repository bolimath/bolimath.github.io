
I = imread('rice.png');
imshow(I)

surf(1:size(I,1),1:size(I,2),I)
 view(0,90)

size(I)

I(1:10,1:10)

I = im2double(I);
J = 1-I;
subplot(121)
imshow(I,[])
subplot(122)
imshow(J,[])

J1 = log(1+I);
subplot(121)
imshow(I,[])
subplot(122)
imshow(J1,[])


J2 = log(1-I);
subplot(121)
imshow(I,[])
subplot(122)
imshow(J2,[])

%Threshold
meanV = mean(I(:))

Jt = I;
Jt(I<meanV) = 0;
Jt(I>=meanV) = 1;
subplot(121)
imshow(I,[])
subplot(122)
imshow(Jt,[])

unique(Jt(:))

%gamma transform
Jg = I.^(0.04);
subplot(121)
imshow(I,[])
subplot(122)
imshow(Jg,[])

%gamma transform
Jg = I.^(3);
subplot(121)
imshow(I,[])
subplot(122)
imshow(Jg,[])

I1 = imread('Picture1.png');
I1 = im2double(I1);
J1 = I1.^(1.5);
imshow(J1,[])

%hist equalization
I = imread('Fig0310(b)(washed_out_pollen_image).tif');
[m,n] = size(I);
nbins = 256;%max(I(:))

hist_ori = zeros(1,nbins);

%compute the histogram of input image
for i = 1:m
  for j = 1:n
    hist_ori(I(i,j)) = hist_ori(I(i,j))+1;
  end
end
hist_ori = hist_ori/sum(hist_ori);
bar(hist_ori)


%compute the cumulative histogram
hist_cum = cumsum(hist_ori);
figure
bar(hist_cum)



%compute the transform t()
% for i=1:256
% t(i)=floor(255*hist_cum(i)+0.5);
% end
t = floor(255*hist_cum+0.5);
figure
plot(t)





%compute the transformed histogram
hist_trans = zeros(1,nbins);
for i=1:256
    hist_trans(t(i)+1) = hist_trans(t(i)+1) + hist_ori(i);
end
figure
bar(hist_trans)




%compute the enhanced image
tic
% for i=1:m
%     for j=1:n
%       I_enhanced(i,j)=t(I(i,j));
%     end
% end

I_enhanced = t(I);
toc
figure
subplot(121)
imshow(I)
subplot(122)
imshow(I_enhanced,[])



%histogram specification(matching)

I = imread('office_2.jpg');
ref = imread('office_4.jpg');
%matlab built-in function
%K = imhistmatch(I,ref);

% %compute the histogram of reference image
% hist_ref = imhist(ref);
% %histogram equalization according to the ref's hist
% K = histeq(I,hist_ref);

% step-by-step 
hist_I = imhist(I);
hist_ref = imhist(ref);

cum_hist_I = cumsum(hist_I)/numel(I);
cum_hist_ref = cumsum(hist_ref)/numel(ref);
figure
subplot(121)
bar(cum_hist_I)
subplot(122)
bar(cum_hist_ref)



map = zeros(1,256);
for i=1:length(cum_hist_I)
   [tmp,ind] = min(abs(cum_hist_I(i) - cum_hist_ref));
   map(i) = ind -1;
end
figure
plot(map)



K = map(double(I) + 1);

figure
imshow(I)
% figure
% imshow(ref)
figure
imshow(uint8(K))


