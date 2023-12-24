% napisane w octave

%
%  grid paremeters
%

% from where to where
x1 = -10;
x2 = 10;
y1 = -10;
y2 = 10;

% number of points
n = 100;


%
%  circle parameters
%

% size
r = 5;

% position
position = [0, 0];

% charge of the whole circle
charge = 10e-9;

%
%  calculating the charge of the single point inside the circle
%

% point "area"
point_area = (x2-x1)/(n-1) * (y2-y1)/(n-1);

% circle area
area = pi*r^2;

% how many points are in the circle
number_of_points = area/point_area;

% charge of the single point
point_charge = charge/number_of_points;

%
% making the circle
%

% grid
[X, Y] = meshgrid(linspace(x1, x2, n), linspace(y1, y2, n));

% circle equation
Z = (X-position(1)).^2 + (Y-position(2)).^2 - r^2;

% normalization(?)
% basically everything positive goes to 1 and everything negative goes to -1 and 0 goes to undefined :(
Z = abs(Z)./Z;

% some transformations to make the inside of the circle equal to 1 and outside equal to 0
Z = (-Z+1)/2;

% we make the height of the circle equal to the point charge and we are done
Z = Z*point_charge;

% because we are using abs(x)/x if we choose the paremeters just right we can NaN'd some values
% and at the end the total charge of all the points will not add up to the inputed charge at the start
% but I'd say that we can ignore those situations. mathematical proof or something below:
% limit from 0 to infinity of area/perimeter = 0 so those few points can be safely ignored when n is large enough

%plot of our circle
%mesh(X, Y, Z)

%
%  calculating the field
%

% some constants
k = 9e9;

% initialization of some arrays that get their value from a loop
E_x_total = zeros(n, n);
E_y_total = zeros(n, n);


for i = 1:numel(Z) % loop through all points on the grid
  % current point
  point = [X(i), Y(i)];

  % distances from the current point to all others
  r_x = X-point(1);
  r_y = Y-point(2);

  % true distance from this one to all others
  r = sqrt((r_x.^2 + r_y.^2));

  % strength of the electric field that this point(location in the array) produces in current point(this one above)
  E_x = (k * Z .* r_x ./ r.^3);
  E_y = (k * Z .* r_y ./ r.^3);

  % there is division by 0 in the formula and it procudes some NaNs so we get rid of them
  E_x(i) = 0;
  E_y(i) = 0;

  % we sum all electric fields results go get the final electric field that acts upon current point
  E_x_total(i) = sum(E_x(:));
  E_y_total(i) = sum(E_y(:));
end
% we sum the field acting in x and y directions for the 3d plot of the strength of the electric field
E_total = sqrt(E_x_total.^2 + E_y_total.^2)

figure;
mesh(X, Y, E_total)

%plot of the directions of the field
figure;
quiver(X, Y, E_x_total, E_y_total)

% wydaje mi się że jest dobrze zrobione ale idk jak wygląda pole w środku obiektów więc nie jestem 100% pewien



