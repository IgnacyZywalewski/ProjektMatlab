%Projekt: pole elektryczne wokół naładowanego koła


%Parametry układu

% zakres osi 
x1 = -10;
x2 = 10;
y1 = -10;
y2 = 10;

% liczba punktów na jaką dzielimy koło
n = 100;

% promień koła
r = 5;

% pozycja
position = [0, 0];

% całkowity ładunek stałej gęstości powierzchniowej σ
charge = 10e-9;

% stała elektrostatyczna
k = 9e9;



%Podział koła

% powierzchnia pojedyńczego punktu
point_area = (x2-x1)/(n-1) * (y2-y1)/(n-1);

% pole koła
area = pi*r^2;

% obliczenie ile punktów zmieści się w kole
number_of_points = area/point_area;

% obliczenie ładunku pojedyńczego punktu
point_charge = charge/number_of_points;



%Stworzenie koła

% siatka
[X, Y] = meshgrid(linspace(x1, x2, n), linspace(y1, y2, n));

% wzór na koło
Z = (X-position(1)).^2 + (Y-position(2)).^2 - r^2;

% normalizacja
Z = abs(Z)./Z;

% transformacja żeby wnętrze koła było równe 1, a to co na zewnątrz równe 0
Z = (-Z+1)/2;

% wysokość koła ustawiamy na równą wartości pojedyńczego ładunku
Z = Z*point_charge;



%Oblicznie potencjału elektrycznego 

% Inicjalizacja tablicy na potencjał
phi_total = zeros(n, n);

for i = 1:numel(Z) % Pętla przechodząca przez wszystkie punkty siatki
    % Obecny punkt
    point = [X(i), Y(i)];

    % Odległość pomiędzy obecnym punktem, a środkiem koła
    radius = sqrt((point(1) - position(1))^2 + (point(2) -  position(2))^2);

    % Obliczenie potencjału wewnątrz koła
    phi_total(i) = k * Z(i) / radius; 
end



%Wykres potencjału elektrycznego

% Wyświetlanie wykresu potencjału
figure;
contourf(X, Y, phi_total);
colorbar;
title('Rozkład potencjału elektrycznego w kole');
xlabel('x');
ylabel('y');



%Oblicznie natężenia pola elektrycznego 

% inicjalizacja tablic 
E_x_total = zeros(n, n);
E_y_total = zeros(n, n);

for i = 1:numel(Z) % pętla przechodząca przez wszystkie puntky siatki
  % obecny punkt
  point = [X(i), Y(i)];

  % odległość pomiędzy obecnym punktem, a resztą punktów
  r_x = X-point(1);
  r_y = Y-point(2);

  % prawdziwa odległość pomiędzy obecnym punktem, a resztą punktów
  r_c = sqrt((r_x.^2 + r_y.^2));

  % siła pola elektrycznego wytwarzanego przez ten punkt (lokalizacja w tablicy) w bieżącym punkcie (ten powyżej)
  E_x = (k * Z .* r_x ./ r_c.^3);
  E_y = (k * Z .* r_y ./ r_c.^3);

  % we wzorze jest dzielenie przez 0 i powstaje trochę NaN, więc się ich pozbywamy
  E_x(i) = 0;
  E_y(i) = 0;

  % sumujemy wyniki wszystkich pól elektrycznych i otrzymujemy końcowe pole elektryczne działające na bieżący punkt
  E_x_total(i) = sum(E_x(:));
  E_y_total(i) = sum(E_y(:));
end

% sumujemy pole działające w kierunkach x i y dla wykresu 3d natężenia pola elektrycznego
E_total = sqrt(E_x_total.^2 + E_y_total.^2);



%Wyresy natężenia pola elektrycznego

% wykres 3D

% nie jestem pewien czy jest potrzebny bo mamy narysowac rozklady natezenia
% i potencjalu w plaszczyznie
figure;
mesh(X, Y, E_total)
%title('')
xlabel("X")
ylabel('Y')
zlabel("Z")

% wykres kierunków natężenia pola
figure;
quiver(X, Y, E_x_total, E_y_total)
title('Rozkład natężenia pola elektrycznego')
xlabel("X")
ylabel('Y')



%Zadanie 2.

% Promień koła
r = 5;

% Całościowy ładunek q
charge = 10e-9;

% Powierzchnia koła (dysku)
area = pi*r^2;

% Stała elektrostatyczna
k = 9*10^9;

% Przedział z, dla którego obliczamy potencjał
z = linspace(1, 30, 100);

% Powierzchniowa gęstość ładunku (mała sigma)
surface_charge_density = charge/area;

% Potencjał w odległości z dla ładunku punktowego
V = (k*charge)./z;

% Potencjał w odległości z dla jednorodnie naładowanego dysku
Vp = k*2*pi*surface_charge_density*(sqrt((z.^2)+(r^2))-sqrt(z.^2));

% Wykres
figure
hold on
plot(z, Vp)
plot(z, V)
scatter(z(66), V(66), MarkerFaceColor='black', MarkerEdgeColor='black', Marker='o')
hold off

% Legenda wykresu
%title('')
xlabel('Odległość r [m] w płaszczyźnie z')
ylabel('Wartość potencjału Vp [V]')
legend('Vp jednorodnie naładowanego dysku', 'Vp ładunku punktowego', 'Punkt spotkania krzywych')

% Mniej więcej dla odległości 20 metrów można uznać taki dysk za ładunek punktowy
