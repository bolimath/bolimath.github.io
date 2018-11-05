
I = imread('cameraman.tif');
% I = rgb2gray(I);
edgeI = edge(I,'canny');
imshow(edgeI)

[m,n] = size(edgeI);
a = 180; % theta from 1 to 180 degrees
r = round(sqrt(m^2+n^2));% the maximum length of rho

hough_voting = zeros(a, 2*r);
hough_axis = cell(a, 2*r);

[row, col] = find(edgeI);
for i = 1:length(row)
  for k = 1:a
     p = row(i)*cos(k*pi/180) + col(i)*sin(k*pi/180);
     p = round(p);
     if p > 0 
       hough_voting(k,r+p) = hough_voting(k,r+p) + 1; %save current point in space (r,2*r)
       hough_axis{k,r+p} = [hough_axis{k,r+p}, [row(i) col(i)]'];
     else
       ap = abs(p) + 1;
       hough_voting(k,ap) = hough_voting(k,ap) + 1;
       hough_axis{k,ap} = [hough_axis{k,ap}, [row(i) col(i)]'];
     end
  end
end
disp('finished!')

imshow(hough_voting,[])
thresh = 0.65*max(hough_voting(:));
figure
imshow(I,[])
hold on
[r1,c1] = find(hough_voting > thresh);
for i = 1:length(r1)
  polar = hough_axis{r1(i),c1(i)};
  plot(polar(2,:),polar(1,:),'r-')  
end
hold off



