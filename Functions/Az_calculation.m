
clear
clc

A=load("Himalaya_outline_points.txt");
lon=A(:,1);
lat=A(:,2);

% plot(lon,lat,'-rx')

angle_f=[];

for i=1:length(A)-1

    lin_fit=polyfit(A(i:i+1,1),A(i:i+1,2), 1);
    m=lin_fit(1);
    c=lin_fit(2);

    angle=atand(m);

    if angle<0

        angle_f=[angle_f;270+abs(angle)];

    else

        angle_f=[angle_f;90-abs(angle)];

    end
    end




