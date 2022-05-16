# Automatic-detection-of-bottle-caps
Automatic detection of bottle caps

## Brief introduction: 
Use K-means, Canny edge detection and Hough transform to detect bottle caps. And then tell you good or bad.

## Reference : 
1. Hough transform - https://homepages.inf.ed.ac.uk/rbf/HIPR2/hough.htm
2. Paper - https://ieeexplore.ieee.org/document/8844942


## System flow :
step1 - Set image cluster number.

step2 - Image preprocessing (set same size, Gaussian Blur).

step3 - Use K-means's output to search quickly bottle caps's cluster(which group).

step4 - Canny edge detection

step5 - Hough transform (vector space -> parameter space)

step6 - bad status condition -> 80<=theta | theta<=-80  ,   good status condition -> 87<=theta | theta<=-87.

step7 - If there is a bad straight line, we sat this bottle is bad status.

## Example :

![show1](https://github.com/Manders-Ma/Automatic-detection-of-bottle-caps/blob/master/resultExample/show1.png)

![show2](https://github.com/Manders-Ma/Automatic-detection-of-bottle-caps/blob/master/resultExample/show2.png)

![show3](https://github.com/Manders-Ma/Automatic-detection-of-bottle-caps/blob/master/resultExample/show3.png)

![result](https://github.com/Manders-Ma/Automatic-detection-of-bottle-caps/blob/master/resultExample/show4.PNG)

