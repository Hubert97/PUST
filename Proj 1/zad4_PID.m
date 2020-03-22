clear all;

%inicjalizacja
%Punkt Pracy
Upp=1.5;
Ypp=2.2;

%Ograniczenia
u_min=1;
u_max=2;
delta_umax=0.1;
%r2=3; r1=-7.14; r0=4.26;

kk=400; %d³ugoœæ symulacji

%deklaracja wektorów sygna³ów oraz b³êdów
U=zeros(1, kk);
U(:)=Upp;
Y=zeros(1, kk);
Y(1:12)=Ypp;

e=zeros(1, kk);
yzad=zeros(1, kk);
yzad(round(kk/8):kk)=2.5;
yzad=yzad-Ypp;

%K_kryt=-2.78; T_kryt=17;

K=1;
%Ti=T_kryt/2;
%Td=T_kryt/8;
%T=0.5;

%r2=K*Td/T;
%r1=K*(T/(2*Ti)-2*Td/T-1);
%r1=K*
%r0=K*(1+T/(2*Ti)+Td/T);

for k=12:kk %g³ówna pêtla symulacyjna
    %symulacja obiektu    
    Y(k)=symulacja_obiektu5Y(U(k-10),U(k-11),Y(k-1),Y(k-2));
    Y(k)=Y(k)-Ypp;
    %uchyb regulacji
    e(k)=yzad(k)-Y(k);
    %sygna³ steruj¹cy regulatora PID
    %u(k)=K_kryt*e(k);
    %U(k)=r2*e(k-2)+r1*e(k-1)+r0*e(k)+U(k-1);
    U(k)=K*e(k);
    U(k)=U(k)+Upp;
%    delta_u=U(k)-U(k-1);
%     if delta_u>delta_umax
%         U(k)=U(k-1)+delta_umax; 
%     elseif delta_u<(-delta_umax)
%         U(k)=U(k-1)-delta_umax;
%     end
%     
%     if U(k)>u_max
%         U(k)=u_max;
%     elseif U(k)<u_min
%         U(k)=u_min;
%     end
    
end

%wyniki symulacji
figure; stairs(U);
title('Sterowanie regulatora PID'); xlabel('k'); ylabel('wartoœæ sygna³u');
figure; stairs(Y); hold on; stairs(yzad,':'); legend('wyjœcie y(k)','wartoœæ zadana');
title('Wyjœcie regulatora PID'); xlabel('k'); ylabel('wartoœæ sygna³u');