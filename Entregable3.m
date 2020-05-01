%==================
%|| Entregable 3 ||
%===================
% Instrucciones: Simulación computacional del campo eléctrico, en MATLAB, 
% producido por dos electrodos de placas planas, paralelas, de 
% carga opuesta y el usuario podrá modificar el tamaño de una de las placas. 
% En un recuadro de la simulación, el usuario podrá especificar las 
% coordenadas (x,y,z) de un punto entre las placas, y se debe mostrar en 
% ese mismo recuadro los valores de las componentes (Ex,Ey,Ez) del 
% campo eléctrico en ese punto.
% ------------------------------------------------------------------------
% Equipo:
% =======
%       - Jesus Dassaef López Barrios
%       - Ximena Valeria Cabañas Sánchez
%       - Juan Carlos Varela Téllez
%       - Alan Eduardo Aquino Rosas
%       - Tomás Ulises Peña Martínez
%-------------------------------------------------------------------------
% Notas:
% ------
%   Link de Explicación Campo Eléctrico:
%       - http://www.sc.ehu.es/sbweb/fisica3/electrico/dipolo/dipolo.html
%   Link Video YouTube:
%       - https://www.youtube.com/watch?v=k9srU6aQfL0
% -----------------------------------------------------------------------
% Última Versión Estable: 27/04/2020 22:04
%=========================================================================

%Inicio del Script
%=================

% Limpieza de pantalla y Variables
% ================================
clear; 
clc;
close all;
format longEng %Para notación científica
%=======================================
%Constantes
%==========
%Las posiciones están señaladas como constantes para que se modifiquen por
%vos cuando lo vea necesario y no en cada iteración uhh
INIT_X = 1; %<- Posición inicial en 'X'
INIT_Y = 1; %<- Posición inicial en 'Y'
%--------------------------------------
K = 8.9875517873681764e9; %<- Constante de Coulomb en Coulombs
%-------------------------------------------------
STEP = 0.1; %<<<--- STEP CONSTANT
%==================================================

%Saludos Iniciales
%====================================
disp("-----  Entregable 3  -----")
disp("==========================")
disp("-----    Saludos     -----")
disp("--------------------------")
%=========================================================================

%Inputs
%======

%Número de Cargas
%-----------------
RECOM = num2str(300); %<- Número Recomendado de Cargas para el usuario //TODO
disp(" -Cargas- ")
disp("==========")
disp("Se sugiere iniciar con una cantidad de cargas aproximada de "+RECOM);
can_qs = input("Indica la cantidad de cargas (son las mismas para cada lado): ");
disp("------------------------------------------------------------------------")
%-------------------------------------------------------------------------

%Input de cada carga
%-------------------
%Ambas placas tendrán la misma carga
disp("Ambas placas tendrán la misma carga, pero con signo opuesto")
Qp=input("Indica la magnitud de la carga neta en Coulombs: ");%Q Positiva
Qn = -Qp; %Q Negativa
%------------------------------------------------------------

%Placas
%======
disp(" -Posiciones de las placas-")
disp("============================")
% Posiciones en X de ambas placas
% --------------------------------
% Dado que está establecida una 'x' inicial como constante, la segunda
% placa empezaría en la distancia introducida por el usuario
distance = 1+input("Indica la distancia entre ambos puntos en m: "); %<<-- x2
%-------------------------------------------------------------------------

% Input de tamaño de las placas
% -----------------------------
disp(" -Tamaño de las placas-")
disp("========================")
% El usuario puede decidir el tamaño de las 2 placas.
tp = 1+input("Indica el tamaño de la placa positiva en m: "); %<-- Placa Positiva
tn = 1+input("Indica el tamaño de la placa negativa en m: "); %<-- Placa Negativa
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

%Punto a ingresar
%====================
% Input de las posiciones (x,y) de la placa
% ------------------------------------------
% El usuario debe seleccionar un punto entre las placas que anteriormente
% delimitó.
disp(" -Punto en el campo-")
disp("=========================")
disp("De acuerdo a los datos anteriormente ingresados...")
disp("Debe seleccionar un punto (x,y) que se encuentre dentro de los siguientes límites:")
disp("X: De "+num2str(INIT_X)+" a "+num2str(distance));%Limites en X
disp("Y: De "+num2str(INIT_Y)+" a "+num2str(max([tp, tn])));%Limites en Y
ppx = input("Indica la posición en 'x' del punto: ");%<- Particle px
ppy = input("Indica la posición en 'y' del punto: ");%<- Particle py
%=========================================================================

%Operaciones
%===========
disp("Calculando...")

%Cálculos iniciales
%------------------
%Escala de las gráficas
%-----------------------
minP = min([tp,tn]);
maxP = max([tp,tn]);
%La mitad de la diferencia del máximo y el mínimo /2 para la escala
difference = (maxP-minP)/2;

%Para la Placa Positiva...
%------------------------------------------------------------------------
pasoP =  (tp-1)/can_qs;

%Para la Placa Negativa...
%-------------------------------------------------------------------------
pasoN =  (tn-1)/can_qs;

%Tratando de que queden simetricas las placas en la gráfica...
%-------------------------------------------------------------------------
if minP == tp
    yPos = INIT_Y + difference: pasoP: tp+difference;
    yNeg = INIT_Y: pasoN : tn;
else
    yPos = INIT_Y: pasoP: tp;
    yNeg = INIT_Y+difference: pasoN :tn+difference;
end

%Límites actuales de la gráfica
T_max= max([tp,tn])+3;
T_min= INIT_Y -3;

% Generación del 'Grid' para la gráfica
% --------------------------------------
% Constante GRID EXPANSION:De los puntos introducidos, que tanto hacia 
% arriba o hacia abajo se va a estender la gráfica general.
GRID_EXP = 10; %<<<--- GRID_EXP CONSTANT
%-------------------------------------------------------------------------
%Generación de vectores X y Y
%----------------------------
xVector = INIT_X - GRID_EXP : STEP : distance + GRID_EXP; %<- Vector X con Expansión
yVector = T_min - GRID_EXP : STEP : T_max + GRID_EXP; %<- Vector Y con Expansión
%-------------------------------------------------------------------------
%Generación de Meshgrid Final
%----------------------------
[X,Y] = meshgrid(xVector,yVector); %<<-- Meshgrid de X y Y
%-------------------------------------------------------------------------

% Generación del Campo Eléctrico
% -------------------------------
Ex = 0;
Ey = 0;

%Creación de un arreglo con los elementos de X inicial y final
xP = [INIT_X,distance];
%Encontrando la carga de cada una
qA = [Qp/can_qs,Qn/can_qs];

%Aplicación de la Ecuación de Poisson y el método de Euler
%---------------------------------------------------------
for field=1:(can_qs)
    Rx = X - distance;
    Ry = Y - yNeg(1,field);
    R = sqrt(Rx.^2 + Ry.^2).^3;

    Ex = Ex + K .* qA(2) .* Rx ./ R;
    Ey = Ey + K .* qA(2) .* Ry ./ R;
    
    Rx = X - INIT_X;
    Ry = Y - yPos(1,field);
    R = sqrt(Rx.^2 + Ry.^2).^3;

    Ex = Ex + K .* qA(1) .* Rx ./ R;
    Ey = Ey + K .* qA(1) .* Ry ./ R;
end

% Cálculo del módulo del vector
% ------------------------------
% Definido por la fórmula ||v|| = sqrt (x^2 + y^2)
E = sqrt(Ex.^2 + Ey.^2);
%------------------------------------------------------------------------

% Encontrando las componentes del punto
% --------------------------------------
%Busca el indice en el vector X donde sea igual al punto.
index = [0,0];
[row,col] = size(X);
for i = 1:row %Por cada fila...
   for j = 1:col %Por cada columna...
    %Si el valor en X es muy parecido...
    if (X(i,j) <= ppx+0.000001) && (X(i,j)>= ppx-0.000001)
       %Si el valor en Y es muy parecido...
       if (Y(i,j) <= ppy+0.000001) && (Y(i,j)>= ppy-0.000001)
           %iguala el index
            index = [i,j];
       end
    end
   end
end
%------------------------------------------------------------------------

%Encuentra las componentes en Ex y Ey
%------------------------------------------------------------------------
xComP = Ex(index(1),index(2));
yComP = Ey(index(1),index(2));
%Componentes en vector unitario
xComPD = xComP./sqrt(xComP.^2 + yComP.^2);
yComPD = yComP./sqrt(xComP.^2 + yComP.^2);
%-------------------------------------------------------------------------

% Componentes 'u' y 'v' para quiver
% ----------------------------------
% Con el fin de 'estandarizar' el tamaño de los vectores en la gráfica,
% se divide el componente entre 3l módulo del vector.
u = Ex./E; %<<-- Componente en 'X' / Módulo del Vector
v = Ey./E; %<<-- Componente en 'Y' / Módulo del Vector
%------------------------------------------------------------------------
%========================================================================

%Gráficas
%========
disp("Graficando...")
% Gráfica del campo vectorial con quiver
% --------------------------------------
quiver(X,Y,u,v,'autoscalefactor',0.8);
hold on
%streamline(X,Y,u,v,INIT_X,INIT_Y);
%------------------------------------------------------------------------

% Gráfica de las 'placas'
% -----------------------
for Tetha=1:can_qs
    hold on
    plot(INIT_X,yPos(1,Tetha),'or');
    hold on
    plot(distance,yNeg(1,Tetha),'ob');
    hold on
end
%-------------------------------------------------------------------------

%Gráfica del Punto
%------------------------
p = plot(ppx,ppy,'og');
%fill(ppx,ppy,'g');
a = 0.02;
h=rectangle('Position',[ppx-a/2,ppy-a/2,a,a],'curvature',[1 1]);
set(h,'Facecolor',[0 1 0],'Edgecolor',[0 1 0]);
%-------------------------------------------------------------------------

%Datos y texto de la partícula
disp("---------------------")
disp("|| Punto Ingresado ||");
disp("---------------------")
disp("("+num2str(ppx)+" , "+num2str(ppy)+")");
disp("Componentes del campo eléctrico:")
disp("================================")
fprintf('Ex: %d N/C .\n',xComP)
fprintf('Ey: %d N/C .\n',yComP)
disp("------------------")
disp("Componentes en vector unitario gráfica")
disp("--------------------------------------")
disp("X: "+num2str(xComPD))
disp("Y: "+num2str(yComPD))
disp("========================================");
%-------------------------------------------------------------------------
msgX  = "Ex: "+sprintf('%0.5e',xComP)+" N/C";
msgY = "Ey: "+sprintf('%0.5e',yComP)+" N/C";
text(ppx,ppy-0.03,msgX,'FontSize',12);
text(ppx,ppy-0.07,msgY,'FontSize',12);

disp("Recuerda hacer zoom al punto para ver las componentes...")

axis equal
%Fin de la gráfica
hold off
%=========================================================================
%Final del Programa
disp("¡Hasta la próxima!")
disp("   -FIN DEL PROGRAMA-    ")
disp("=========================")
%========================================================================