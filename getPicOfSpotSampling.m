% Little script to get a nice picture of our spot samples. Extremely 
% hard-coded 

% Taz Bales-Heisterkamp
% C: 3/6/17
% E: 3/6/17

clear all
imgPath = '\\ecefs1\ECE_Research-Space-Share\Spot Sampling\Spot Sampling Images\Cat25\H1214650.JPG';
img = double(rgb2gray(imread(imgPath)));

imgNum = 5;
load('\\ecefs1\ECE_Research-Space-Share\Spot Sampling\spotSamples_taz.mat');
spotSamples = spotSamples_taz(imgNum).objectBoundingBoxes;
%%
fig = figure;
imshow(img, []); 
hold on;
for i = 1 : size(spotSamples, 1)
    rectangle('Position', spotSamples(i, :), 'EdgeColor', 'r','LineWidth', 1);
end
saveas(fig, '\\ecefs1\ECE_Research-Space-Share\Spot Sampling\Example figure\example_figure.jpg')

