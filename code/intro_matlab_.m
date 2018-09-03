
Matlab, which is short for Matrix Laboratory, is probably the most widely used scientific
and engineering numerical software. To get started, you can either watch the video from:
http://www.mathworks.co.uk/products/featured/videos/index.html
or read the book from:
http://www.mathworks.com/help/pdf_doc/matlab/getstart.pdf

After you have grasped a general idea of Matlab, you can continue and try to finish the
following exercises.


1. Read an image from disk to the matlab workspace. Display its red, green and blue component separately

I = imread('lena.jpg');
imshow(I)

[m,n,o] = size(I)

J = I(1:300,1:300,:);
figure
imshow(J)

[I_crop, idx] = imcrop(I);
hold on
rectangle('Position', idx, 'LineWidth',1, 'LineStyle','--','EdgeColor','r');


imshow(I_crop)

subplot(131)
imshow(I(:,:,1))
title('R')
subplot(132)
imshow(I(:,:,2))
title('G')
subplot(133)
imshow(I(:,:,3))
title('B')

2. Swap the red component and the blue component of the input image to create a new
image, and save the new image into a new file in the disk.

I2(:,:,1) = I(:,:,3);
I2(:,:,2) = I(:,:,2);
I2(:,:,3) = I(:,:,1);
figure
imshow(I2)
imwrite(I2,'BGR.jpg')

3. Try to make the image brighter or darker

imshow(I+80)
title('lighter')

imshow(I-80)
title('darker')

4. Try to flip, rotate and crop the image.

I_flip1 = I(:,end:-1:1,:);
imshow(I_flip1)

I_flip2 = I(end:-1:1,:,:);
imshow(I_flip2)

I_rot = imrotate(I,45);
imshow(I_rot)

5. Quantize the colour planes using 2 bits, 4 bits, 6 bits etc, and visualize the effect of
the operations.

for i=1:3
    tmp=I(:,:,i);
    tmp2=I(:,:,i);
    for j=32:64:256
        tmp2(find(tmp<j+32 & tmp>=j-32))=j;
    end
    I_2bits(:,:,i)=tmp2;
end
imshow(I_2bits);title('2 bits');

for i=1:3
    tmp=I(:,:,i);
    tmp2=I(:,:,i);
    for j=8:16:256
        tmp2(find(tmp<j+8 & tmp>=j-8))=j;
    end
    I_4bits(:,:,i)=tmp2;
end
imshow(I_4bits);title('4 bits');

6. Sub-sample the image by a factor of 2 and 4 (using nearest-neighbour) and visualize
the effect of the operations.

I_sub = I(1:4:end,1:4:end,:);
imshow(I_sub)
disp('size of I')
size(I)
disp('size of I_sub')
size(I_sub)

I_sub = imresize(I,0.25);
imshow(I_sub)
