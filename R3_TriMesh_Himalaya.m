% Routine-3: (Imp: Don't clear workspace variables)
% This part of the routine generates the triangular mesh based on "Delaunay Triangulation" method
% By assigning depth values to the points in between and on the polygon surface (both updip and downdip)
% Depth for each point=(dtop/(dtop+dbotm))*(Dmax) : Dmax will be gathered from the depth values from downdip boundary of Slab 2.0 

% by D. Panda (19 Apr, 2023)

%%

addpath(genpath(pwd));

%% Load the trace of Updip boundary from Blocks

data=load('segments_him.txt');  % Load the user provided txt file containing Lon, Lat values (i.e., Updip boundary)
data=make_dense_points_updip_boundary(data);  % Function to add multiple points in between the User given points (Can be change to refine the triangle mesh)
data=[data;data_f2(:,1:2)];  % Combined data from (1) txt file (i.e., Updip boundary) and (2) Downdip boundary from Slab 2.0 in Routine-1 
x_poly = data(:,1);
y_poly = data(:,2);

% Define the polygon boundary
% x_poly = lon3(k);
% y_poly = lat3(k);

% Set the spacing of the points
spacing = 0.45;

% Define the x and y ranges
x_range = min(x_poly):spacing:max(x_poly);
y_range = min(y_poly):spacing:max(y_poly);

% Create a grid of points
[X, Y] = meshgrid(x_range, y_range);

% Reshape the grid into a list of points
x_points = reshape(X, [], 1);
y_points = reshape(Y, [], 1);

% Select only the points that lie inside and on the polygon
inside = inpolygon(x_points, y_points, x_poly, y_poly);
x_inside = [x_points(inside);x_poly]; % Considers points in and on the polygon surface
y_inside = [y_points(inside);y_poly];

figure(1)
scatter(x_points(inside),y_points(inside),5,"black",'filled')
hold on;
plot(x_poly, y_poly, 'r', 'LineWidth', 1);
title('Polygon Boundary and Points')

%% Create the Delaunay triangulation
T = delaunay(x_inside, y_inside);

% Plot the polygon and the triangulation in 2D
figure(2)
triplot(T,x_inside,y_inside);
title('Triangular Mesh in 2D (Not Perfect)')

% Remove Bad Triangles outside the polygon boundary
T_new = Remove_Bad_Triangles_2d(T,x_inside,y_inside,x_poly, y_poly);
figure(3)
triplot(T_new,x_inside,y_inside);
title('Triangular Mesh in 2D (Perfect)')


%% Assigning depth values to the points in and on the polygon (both updip and downdip)

in_bound=lon_lat_f(:,1:2);  % Dense Updip boundary from Routine-2 (Lon, Lat, Depth)
in_bound=unique(in_bound,'rows','stable'); % Removing any duplicating points created during Routine-2

out_bound=data_botm2(:,1:2); % Dense Downdip boundary from Routine-2 (Lon, Lat, Depth)
out_bound=unique(out_bound,'rows','stable'); % Removing any duplicating points created during Routine-2

pts_inside=[x_inside,y_inside];  % Considers points in and on the polygon surface


% Depth for each point=(dtop/(dtop+dbotm))*(Dmax) : Dmax will be gathered from the depth values from downdip boundary of Slab 2.0 

Depth=[];

for i=1:length(pts_inside)

dtop=min(pdist2(pts_inside(i,:),in_bound));
dbotm=pdist2(pts_inside(i,:),out_bound);
[id]=find(dbotm==min(dbotm));
dbotm=dbotm(id);

Depth=[Depth;(dtop/(dtop+dbotm))*data_botm2(id,3)];

end

%% Plot the mesh based on Delaunay triangulation in 3D

figure(4)
trimesh(T_new,x_inside,y_inside,Depth*(-1))
title('Triangular Mesh in 3D')

pt_dep=[]; % Estimating average depth of three vertices of triangular mesh

for j=1:length(T_new)
    pt_dep(j)=-(Depth(T_new(j,1))+Depth(T_new(j,2))+Depth(T_new(j,3)))/3;
end

figure(5)
trisurf(T_new,x_inside,y_inside,Depth*(-1),pt_dep)
title('Triangular Mesh in 3D, Depthwise')

% Estimating Centroid of triangular mesh
centroid=[];

for i=1:length(T_new)
    centr_lon=mean([x_inside(T_new(i,1)),x_inside(T_new(i,2)),x_inside(T_new(i,3))]);
    centr_lat=mean([y_inside(T_new(i,1)),y_inside(T_new(i,2)),y_inside(T_new(i,3))]);
    centroid=[centroid;centr_lon,centr_lat];
end
centroid_f=[centroid,pt_dep'];

%% Save .mat file for blocks input

c=[x_inside,y_inside,Depth];  % c: (nc x 3) double, contains lon,lat,depth(negative) for each vertex
nc=length(c);  % nc: int, number of vertices
nEl=length(T_new); % nEl: int, number of triangles
v=T_new; % v: (nEl x 3) int, contains triples of vertex IDs for each triangle

save('Himalaya_delaunay_mesh.mat','c','nc','nEl','v');


