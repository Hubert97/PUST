kk=1200;
skok=2;
load gotowa_odp_skokowa.mat
transpose(gotowa_odp_skokowa)
%inicjalizacja
%Punkt Pracy
Upp=1.5;
Ypp=2.2;

%Ograniczenia
u_min=1;
u_max=2;
delta_u_max=0.1;
u_max=u_max-Upp;
u_min=u_min-Upp;

%DMC
    u_min=1;
    u_max=2;
    delta_u_max=0.1;
    %zaklocenie=0.5;

    lambda=1; %parametr lambda np. 1
    D=100; %horyzont dynamiki (D)
    N=100;%horyzont predykcji (N)
    Nu=100; %horyzont sterowania (Nu)(ilosc przyszlych przyrostow wartosci sterowania)
    
%deklaracja wektorów sygna³ów oraz b³êdów
    U=zeros(kk-N);
    u=zeros(kk-N);
    U(:)=Upp;
    Y=zeros(1, kk);
    y=zeros(1, kk);
    Y(1:12)=Ypp;

    Yzad=zeros(1, kk);
    yzad=zeros(1, kk);
    yzad(12:kk)=skok;
    Yzad=yzad-Ypp;

    Mp=zeros(N,D-1);        %macierz ma wymiary Nx(D-1)
    for i=1:D-1 %wypelnianie macierzy Mp
       Mp(1:N, i)=gotowa_odp_skokowa(i+1:N+i)-gotowa_odp_skokowa(i);
    end
    %macierz wspó³czynników odpowiedzi skokowej wymiary(NxNu)
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
        %sygna³ steruj¹cy regulatora DMC
        Y(k)=symulacja_obiektu5Y(U(k-10),U(k-11),y(k-1),y(k-2));
        y(k)=Y(k)-Ypp
        %symulacja zak³ócenia 
%         if k>100    
%             y(k)=y(k)+zaklocenie;
%         end

        deltaUP(2:D-1)=deltaUP(1:D-2);
        deltaUP(1) = u(k-1)-u(k-2);  
        Y0=Mp*deltaUP+y(k);
        YZAD=yzad(k+1:k+N);
        deltaU=K*(YZAD-Y0);	
        delta_u=deltaU(1)
        
        %ograniczenie ró¿nic sygna³u steruj¹cego 
        if delta_u>delta_u_max
             delta_u=delta_u_max; 
        elseif delta_u<(-delta_u_max)
             delta_u=-delta_u_max;
        end

        u(k)=u(k-1) + deltaU(1);
        %ograniczenie sygna³u steruj¹cego
        if u(k)>u_max
            u(k)=u_max;
        elseif u(k)<u_min
            u(k)=u_min;
        end
         U(k)=u(k)+Upp;
          
    end
%wyniki symulacji
    figure(1); stairs(u(1:kk-N));hold on
%      ylim([-1,3]);
    title('Sygna³ sterowania DMC'); xlabel('Próbka');
    figure(2); stairs(y(1:kk-N)); hold on; 
    stairs(yzad(1:kk-N),':');      ylim([-1,3]);
    title('wyjœcie regulatora DMC'); xlabel('Próbka'); ylabel('Sygna³ wyjœciowy');
    legend('Wartosc wyjscia','y zadane');