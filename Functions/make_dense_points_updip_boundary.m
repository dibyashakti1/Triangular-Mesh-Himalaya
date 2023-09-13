function [lon_lat_f] = make_dense_points_updip_boundary(A)

% This function generates multiple points in between two existing points, by considering simple linear relationship (y=mx+c)
% Spacing (n=0.05) is kept fine to get dense distribution of points, helpful accurate estimation of distance of points within the polygon
% by D. Panda (19 Apr, 2023)


lon=A(:,1);
lat=A(:,2);
% plot(lon,lat)
% a=distance(34.84,73.244, 33.285,74.434);
% deg2km(a);

lon_lat_f=[];
n=3;   % Spacing of points. Small spacing = Dense points


for i=1:length(A)-1

lin_fit=polyfit(A(i:i+1,1),A(i:i+1,2), 1);  % Linear fit

m=lin_fit(1);  % Slope of the linear fit
c=lin_fit(2);  % Constant of the linear fit

lon_m=[lon(i,:):n:lon(i+1,:)];
lon_m=[lon_m,lon(i+1,:)];

% if length(lon_m)>=2
% 
% if lon(i+1,:)>lon_m(2)
% 
%     lon_m=[lon_m,lon(i+1,:)];
% 
% end
% 
% end

if lon(i,:)>=lon(i+1,:)

    lon_m=[lon(i,:):-n:lon(i+1,:)];
    lon_m=[lon_m,lon(i+1,:)];

end

for k=1:length(lon_m)

    lat_m(k)=m*lon_m(k)+c;
    
end

lon_lat_f=[lon_lat_f;lon_m',lat_m'];
lon_m=[];
lat_m=[];

end

[~,uidx] = unique(lon_lat_f(:,1),'stable');

lon_lat_f=lon_lat_f(uidx,:);

% scatter(lon_lat_f(:,1),lon_lat_f(:,2),25,'b','o')

end

