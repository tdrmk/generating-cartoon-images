clear ; % Clear the workspace variables
close all ; % Close all images 
image_name = 'test-image.jpg' ; % Enter the RGB image name here 
% Make sure to put the image in the same directory as this code
imrgb = imread(image_name) ; % Read the RGB image specified
imgray = rgb2gray(imrgb); % Convert the image to gray scale for further processing

imedge = edge(imgray,'Canny'); % Use canny edge detection for detection of edges
% Output of the edge detection is a binary image
% Now we find that not all edges are connected ...
% We need to dilate the edges to connect them ...
% firsty we needed to define the neighbourhood needed to be considered for dilating
se = strel('rectangle',[3 3]); % this defines a rectangular neighbourhood
% define the length and width based on performance
% se = strel('disk',2); % this defines a disk neighbourhood
% Now dilate the edges
imedge = imdilate(imedge,se);
% If too large edges you may also want to dilate (not necessary though)
 se1 = strel('disk',1);
 imedge = imerode(imedge,se1);

% Now remove all small regions merge small regions with edges and small edges with neighbouring edges
imedge1 = bwareaopen(imedge,10); % Specify the maximum area of regions you want to remoce
imedge1 = bwareaopen(~imedge1,10);

% Final all regions in the image ...
regions = bwconncomp(imedge1); 
noOfRegions = regions.NumObjects; % Obtain the number of regions

% Now to construct the cartoon images ... construct each of the channel 
newimager = zeros(size(imgray));
newimageg = zeros(size(imgray));
newimageb = uint8(zeros(size(imgray)));
% Obtain color components of the original image
imr = imrgb(:,:,1);
img = imrgb(:,:,2);
imb = imrgb(:,:,3);
for i = 1:noOfRegions
    newimager(regions.PixelIdxList{i}) = uint8(mean(double(imr(regions.PixelIdxList{i}))) + (double(imgray(regions.PixelIdxList{i})) - mean(double(imgray(regions.PixelIdxList{i}))))./mean(double(imgray(regions.PixelIdxList{i}))).* mean(double(imr(regions.PixelIdxList{i}))));
    newimageg(regions.PixelIdxList{i}) = uint8(mean(double(img(regions.PixelIdxList{i}))) + (double(imgray(regions.PixelIdxList{i})) - mean(double(imgray(regions.PixelIdxList{i}))))./mean(double(imgray(regions.PixelIdxList{i}))).* mean(double(img(regions.PixelIdxList{i}))));
    newimageb(regions.PixelIdxList{i}) = uint8(mean(double(imb(regions.PixelIdxList{i}))) + (double(imgray(regions.PixelIdxList{i})) - mean(double(imgray(regions.PixelIdxList{i}))))./mean(double(imgray(regions.PixelIdxList{i}))).* mean(double(imb(regions.PixelIdxList{i}))));
end

% Reconstruct new image
newimage1(:,:,1) = newimager ;
newimage1(:,:,2) = newimageg ;
newimage1(:,:,3) = newimageb ;
% display the reconstructed image
figure(1),subplot(2,1,1),imshow(imrgb),title('Original Image');
figure(1),subplot(2,1,2),imshow(uint8(newimage1)),title('Colorized image');
