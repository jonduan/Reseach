%download symbolic package from website and install
%pkg install symbolic-2.4.0.tar.gz
pkg install  io-2.4.1.tar.gz
%or
pkg install -forge io
%pkg load symbolic
pkg load io
% Read into intercept and slope for ontario
intercept = xlsread('TaxVsFITnew.xlsx', 'Ontario', 'B4:B8');
slope = xlsread('TaxVsFITnew.xlsx', 'Ontario', 'C4:C8');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Duration curve

Duration = @(h) 24000-1.484 * h

% and now plot them all 
h=0:1:8760;
plot(h, Duration(h));
grid minor on
legend("Duration")   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LOCE

% Overnight construction cost to be annualized
r = 0.1
life = 25
CRF = (r*(1+r)^life)/((1+r)^life-1)

oncc = 1223
cf = .27
fixOM=28.07
varOM=0

LCOE = (oncc*CRF + fixOM )/(8760*cf) + varOM

% https://en.wikipedia.org/wiki/Equivalent_annual_cost
%http://www.nrel.gov/analysis/tech_lcoe_documentation.html
%  CRF = {i(1 + i)^n} / {[(1 + i)^n]-1}
% http://www.nrel.gov/analysis/tech_lcoe.html
%sLCOE = {(overnight capital cost * capital recovery factor + fixed O&M cost )/(8760 * capacity factor)} + (fuel cost * heat rate) + variable O&M cost.
%https://en.wikipedia.org/w/index.php?title=Capital_recovery_factor&oldid=317185496

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alberta

r = 0.05
life = 25
CRF = (r*(1+r)^life)/((1+r)^life-1)

oncc = 2600
cf = .27
fixOM=28.07
varOM=0

LCOE = oncc*CRF




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% base case
coal= @(h) h*slope(1) + intercept(1) 
gascc= @(h) h*slope(2) + intercept(2) 
gasgt= @(h) h*slope(3) + intercept(3) 
wind= @(h) h*slope(4) + intercept(4) 
%nuclear= @(h) h*slope(5) + intercept(5) 
% and now plot them all 
h=0:1:8760;
plot(h,coal(h), h,gascc(h),h,gasgt(h), h, wind(h));
grid minor on
legend("coal","gascc", "gasgt", "wind")   

 # Comment: Define Function:
function y = findintersect(s1,i1,s2,i2)
  y= -(i1-i2)/(s1-s2);   
endfunction

# Calculate intersections

y1 = findintersect(slope(2), intercept(2),slope(1) , intercept(1) )
y2 = findintersect(slope(2), intercept(2),slope(3) , intercept(3) )

Duration(y1)
%

plot(h, Duration(h),[y2,y2],[0,Duration(y2)],[y1,y1],[0,Duration(y1)] );
%hold on
%plot([1823,1823],[0,21295]);
%grid minor on
legend("Duration", "Load following","baseload")   


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% fixed total cost
% The fixed component of costs is simply given by the optimal capacity for the asset multiplied by the annualized capital cost. 

%% Basedload
Duration(y1) * intercept(1)



%% Peaking
(24000-Duration(y2)) * intercept(3)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% variable total cost
%% To determine the operating costs, we first find the megawatt hours that the asset is expected to operate during the year. This is given by the area underneath the load duration curve in the bottom panel of Figure 3.

%% Basedload
(Duration(y1) * 8760- 0.5*(Duration(y1)-11000)*(8760-y1))* slope(1)

%% load following

((Duration(y2) -Duration(y1) ) * y1  -  0.5*(y1-y2)* (Duration(y2) -Duration(y1) ) )* slope(2)

% Peaking
(24000-Duration(y2)) * y2 * slope(3) * 0.5



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% tax without nuclear
slope = xlsread('TaxVsFITtest.xlsx', 'taxwtnuclear', 'E3:E7');
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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tax with nuclear
slope = xlsread('TaxVsFITtest.xlsx', 'tax', 'E3:E7');

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

slope = xlsread('TaxVsFITtest.xlsx', 'fit', 'F3:F7');


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







