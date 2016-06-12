%download symbolic package from website and install
%pkg install symbolic-2.4.0.tar.gz
pkg install  io-2.4.1.tar.gz
%or
pkg install -forge io
%pkg load symbolic
pkg load io
% Read into intercept and slope
intercept = xlsread('TaxVsFITnew.xlsx', 'Basecase', 'C3:C7');
slope = xlsread('TaxVsFITnew.xlsx', 'Basecase', 'D3:D7');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Duration curve

Duration = @(h) 11169 - 0.45742  * h

% and now plot them all 
h=0:1:8760;
plot(h, Duration(h));
grid minor on
legend("Duration")   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% base case
coal= @(h) h*slope(1) + intercept(1) 
gascc= @(h) h*slope(2) + intercept(2) 
gasgt= @(h) h*slope(3) + intercept(3) 
wind= @(h) h*slope(4) + intercept(4) 
nuclear= @(h) h*slope(5) + intercept(5) 
% and now plot them all 
h=0:1:8760;
plot(h,coal(h), h,gascc(h),h,gasgt(h), h, wind(h),h, nuclear(h));
grid minor on
legend("coal","gascc", "gasgt", "wind", "nuclear")   

 # Comment: Define Function:
function y = findintersect(s1,i1,s2,i2)
  y= -(i1-i2)/(s1-s2);   
endfunction

# Calculate intersections

y1 = findintersect(slope(4) , intercept(4),slope(2), intercept(2) )
y2 = findintersect(slope(3) , intercept(3),slope(2), intercept(2) )


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


plot(h, Duration(h),[y2,y2],[0,Duration(y2)],[y1,y1],[0,Duration(y1)] , [8760,8760],[0,Duration(8760) ]);
%hold on
%plot([1823,1823],[0,21295]);
grid minor on
legend("Duration", "Load following", "WindPower","baseload")  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% fixed total cost
% The fixed component of costs is simply given by the optimal capacity for the asset multiplied by the annualized capital cost. 

%% Basedload
Duration(8760) * intercept(1)

%% WindPower

(Duration(y1)-Duration(8760)) * intercept(4)

%% Gas CC/load following

(Duration(y2)-Duration(y1))*intercept(2)


%% Gas GT /Peaking
(11169-Duration(y2)) * intercept(3)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% variable total cost
%% To determine the operating costs, we first find the megawatt hours that the asset is expected to operate during the year. This is given by the area underneath the load duration curve in the bottom panel of Figure 3.

%% Basedload
Duration(8760) * 8760* slope(1)

%% WindPower

%((Duration(y2) -Duration(y1)) * 8760 - 0.5*((Duration(y2) -Duration(y1))*(8760-y1)) )  * slope(4)
0

%% Gas GT /load following

(  (Duration(y2) -Duration(y1)) * y1 - 0.5*((Duration(y2) -Duration(y1))*(y1-y2)) )  * slope(2)


% Peaking
(11169-Duration(y2)) * y2 * slope(3) * 0.5


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% tax without nuclear
slope = xlsread('TaxVsFITnew.xlsx', 'taxwtnuclear', 'E3:E7');
coal= @(h) h*slope(1) + intercept(1) 
gascc= @(h) h*slope(2) + intercept(2) 
gasgt= @(h) h*slope(3) + intercept(3) 
wind= @(h) h*slope(4) + intercept(4) 
nuclear= @(h) h*slope(5) + intercept(5) 
% and now plot them all 
h=0:1:8760;
plot(h,coal(h), '-r' ,h,gascc(h),h,gasgt(h), h, wind(h),h, nuclear(h));
grid minor on
legend("coal","gascc", "gasgt", "wind", "nuclear")   

# Calculate intersections

y1 = findintersect(slope(4) , intercept(4),slope(2), intercept(2) )
y2 = findintersect(slope(3) , intercept(3),slope(2), intercept(2) )




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


plot(h, Duration(h),[y2,y2],[0,Duration(y2)],[y1,y1],[0,Duration(y1)] , [8760,8760],[0,Duration(8760) ]);
%hold on
%plot([1823,1823],[0,21295]);
grid minor on
legend("Duration", "Load following", "WindPower","baseload")  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% fixed total cost
% The fixed component of costs is simply given by the optimal capacity for the asset multiplied by the annualized capital cost. 

%% Basedload
Duration(8760) * intercept(1)

%% WindPower

(Duration(y1)-Duration(8760)) * intercept(4)

%% Gas CC/load following

(Duration(y2)-Duration(y1))*intercept(2)


%% Gas GT /Peaking
(11169-Duration(y2)) * intercept(3)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% variable total cost
%% To determine the operating costs, we first find the megawatt hours that the asset is expected to operate during the year. This is given by the area underneath the load duration curve in the bottom panel of Figure 3.

%% Basedload
Duration(8760) * 8760* slope(1)

%% WindPower

%((Duration(y2) -Duration(y1)) * 8760 - 0.5*((Duration(y2) -Duration(y1))*(8760-y1)) )  * slope(4)
0

%% Gas GT /load following

(  (Duration(y2) -Duration(y1)) * y1 - 0.5*((Duration(y2) -Duration(y1))*(y1-y2)) )  * slope(2)


% Peaking
(11169-Duration(y2)) * y2 * slope(3) * 0.5


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tax with nuclear
slope = xlsread('TaxVsFITnew.xlsx', 'tax', 'E3:E7');

coal= @(h) h*slope(1) + intercept(1) 
gascc= @(h) h*slope(2) + intercept(2) 
gasgt= @(h) h*slope(3) + intercept(3) 
wind= @(h) h*slope(4) + intercept(4) 
nuclear= @(h) h*slope(5) + intercept(5) 
% and now plot them all 
h=0:1:8760;
plot(h,coal(h), '-r' ,h,gascc(h),h,gasgt(h), h, wind(h),h, nuclear(h));
grid minor on
legend("coal","gascc", "gasgt", "wind", "nuclear")   

# Calculate intersections

y1 = findintersect(slope(4) , intercept(4),slope(2), intercept(2) )
y2 = findintersect(slope(3) , intercept(3),slope(2), intercept(2) )




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fit without nuclear

slope = xlsread('TaxVsFITnew.xlsx', 'fit', 'F3:F7');


coal= @(h) h*slope(1) + intercept(1) 
gascc= @(h) h*slope(2) + intercept(2) 
gasgt= @(h) h*slope(3) + intercept(3) 
wind= @(h) h*slope(4) + intercept(4) 
nuclear= @(h) h*slope(5) + intercept(5) 
% and now plot them all 
h=0:1:8760;
plot(h,coal(h), '-r' ,h,gascc(h),h,gasgt(h), h, wind(h),h, nuclear(h));
grid minor on
legend("coal","gascc", "gasgt", "wind", "nuclear")   


# Calculate intersections

y1 = findintersect(slope(4) , intercept(4),slope(2), intercept(2) )
y2 = findintersect(slope(3) , intercept(3),slope(2), intercept(2) )



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot intersect
plot(h,gascc(h),'-bo')
hold on
plot(h,wind(h),'-r*')


xlabel ('Hours');
ylabel ('Cost');

%// find and add intersections, only for matlab mapping toolbox
[xi,yi] = polyxpoly(h,gascc(h), h, wind(h))
plot(xi, yi,'ro','markersize',20) %// draw the red circles automatically :-)







