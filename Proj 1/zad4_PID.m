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

kk=1200; %d³ugoœæ symulacji

%deklaracja wektorów sygna³ów oraz b³êdów
U=zeros(1, kk);
u=zeros(1, kk);
U(:)=Upp;
Y=zeros(1, kk);
y=zeros(1, kk);
Y(1:12)=Ypp;

e=zeros(1, kk);
yzad=zeros(1, kk);
yzad(1:kk)=2.3;
yzad=yzad-Ypp;

K_kryt=5.03; T_kryt=0;
K=5.03; Ti=inf; Td=0; %niegasnace oscylacje
%K=K_kryt*0.5; Ti=10; Td=0; 

%Td=T_kryt/8;
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
    %u(k)=K_kryt*e(k);
    %u(k)=r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);
    delta_u=r2*e(k-2)+r1*e(k-1)+r0*e(k);
    %u(k)=K*e(k)+u(k-1);
        
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
wskaznik_jakosci=sum(e.^2);
%wyniki symulacji
figure; stairs(U);
title('Sterowanie regulatora PID'); xlabel('k'); ylabel('wartoœæ sygna³u');
figure; stairs(Y); hold on; stairs(yzad+Ypp,':'); legend('wyjœcie y(k)','wartoœæ zadana');
title('Wyjœcie regulatora PID'); xlabel('k'); ylabel('wartoœæ sygna³u');