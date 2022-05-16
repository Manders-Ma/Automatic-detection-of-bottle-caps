[file, path] = uigetfile('.\*.*g', 'Select a image');
path = [path,file];
img = imread(path);
img = rgb2gray(img);
img = imgaussfilt(img, 1);
f = edge(img, "canny");
% out = imfilter(img, f);


figure(1);
subplot(1,2,1);
imshow(img);

subplot(1,2,2);
imshow(f);