% Routine-3: (Imp: Don't clear workspace variables)
% This part of the routine generates smooth triangular mesh based on MATLAB's mesh2d function

% MESH2D: 2D unstructured mesh generation for a polygon.
%
% A 2D unstructured triangular mesh is generated based on a piecewise-
% linear geometry input. The polygon can contain an arbitrary number of 
% cavities. An iterative method is implemented to optimise mesh quality. 

% By assigning depth values to the points in between and on the polygon surface (both updip and downdip)
% Depth for each point=(dtop/(dtop+dbotm))*(Dmax) : Dmax will be gathered from the depth values from downdip boundary of Slab 2.0 

% Last modified : D. Panda (7 Sep, 2023)

%%

addpath(genpath(pwd));

%% Create the triangulation mesh

data=load('segments_him4.txt');  % Load the user provided txt file containing Lon, Lat values (i.e., Updip boundary)
% data=make_dense_points_updip_boundary(data);  % Function to add multiple points in between the User given points (Can be change to refine the triangle mesh)

interval=4;   % Set the spacing of the points
node=double([data;data_f2(1:interval:end,1:2)]);

% interval=8;   % Set the spacing of the points
% node=[lon_lat_f(1:interval:end,1:2);data_botm2(1:interval:end,1:2)];

hdata.hmax = 0.3;
options.dhmax = 2;

[P,T] = mesh2d(node,[],hdata);  % Generate 2D mesh

figure(2)
plot(final_poly(:,1),final_poly(:,2),'b')
hold on
plot(node(:,1),node(:,2),'r')

%% Assigning depth values to the points in and on the polygon (both updip and downdip)

in_bound=lon_lat_f(:,1:2);  % Dense Updip boundary from Routine-2 (Lon, Lat, Depth)
in_bound=unique(in_bound,'rows','stable'); % Removing any duplicating points created during Routine-2

out_bound=data_botm2(:,1:2); % Dense Downdip boundary from Routine-2 (Lon, Lat, Depth)
out_bound=unique(out_bound,'rows','stable'); % Removing any duplicating points created during Routine-2

pts_inside=P;       % Considers points in and on the polygon surface

% Depth for each point=(dtop/(dtop+dbotm))*(Dmax) : Dmax will be gathered from the depth values from downdip boundary of Slab 2.0 

Depth=[];

for i=1:length(pts_inside)

    dtop=min(pdist2(pts_inside(i,:),in_bound));
    dbotm=pdist2(pts_inside(i,:),out_bound);
    [id]=find(dbotm==min(dbotm));

    if length(id)>1
        id=id(1);
    end

    dbotm=dbotm(id);
    Depth=[Depth;(dtop/(dtop+dbotm))*data_botm2(id,3)];

end

%% Plot the mesh based on Delaunay triangulation in 3D

figure(4)
trimesh(T,P(:,1),P(:,2),Depth*(-1))
title('Triangular Mesh in 3D')

pt_dep=[]; % Estimating average depth of three vertices of triangular mesh

x_inside=P(:,1);
y_inside=P(:,2);

for j=1:length(T)
    pt_dep(j)=-(Depth(T(j,1))+Depth(T(j,2))+Depth(T(j,3)))/3;
end

figure(5)
trisurf(T,P(:,1),P(:,2),Depth*(-1),pt_dep)
title('Triangular Mesh in 3D, Depthwise')

% Estimating Centroid of triangular mesh
centroid=[];

for i=1:length(T)
    centr_lon=mean([x_inside(T(i,1)),x_inside(T(i,2)),x_inside(T(i,3))]);
    centr_lat=mean([y_inside(T(i,1)),y_inside(T(i,2)),y_inside(T(i,3))]);
    centroid=[centroid;centr_lon,centr_lat];
end
centroid_f=[centroid,pt_dep'];

%% Save .mat file for blocks input

c=[x_inside,y_inside,-Depth];  % c: (nc x 3) double, contains lon,lat,depth(negative) for each vertex
nc=length(c);  % nc: int, number of vertices
nEl=length(T); % nEl: int, number of triangles
v=T; % v: (nEl x 3) int, contains triples of vertex IDs for each triangle

% save('Himalaya_delaunay_mesh_new6.mat','c','nc','nEl','v');

%% Save output file for unicycle input

% c1=[(1:length(c))',y_inside,x_inside,Depth];
% fileID = fopen('Himalaya_delaunay_mesh_new6.ned','w');
% fprintf(fileID,'%7.6f  %7.6f  %7.6f %7.6f\n',c1.');
% fclose(fileID);
% 
% c2=[(1:length(T))',v,zeros(length(v),1)];
% fileID = fopen('Himalaya_delaunay_mesh_new6.tri','w');
% fprintf(fileID,'%.f %.f  %.f  %.f %.f\n',c2.');
% fclose(fileID);
