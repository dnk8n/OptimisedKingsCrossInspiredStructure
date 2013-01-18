clear

%USER INPUTS
height1=18500;                                                            %height near base
height2=10000;                                                            %height at circumference
radius=59000;
fanAng=pi;                                                                %Angle that the structure fans out to
memBeg=12000;                                                             %Distance from centre where elements stop being generated

%GA PARAMETERS
segNo=2*randi([2 30]); segAng=fanAng/segNo;                               %Number of radial segments, even number
memNo=2*randi([2 15]); nodNo=memNo+1;                                     %Number of ziggzagging members per segment
spread=rand(1);                                                           %How are the members spread. Number from 0 to 1

%INITIAL XY-COORDS
memMag(1)=(radius*sin(segAng))/sin(segAng+(pi-segAng)*spread);
for k=2:memNo
    memMag(k)=(memMag(k-1)*sin((pi-segAng)*spread))/sin((pi-segAng)*spread+segAng);
end
x(1)=-radius;                                                            
y(1)=0;
for k=2:nodNo                                                                
    if floor(k/2)==k/2,                                                    
        x(k)=x(k-1)+(memMag(k-1)*cos((pi-segAng)*spread));
        y(k)=y(k-1)+(memMag(k-1)*sin((pi-segAng)*spread));
    else                                                                  
        x(k)=x(k-1)+memMag(k-1)*cos(segAng+(pi-segAng)*spread);
        y(k)=0;
    end
end

%XY-COORD SHIFT
for k=1:2:nodNo
    xs(k)=-radius+(radius-memBeg)*((x(k)+radius)/(x(nodNo)+radius));
    ys(k)=0;
end
for k=2:2:nodNo-1
    xs(k)=-radius*cos(segAng)+(radius-memBeg)*cos(segAng)*((x(k)+radius*cos(segAng))/(x(nodNo)*cos(segAng)+radius*cos(segAng)));
    ys(k)=-xs(k)*tan(segAng);
end
XY =[xs' ys'];

% %2D PLOT SEGMENT
% clf;
% axis equal;
% hold all;
% plot(XY(1:end,1),XY(1:end,2));
% plot(XY(1:2:end,1),XY(1:2:end,2));
% plot(XY(2:2:end,1),XY(2:2:end,2));
% %plot([-radius 0] , [radius*tan(segAng) 0]);
% % plot([0 x(1)],[0 y(1)]);
% % plot([0 x(2)],[0 y(2)]);

% %2D PLOT WHOLE
% rot = [cos(2*segAng), sin(2*segAng); -sin(2*segAng), cos(2*segAng)];
% for k = 1:nodNo                                                          
%     if floor(k / 2) == k / 2,                                            
%         XYmir(k,:) = XY(k,:);
%     else                                                               
%         XYmir(k,:) = rot * XY(k,:)';
%     end
% end
% clf
% hold all
% for k=1:segNo/2
%     rot=[cos(2*segAng*(k-1)) -sin(2*segAng*(k-1)); sin(2*segAng*(k-1)) cos(2*segAng*(k-1))];
%     XY0=[XY * rot];
%     XYmir0=[XYmir * rot];
%    
%     plot(XY0(:,1),XY0(:,2));                                         
%     plot(XYmir0(:,1),XYmir0(:,2));                                   
%      
%     plot(XY0(1:2:end,1),XY0(1:2:end,2));                                         
%     plot(XYmir0(1:2:end,1),XYmir0(1:2:end,2));
%      
%     plot(XY0(2:2:end,1),XY0(2:2:end,2));                                         
%     plot(XYmir0(2:2:end,1),XYmir0(2:2:end,2));
% end
% axis equal

%Z-COORDINATES
for k=1:nodNo
    if floor(k/2)==k/2                                               
        curveX(k)=-XY(k,1)*cos(segAng);
    else                                                                   
        curveX(k)=-XY(k,1);
    end
    z(k)=((height1-height2)/2)*cos((-pi*(xs(nodNo)+curveX(k)))/(xs(nodNo)-xs(1)))+((height1+height2)/2);
end
XYZ = [xs', ys', z'];
% %2D PLOT SEGMENT
% clf;
% axis equal;
% hold all;
% plot(XY(1:end,1),XY(1:end,2));
% plot(XY(1:2:end,1),XY(1:2:end,2));
% plot(XY(2:2:end,1),XY(2:2:end,2));
% %plot([-radius 0] , [radius*tan(segAng) 0]);
% % plot([0 x(1)],[0 y(1)]);
% % plot([0 x(2)],[0 y(2)]);

%3D PLOT WHOLE
rot = [cos(2*segAng), sin(2*segAng), 0; -sin(2*segAng), cos(2*segAng), 0; 0 0 1];
for k = 1:nodNo                                                         
    if floor(k / 2) == k / 2,                                             
        XYZmir(k,:) = XYZ(k,:);
    else                                                                  
        XYZmir(k,:) = rot * XYZ(k,:)';
    end
end
clf
hold all
for k=1:segNo/2
    rot=[cos(2*segAng*(k-1)) -sin(2*segAng*(k-1)) 0; sin(2*segAng*(k-1)) cos(2*segAng*(k-1)) 0; 0 0 1];

    XYZ0=[XYZ * rot];
    XYZmir0=[XYZmir * rot];
   
    plot3(XYZ0(:,1),XYZ0(:,2),XYZ0(:,3));                                         
    plot3(XYZmir0(:,1),XYZmir0(:,2),XYZmir0(:,3));                                   
     
    plot3(XYZ0(1:2:end,1),XYZ0(1:2:end,2),XYZ0(1:2:end,3));                                         
    plot3(XYZmir0(1:2:end,1),XYZmir0(1:2:end,2),XYZmir0(1:2:end,3));
     
    plot3(XYZ0(2:2:end,1),XYZ0(2:2:end,2),XYZ0(2:2:end,3));                                         
    plot3(XYZmir0(2:2:end,1),XYZmir0(2:2:end,2),XYZmir0(2:2:end,3));
end
axis equal
view(3);