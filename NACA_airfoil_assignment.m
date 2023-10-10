%% program variable clear and commandline clear
clear all;
clc;

%% x_value distribution 
x = [0.000:0.001:1];

%% user input
% NACA MPXX formatting the things in this way
NACA_airfoil = '2412';

% Every number in the NACA airfoil designate the 
% camber, position of the maximum camber and thickness.
max_camber = str2double(NACA_airfoil(1));
max_camber_pos = str2double(NACA_airfoil(2));
thickness = str2double(NACA_airfoil(3:4));

%% M,P and T from the inputs
M = max_camber/100;
P = max_camber_pos/10;
T = thickness/100;

%% thickness distribution yt of the wing
% the constants
a0 = 0.2969;
a1 = -0.126;
a2 = -0.3516;
a3 = 0.2843;
a4 = -0.1015; % -0.1036 for closed trailing edge from NACA's website

yt=[]; % the thickness distribution matrix
for n = 1:length(x)
    yt(n) = 5*T * (a0*x(n)^0.5 + a1*x(n) + a2*x(n)^2 + a3*x(n)^3 + a4*x(n)^4);
end

%% equation of camber and gradient distribution
% The equations is divided into two parts
% 0<=x<p  has one equation and p<=x<=1 has a different equation
yc=[]; % camber distribution matrix
dyc_dx = []; % gradient distribution matrix
for n = 1:length(x)
    if x(n)>0 & x(n)<P
        yc(n)= (M/P^2)*(2*P*x(n)-x(n)^2);
        dyc_dx(n) = (2*M/P^2)*(P-x(n));
    elseif x(n)>=P & x(n)<=1
        yc(n)= (M/(1-P)^2)*(1-2*P+2*P*x(n)-x(n)^2);
        dyc_dx(n) = (2*M/(1-P)^2)*(P-x(n));
    end
end

%% theta distribution 
theta = [];
for n = 1:length(dyc_dx)
    theta(n)= atan(dyc_dx(n));
end

%% upper surface point distribution
xu=[];
yu=[];
for n = 1:length(x)
    xu(n)=x(n)-yt(n)*sin(theta(n));
    yu(n)=yc(n)+yt(n)*cos(theta(n));
end
%% lower surface point distribution
xl=[];
yl=[];
for n = 1:length(x)
    xl(n)=x(n)+yt(n)*sin(theta(n));
    yl(n)=yc(n)-yt(n)*cos(theta(n));
end

%% plot
hold on;
%both plots are plotted on the same figure
axis equal;
%manages the aspect ratio of the graph such that distribution
%is same on all axis 
%disabling this would lead to a wobbly graph even with proper data 
 
%plotting of the data points
plot(xu,yu);
plot(xl,yl)


