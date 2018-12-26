%% segmentation by thresholding
I = imread('rice.png');
imshow(I);
hI = imhist(I);
figure
bar(hI)
segI = I>125;
figure
imshow(segI)

%% BW image segmentation
I = imread('coins.png');
imshow(I);
%convert gray image to BW(black & white) image
BW = im2bw(I);
figure;
imshow(BW);

dim = size(BW)
col= round(dim(2)/2)-90;
row = min(find(BW(:,col)));
%find the boundary of the object with [row col] as the initial boundary
%points which located at the north of the object
boundary = bwtraceboundary(BW,[row, col],'N');
figure;imshow(I);
hold on;
plot(boundary(:,2),boundary(:,1),'g','LineWidth',3);
%fill holes of BW image by open operation
BW_filled= imfill(BW,'holes');% fills holes in the binary image BW
figure;imshow(BW_filled);
%find boundaries of all objects in the BW image
boundaries = bwboundaries(BW_filled); %compute all boundaries
figure;imshow(I);
hold on;
for k=1:10
    b = boundaries{k};
    plot(b(:,2),b(:,1),'g','LineWidth',3);
end

%%Morphilogical based segmentation
I = imread('cell.tif');
figure, imshow(I), title('originalimage');
[junk threshold] = edge(I, 'sobel');%use Sobeloperator to calculate the threshold value
fudgeFactor= .5;
BWs = edge(I,'sobel', threshold * fudgeFactor); %use edge again to obtain the binary mask
figure, imshow(BWs), title('binarygradient mask');
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
BWsdil= imdilate(BWs, [se90 se0]);%dilate to remove gaps
figure, imshow(BWsdil), title('dilatedgradient mask');
BWdfill= imfill(BWsdil, 'holes');%hole filling
figure, imshow(BWdfill);title('binaryimage with filled holes');
BWnobord= imclearborder(BWdfill, 4); %remove object on border
figure, imshow(BWnobord), title('clearedborder image');
seD= strel('diamond',1);
BWfinal= imerode(BWnobord,seD);
BWfinal= imerode(BWfinal,seD);%smoothen the object by repeated eroding
figure, imshow(BWfinal), title('segmentedimage');
BWoutline= bwperim(BWfinal);%place an outline
Segout= I;
Segout(BWoutline) = 255;
figure, imshow(Segout), title('outlinedoriginal image');

%%Watershed segmentation

I=imread('pout.tif');
figure, imshow(I);
%Smooth before watershed transform
Ir=I(:,:,1);
H = fspecial('disk',2);
blurredIr= imfilter(Ir,H,'replicate');
figure
imshow(blurredIr)
%First try original watershed transform
mask1=watershed(blurredIr);
figure,imshow(mask1,[]);
%Then try gradient watershed transform
[height width]=size(Ir);
[gx,gy]=gradient(double(Ir));
grad=uint8(sqrt(gx.^2+gy.^2));
%Smooth before watershed transform
H = fspecial('disk',3);
blurredgrad= imfilter(grad,H,'replicate');
mask2=watershed(blurredgrad);
figure,imshow(mask2,[]);

%% Kmeans clustering segmentation
he = imread('hestain.png');
figure; imshow(he);title('H&Eimage');
cform= makecform('srgb2lab');
lab_he= applycform(he,cform);
ab= double(lab_he(:,:,2:3));
nrows= size(ab,1);ncols= size(ab,2);
ab= reshape(ab,nrows*ncols,2);
nColors= 3;
[cluster_idx cluster_center] = kmeans(ab',nColors);
pixel_labels= reshape(cluster_idx,nrows,ncols);
figure,imshow(pixel_labels,[]), title('imagelabeled by cluster index');
segmented_images= cell(1,3);
rgb_label= repmat(pixel_labels,[1 1 3]);
for k = 1:nColors
    color = he;
    color(rgb_label~= k) = 0;
    segmented_images{k} = color;
end
figure,imshow(segmented_images{1}), title('objectsin cluster 1');
figure,imshow(segmented_images{2}), title('objectsin cluster 2');
figure,imshow(segmented_images{3}), title('objectsin cluster 3');
