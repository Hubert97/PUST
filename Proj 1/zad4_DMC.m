clear all
kk=1500;
load('gotowa_odp_skokowa.mat', 'gotowa_odp_skokowa');
transpose(gotowa_odp_skokowa);
%inicjalizacja
%Punkt Pracy
Upp=1.5;
Ypp=2.2;

%Ograniczenia
u_min=1-Upp;
u_max=2-Upp;
delta_u_max=0.1;

lambda=1; %parametr lambda np. 1
D=200; %horyzont dynamiki (D)
N=50;%horyzont predykcji (N)
Nu=30; %horyzont sterowania (Nu)(ilosc przyszlych przyrostow wartosci sterowania)

%D=200; N=50; Nu=10; % robocze parametry

%deklaracja wektor�w sygna��w oraz b��d�w
U=zeros(1, kk);
u=zeros(kk-N);
U(:)=Upp;
e=zeros(1, kk);
Y=zeros(1, kk);
y=zeros(1, kk);
Y(1:12)=Ypp;

yzad=zeros(1, kk);
yzad(1:round(kk/5))=2.5;
yzad(round(kk/5):round(2*kk/5))=2.1;
yzad(round(2*kk/5):round(3*kk/5))=2;
yzad(round(3*kk/5):round(4*kk/5))=2.3;
yzad(round(4*kk/5):round(5*kk/5))=2.4;
yzad=yzad-Ypp;

Mp=zeros(N,D-1);        %macierz ma wymiary Nx(D-1)
for i=1:D-1 %wypelnianie macierzy Mp
   Mp(1:N, i)=gotowa_odp_skokowa(i+1:N+i)-gotowa_odp_skokowa(i);
end
%macierz wsp�czynnik�w odpowiedzi skokowej wymiary(NxNu)
M=zeros(N, Nu);  
i=0;
for j=1:Nu  %wypelnianie macierzy trojkatnej dolnej M
   M(j:N,j)=gotowa_odp_skokowa(1:N-i).';  
   i=i+1;
end

I=eye(Nu);              %tworzenie macierzy jednostkowej o wymiarach NuxNu
K=inv(M.'*M+lambda*I)*M.';   %macierz K

deltaUP(1:D-1,1)=0;
deltaU=0;
Ku=K(1,:)*Mp;

for k=12:kk-N %symulacja obiektu i regulatora
    Y(k)=symulacja_obiektu5Y(U(k-10),U(k-11),Y(k-1),Y(k-2));
    y(k)=Y(k)-Ypp;
    e(k)=yzad(k)-y(k);
    deltaUP(2:D-1)=deltaUP(1:D-2);
    deltaUP(1) = u(k-1)-u(k-2);  
    Y0=Mp*deltaUP+y(k);
    Yzad=yzad(k+1:k+N);
    deltaU=K*(Yzad-Y0);	
    delta_u=deltaU(1);

    %ograniczenie r�nic sygna�u steruj�cego 
    if delta_u>delta_u_max
         delta_u=delta_u_max; 
    elseif delta_u<(-delta_u_max)
         delta_u=-delta_u_max;
    end

    u(k)=u(k-1)+delta_u;
    %ograniczenie sygna�u steruj�cego
    if u(k)>u_max
        u(k)=u_max;
    elseif u(k)<u_min
        u(k)=u_min;
    end
     U(k)=u(k)+Upp;

end
wskaznik_jakosci=sum(e.^2);
yzad=yzad+Ypp;
%wyniki symulacji
figure(1); stairs(U(1:kk-N));hold on
title('Sygna� sterowania DMC'); xlabel('k');
figure(2); stairs(Y(1:kk-N)); hold on; 
stairs(yzad(1:kk-N),':'); xlim([0, kk-N]);     
title('Wyj�cie regulatora DMC'); xlabel('k'); ylabel('warto�� sygna�u');
legend('wyj�cie y(k)','warto�� zadana');