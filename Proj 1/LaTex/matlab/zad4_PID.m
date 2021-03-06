clear all;
%inicjalizacja
%Punkt Pracy
Upp=1.5;
Ypp=2.2;

%Ograniczenia
u_min=1;
u_max=2;
delta_umax=0.1;
u_max=u_max-Upp;
u_min=u_min-Upp;

kk=1500; %d³ugoæ symulacji

%deklaracja wektorów sygna³ów oraz b³êdów
U=zeros(1, kk);
u=zeros(1, kk);
U(:)=Upp;
Y=zeros(1, kk);
y=zeros(1, kk);
Y(1:12)=Ypp;

e=zeros(1, kk);
yzad=zeros(1, kk);
yzad(1:round(kk/5))=2.5;
yzad(round(kk/5):round(2*kk/5))=2.1;
yzad(round(2*kk/5):round(3*kk/5))=2;
yzad(round(3*kk/5):round(4*kk/5))=2.3;
yzad(round(4*kk/5):round(5*kk/5))=2.4;
yzad=yzad-Ypp;

load('optymalne_parametry_PID.mat');
K_kryt=5.03; T_kryt=0;
%K=5.03; Ti=inf; Td=0; %niegasnace oscylacje
%K=K_kryt*0.5; Ti=22; Td=7; %NAJLEPSZE EKSPERYMENTALNE PARAMETRY

K=nastawy_PID_fmincon(1); Ti=nastawy_PID_fmincon(2); Td=nastawy_PID_fmincon(3);  %parametry dobrane funkcj¹ fmincon
%K=nastawy_PID_ga(1); Ti=nastawy_PID_ga(2); Td=nastawy_PID_ga(3); %parametry dobrane przez
                                                    %funkcje ga()
T=0.5;

r2=K*Td/T;
r1=K*(T/(2*Ti)-2*Td/T-1);
r0=K*(1+T/(2*Ti)+Td/T);

for k=12:kk %g³ówna pêtla symulacyjna
    %symulacja obiektu    
    Y(k)=symulacja_obiektu5Y(U(k-10),U(k-11),Y(k-1),Y(k-2));
    y(k)=Y(k)-Ypp;
    %uchyb regulacji
    e(k)=yzad(k)-y(k);
    %sygna³ steruj¹cy regulatora PID
    %u(k)=r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);
    delta_u=r2*e(k-2)+r1*e(k-1)+r0*e(k);
        
    if delta_u>delta_umax
         delta_u=delta_umax; 
    elseif delta_u<(-delta_umax)
         delta_u=-delta_umax;
    end
     u(k)=delta_u+u(k-1);
    if u(k)>u_max
        u(k)=u_max;
    elseif u(k)<u_min
        u(k)=u_min;
    end
     U(k)=u(k)+Upp;
end
yzad=yzad+Ypp;
wskaznik_jakosci=sum(e.^2);
%wyniki symulacji
figure; stairs(U);
title('Sterowanie regulatora PID'); xlabel('k'); ylabel('wartoæ sygna³u');
figure; stairs(Y); hold on; stairs(yzad,':'); legend('wyjcie y(k)','wartoæ zadana');
title('Wyjcie regulatora PID'); xlabel('k'); ylabel('wartoæ sygna³u');