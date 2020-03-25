clear all;
%Dlugosc symulacji
kk=300;
%Ograniczenia
u_min=1;
u_max=2;
%Punkt Pracy
U_pp=1.5;
Y_pp=2.2;

U=zeros(1, kk);
U(:)=U_pp;

Y=zeros(1, kk);
Y(1:11)=Y_pp;

ilosc_iteracji=round(u_max-(U_pp+0.1))/0.1; %obliczenie ile iteracji trzba, zeby przejsc od 
                                            % Upp+0.1=1.6 do u_max=2 z krokiem
                                            % równym 0.1 (tak wiem, ¿e 5
                                            % xd)
                                            
odp_skok_tablica=zeros(ilosc_iteracji, kk);  %macierz do której wierszy zapisywane bêd¹ kolejne odpowiedzi skokowe
sterowanie=zeros(ilosc_iteracji, kk);  %macierz do której wierszy zapisywane s¹ kolejne  przebiegi sygna³u steruj¹cego
l=1;
for j=(U_pp+0.1):0.1:u_max
    U(20:kk)=j;
    sterowanie(l,:)=U;
    for k=1:kk
       if k>11
            Y(k)=symulacja_obiektu5Y(U(k-10),U(k-11),Y(k-1),Y(k-2));  
       end
    end
    odp_skok_tablica(l,:)=Y;
    l=l+1;
end

%CHARAKTERYSTYKA STATYCZNA
for i=1:600
   U(12:kk)=i*0.005;
   for k=12:kk
       Y(k)=symulacja_obiektu5Y(U(k-10),U(k-11),Y(k-1),Y(k-2));
   end
   Ustat(i)=U(kk);
   Ystat(i)=Y(kk);
   
end
%WZMOCNIENIE STATYCZNE
Kstat=(Ystat(400)-Ystat(200))/(Ustat(400)-Ustat(200));

%%%%%%%%%%%%%%%%WYKRESY%%%%%%%%%%%%%%%%%%

%WYKRES CHARAKTERYSTYKI STATYCZNEJ
plot(Ustat,Ystat);
xlabel('U');
ylabel('Y');
title('Charakterystyka statyczna Y(U)');

%WYKRES ODPOWIEDZI SKOKOWEJ I SKOKU SYGNA£U
figure

subplot(2,1,1);
hold on
stairs(odp_skok_tablica(5,:));
stairs(odp_skok_tablica(4,:)); 
stairs(odp_skok_tablica(3,:)); 
stairs(odp_skok_tablica(2,:)); 
stairs(odp_skok_tablica(1,:));  
hold off
title('Wyjcie y(k)');
xlabel('k');
ylabel('wartoæ sygna³u');
legend('\DeltaU=0.5','\DeltaU=0.4', '\DeltaU=0.3', '\DeltaU=0.2', '\DeltaU=0.1');

subplot(2,1,2);
hold on
stairs(sterowanie(5,:));
stairs(sterowanie(4,:)); 
stairs(sterowanie(3,:)); 
stairs(sterowanie(2,:)); 
stairs(sterowanie(1,:)); 
hold off
title('Sygna³ steruj¹cy u(k)');
xlabel('k');
ylabel('wartoæ sygna³u');


%%% Zadanie 3 - Odpowiedz skokowa gotowa do dmc
gotowa_odp_skokowa=(odp_skok_tablica(5,21:kk)-Y_pp)/(2-1.5);
figure
stairs(gotowa_odp_skokowa);
title('Odpowied skokowa');
xlabel('k');
xlim([0 kk-20]);
ylabel('wartoæ sygna³u wyjciowego');