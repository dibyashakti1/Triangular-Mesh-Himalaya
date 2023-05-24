% Routine-2: (Imp: Don't clear workspace variables)
% This part of the routine generates the dense points for the updip (User defined) and downdip (Slab 2.0) traces of the Himalayan megathrust
% Important for calculating distance and assign depth values to the points in between the polygon (both updip and downdip)
% Depth for each point=(dtop/(dtop+dbotm))*(Dmax) : Dmax will be gathered from the depth values from downdip boundary of Slab 2.0 

% by D. Panda (19 Apr, 2023)

%%

addpath(genpath(pwd));

%%
% User provideed updip trace of the polygon boundary of Himalayas (May obtain from the Blocks software)

A=load("segments_him.txt");  % Load the txt file containing Lon, Lat values (i.e., Updip boundary)
lon=A(:,1);
lat=A(:,2);
plot(lon,lat,'r','LineWidth',1)

lon_lat_f=make_dense_points(A);  % Function "make_dense_points" adds multiple points in between the User given points
lon_lat_f(:,3)=0;    % Assign depth values to each points (0 = At surface)

figure (1)
scatter(lon_lat_f(:,1),lon_lat_f(:,2),25,'b','o')
title('Dense Updip Boundary')

%% Loaing the USGS Slab 2.0 grid file and removing the NaN points from the grid

file='him_slab2_dep_02.24.18.grd'   % Input Slab 2.0 file
[lon,lat,dep]=grdread2(file);
[x,y] = meshgrid(lon,lat);
figure (2)
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
figure (3)
scatter(lon3,lat3,10)
title('Himalaya USGS Slab 2.0 Grid in 2D (No NaNs)')

%% Tracing the outline/boundary of the grid data points (or polygon)

sf = 1; % Shrinking factor [1 : Perfectly mimicks boundary; Can be lower to smoothen the outline, Maximum value can be 1]
k = boundary(lon3,lat3,sf); % Considered sf=1, to get dense points to calculate distance from updip/downdip boundary 
figure (4)
scatter(lon3,lat3,10)
hold on;
plot(lon3(k), lat3(k), 'r', 'LineWidth', 2);
title('Boundary/Outline for Himalaya USGS Slab 2.0 Grid')


%% Extracting Lat, Lon, Depth data for all the points along the Polygon boundary (Required to separate the downdip edge boundary) 
% Extracts the downdip edge boubdary as a function of depth values

data_botm=[lon3(k), lat3(k), dep3(k)];
lon_botm=data_botm(:,1);
lat_botm=data_botm(:,2);
dep_botm=data_botm(:,3)*(-1);  % Depths are considered positive
val=26.5;                      % Vary this value to check if the downdip boundary is selected properly

p=find(dep_botm>=val);
data_botm2=[lon_botm(p), lat_botm(p), dep_botm(p)];
figure (5)
plot(lon3(k), lat3(k), 'r', 'LineWidth', 1);
hold on
plot(data_botm2(:,1), data_botm2(:,2), '-bx', 'LineWidth', 1);
title('Downdip Edge boundary (Not Perfect)')

%% Manual step 1: Remove few points on either corner of the boundary for a perfect downdip boundary 

nw=[1:10];
ne=[length(data_botm2)-5:length(data_botm2)];
data_botm2([nw,ne],:)=[];
figure (6)
plot(lon3(k), lat3(k), 'r', 'LineWidth', 1);
hold on
plot(data_botm2(:,1), data_botm2(:,2), '-bx', 'LineWidth', 1);
title('Downdip Edge boundary (Perfect)')

%% Manual step 2: Have to add two points on the NE and NW corners to extend the downdip boundary  

ne_pt=[94.884,30.202];  % User given point to extend the existing Slab 2.0 boundary further NE
A=[data_botm2(1,1:2);ne_pt];
edge1=make_dense_points(A);  % Function "make_dense_points" adds multiple points in between the User given points
edge1=flipud(edge1);
edge1(:,3)=mean(data_botm2(:,3));  % The extended synthetic points are given a mean depth values of the downdip edge boundary from Slab 2.0

nw_pt=[74.126,35.454];  % User given point to extend the existing Slab 2.0 boundary further NW
A=[data_botm2(end,1:2);nw_pt];
edge2=make_dense_points(A);
edge2(:,3)=mean(data_botm2(:,3));

data_botm2=double([edge1;data_botm2;edge2]); % Convert all data points in to double

figure (7)
plot(lon3(k), lat3(k), 'r', 'LineWidth', 1);
hold on
plot(data_botm2(:,1), data_botm2(:,2), '-bx', 'LineWidth', 1);
title('Extended Downdip Edge boundary')


% Combine to form a polygon boundary with dense points

final_poly=[lon_lat_f;data_botm2];

% plot(final_poly(:,1),final_poly(:,2))








