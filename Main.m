
% blue:5, red:9
% Set Initial Value.
[file, path] = uigetfile('.\*.*g', 'Select a image');
path = [path,file];
c = input('input cluster number : ');



% Main.
BW = Get_cup_EdgeDetail(path, c);
output = Detect_cup_status(BW);
fprintf('1 is Bad.\n0 is good.\nThis image is %d.\n',output);


% Show Hough Matrix.
figure(2);
subplot(1,2,1);
imshow(BW);

[H,T,R] = hough(BW);
subplot(1,2,2);
imshow(H,[],'XData',T,'YData',R);
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;

P = houghpeaks(H,100,'threshold',ceil(0.3*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'gs');  hold off;


function [a, z] = K_means(x, c, threshold)
    [n,d] = size(x);
    z = rand([c, n]);  [~,mi] = max(z,[],1);  z = zeros([c,n]);  z((0:n-1)*c + mi) = 1; new_z = z;
    a = zeros([c, d]);
    error = 1;
    while error > threshold
        a = (z * x) ./ sum(z, 2);
        for i = 1:n
            sqrt(sum((x(i,:) - a).^2, 2));
            [~,mi] = min(sqrt(sum((x(i,:) - a).^2, 2)));
            new_z(:,i) = zeros([c,1]);
            new_z(mi,i) = 1;
        end
        error = sum(sum((new_z-z).^2));
        z = new_z;
    end
end

function [BW] = Get_cup_EdgeDetail(path, c)
    % Read and preprocess image.
    img = imread(path);
    img = imresize(img,[256,256]);
    img = imgaussfilt(img, 1, "Padding","replicate");
    figure(1);
    subplot(1,4,1);
    imshow(img);
    title('original image');
    
    % Image Segmentation by k-means.
    redChannel = img(:,:,1);
    greenChannel = img(:,:,2);
    blueChannel = img(:,:,3);
    data = double([redChannel(:),greenChannel(:),blueChannel(:)]);
    [a, z] = K_means(data, c, 1e-5);
    [~,mi] = max(z);
    mi = reshape(mi, size(img,1), size(img,2));
    a = a/255;
    subplot(1,4,2);
    imshow(label2rgb(mi,a));
    title('image segmentation by kmeans');
    
    % Choose bottle cup's class (median chossed region).
    i = median(median(mi(5:10,126:130)));
    cimg = label2rgb(mi==i,a(i,:));
    cimg = imgaussfilt(cimg, 5, "Padding","replicate");
    subplot(1,4,3);
    imshow(cimg);
    title('bottle cup region');
    
    % Transform colormap rgb to gray.
    % edge detection the gray image.
    subplot(1,4,4)
    gimg = rgb2gray(cimg);
    BW = edge(gimg, 'canny');
    imshow(BW);
    title('edge detection');
end

function [output] = Detect_cup_status(BW)
    [H,T,R] = hough(BW);
    P = houghpeaks(H,100,'threshold',ceil(0.3*max(H(:))));
    theta = T(P(:,2));
    con = 80<=theta | theta<=-80;
    gcon = 87<=theta | theta<=-87;
    rcon = con&~gcon;
    
    
    
    figure(3); title('image with houghline'); imshow(BW); hold on
    lines = houghlines(BW,T,R,P(gcon,:),'FillGap',10,'MinLength',20);
    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    end
    
    if size(P(rcon,:),1) ~= 0
        lines = houghlines(BW,T,R,P(rcon,:),'FillGap',10,'MinLength',20);
        for k = 1:length(lines)
           xy = [lines(k).point1; lines(k).point2];
           plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
        end
    end
    output = size(P(rcon,:),1) ~= 0;
end

