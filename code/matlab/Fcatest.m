clear all; 

%% 3D plot with force magnitude

step = 0.3;
[X,Y] = meshgrid(-40:step:40,-40:step:40);
X=X';
Y=Y';
lenx=length(X(:,1));
leny=length(Y(1,:));
Ftot = zeros(lenx, leny,2);
rsav = 5;
vl = [10,10];
pi0 = [2,2];
Kvl = 1;
Kij = 0.1;
Kca = 200;
Koa = 200;

Fijmagn = zeros(lenx,leny);
Fcamagn = zeros(lenx,leny);
Foamagn = zeros(lenx,leny);

for m = 1:lenx;
    for n = 1:leny;
        pi = [X(m,1),Y(1,n)];
        Fvl = Kvl*(vl-pi-(vl-pi0));
        Fvlmagn(m,n) = norm(Fvl);

        pj(1,1:2) = [10 , 5];
        pj(2,1:2) = [15 , 0];
        pj(3,1:2) = [-20 , 20];
        pj0(1,1:2) = [-5 , -1];
        pj0(2,1:2) = [15 , 0];
        pj0(3,1:2) = [-10 , 10];
        for j = 1:length(pj)
            Fij(j,1:2) = Kij*(pj(j,1:2)-pi-(pj0(j,1:2)-pi0));
            dij(j,1:2) = pj(j,1:2) - pi;%0,-1
%             d0ij(j,1:2) = pj0(j,1:2) - pi0;%-7,-3
%             Fij(j,1:2) = Kij*(dij(j,1:2)-(d0ij(j,1:2)));%7,3
            Fijmagn(m,n) = Fijmagn(m,n) + norm(Fij(j,1:2));
        end
        
        for j = 1:length(pj)
            if norm(dij(j,1:2)) < rsav
                Fca = ((Kca*rsav)/norm(dij(j,1:2))-Kca)*(dij(j,1:2)/norm(dij(j,1:2)));
            else
                Fca = 0;
            end
        Fcamagn(m,n) = Fcamagn(m,n) + norm(Fca);
        end
        
        po(1,1:2) = [-6,-6];
        po(2,1:2) = [-2,-2];
        po(3,1:2) = [5,15];
        for j = 1:length(po)
            dki(j,1:2) = po(j,1:2) - pi;
            if norm(dki(j,1:2)) < rsav
                Foa = (Koa/norm(dki(j,1:2))-Koa/rsav)*(dki(j,1:2)/norm(dki(j,1:2)));
            else
                Foa = 0;
            end
        Foamagn(m,n) = Foamagn(m,n) + norm(Foa);
        end
        
        Fmax = 100;
        Ftotmagn(m,n) = Fvlmagn(m,n)+Fijmagn(m,n)+Fcamagn(m,n)+Foamagn(m,n);
        Ftotmagn(m,n) = min([norm(Ftotmagn(m,n)),Fmax])*Ftotmagn(m,n)/norm(Ftotmagn(m,n));
        
        if isnan(Ftotmagn(m,n))
            Ftotmagn(m,n)  = Fmax;
        end
    end
end

figure(1)
clf;
hold on
axis equal
density = 10;
[xvel,yvel] = gradient(-Fvlmagn(1:density:m,1:density:n),step,step);
% contour(X, Y, Fvlmagn);
% quiver(X(1:density:m,1:density:n), Y(1:density:m,1:density:n),xvel,yvel);
title('Contour and quiver plot of Fvl')
hold off
figure(2)
clf;
hold on
surf(X, Y, Fvlmagn);
% contour(X, Y, Fvlmagn);
title('Fvlmagn')
hold off
figure(3)
clf;
hold on
surf(X,Y, Fijmagn);
axis equal
title('Fijmagn')
hold off
figure(4)
clf;
surf(X,Y,Fcamagn)
title('Fcamagn')
figure(5)
clf;
surf(X,Y,Foamagn)
title('Foamagn')
figure(6)
clf;
surf(X,Y,Ftotmagn);
title('Ftotmagn')
figure(7)
clf;
hold on
density = 4;
[totxvel,totyvel] = gradient(-Ftotmagn(1:density:m,1:density:n),step,step);
% contour(X, Y, Ftotmagn);
% quiver(X(1:density:m,1:density:n), Y(1:density:m,1:density:n),totxvel,totyvel);
clear m, clear n
% m(1) = 40;
% n(1) = 40;
% for k = 1:1000;
%     A = Ftotmagn(m(k)-1:m(k)+1,n(k)-1:n(k)+1);
%     [minval,index] = min(A(:));
%     [i,j] = ind2sub(size(A),index);
%     m(k+1) = m(k)+(i-2);
%     n(k+1) = n(k)+(j-2);
%     xny(k) = X(m(k),n(k));
%     yny(k) = Y(m(k),n(k));
% end
% plot(xny,yny,'r-*')
% plot(X(m(1),n(1)),Y(m(1),n(1)),'r*')
surf(X,Y,Ftotmagn-100,'EdgeColor','none');
axis equal
xlabel('x')
ylabel('y')
zlabel('z')
hold off









