% Routine-1: (Imp: Don't clear workspace variables)
% This part of the routine generates trace of Downdip Edge of the Himalayan megathrust by combining data from USGS Slab 2.0 Grid File
% Important to have a well defined downdip edge of the fault plane, that's why trace of downdip obtained from Slab 2.0 
% Fault updip boundary may depend upon the user

% by D. Panda (19 Apr, 2023)

%%
clear all
close all
clc

addpath(genpath(pwd));

%% Loaing the USGS Slab 2.0 grid file and removing the NaN points from the grid

file='him_slab2_dep_02.24.18.grd'   % Input Slab 2.0 file
[lon,lat,dep]=grdread2(file);
[x,y] = meshgrid(lon,lat);
figure (1)
scatter3(x(:),y(:),dep(:),5)
title('Himalaya USGS Slab 2.0 Grid')

% Finding Lat/Lon values with finite depth values (Removing the NaNs in the grid file)

lon2=x(:);
lat2=y(:);
dep2=dep(:);

a4=find(~isnan(dep2));  
lon3=lon2(a4);
lat3=lat2(a4);
dep3=dep2(a4);
figure (2)
scatter(lon3,lat3,10)
title('Himalaya USGS Slab 2.0 Grid in 2D (No NaNs)')

%% Tracing the outline/boundary of the grid data points (or polygon)

sf = 1; % Shrinking factor [1 : Perfectly mimicks boundary; Can be lower to smoothen the outline, Maximum value can be 1]
k = boundary(lon3,lat3,sf); % Considered sf=0.5, to avoid dense points in the downdip edge (But can be done if dense points are required)
figure (3)
scatter(lon3,lat3,10)
hold on;
plot(lon3(k), lat3(k), 'r', 'LineWidth', 2);
title('Boundary/Outline for Himalaya USGS Slab 2.0 Grid')


%% Extracting Lat, Lon, Depth data for all the points along the Polygon boundary (Required to separate the downdip edge boundary) 
% Extracts the downdip edge boubdary as a function of depth values

data_f=[lon3(k), lat3(k), dep3(k)];
lon_f=data_f(:,1);
lat_f=data_f(:,2);
dep_f=data_f(:,3)*(-1);  % Depths are considered positive
val=26.5;                % Vary this value to check if the downdip boundary is selected properly

p=find (dep_f>=val);
data_f2=[lon_f(p), lat_f(p), dep_f(p)];
figure (4)
plot(lon3(k), lat3(k), 'r', 'LineWidth', 1);
hold on
plot(data_f2(:,1), data_f2(:,2), '-bx', 'LineWidth', 1);
title('Downdip Edge boundary (Not Perfect)')

%% Manual step 1: Remove few points on either corner of the boundary for a perfect downdip boundary 

ne=[1:10];
nw=[length(data_f2)-5:length(data_f2)];
data_f2([ne,nw],:)=[];  % Manual step 1: May have to delete few points on either side of the boundary

interval=3;  % Change interval for desired density of points on the downdip boundary
data_f2=data_f2(1:interval:end, :);

figure (5)
plot(lon3(k), lat3(k), 'r', 'LineWidth', 1);
hold on
plot(data_f2(:,1), data_f2(:,2), '-bx', 'LineWidth', 1);
title('Downdip Edge boundary (Perfect)')

%% Manual step 2: Add two points on the NE and NW corners to extend the downdip boundary  

ne_pt=[94.658,29.685];  % User given point to extend the existing Slab 2.0 boundary further NE
A=[data_f2(1,1:2);ne_pt];
edge1=make_dense_points_downdip_boundary(A);  % Function "make_dense_points_downdip_boundary" adds multiple points in between the last Slab 2.0 NE point and User given NE point
edge1=flipud(edge1);
edge1(:,3)=mean(data_f2(:,3));  % The extended synthetic points are given a mean depth values of the downdip edge boundary from Slab 2.0

nw_pt=[75.409,34.319];  % User given point to extend the existing Slab 2.0 boundary further NW
A=[data_f2(end,1:2);nw_pt];
edge2=make_dense_points_downdip_boundary(A);
edge2(:,3)=mean(data_f2(:,3));

data_f2=double([edge1;data_f2;edge2]);  % Convert all data points in to double

figure (6)
plot(lon3(k), lat3(k), 'r', 'LineWidth', 1);
hold on
plot(data_f2(:,1), data_f2(:,2), '-bx', 'LineWidth', 1);
title('Extended Downdip Edge boundary')

