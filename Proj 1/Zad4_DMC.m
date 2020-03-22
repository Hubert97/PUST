kk=500;
skok=2;
load gotowa_odp_skokowa.mat
transpose(gotowa_odp_skokowa)
%DMC
    Umin=1;
    Umax=2;
    deltaUmax=0.1;
    %zaklocenie=0.5;

    lambda=1; %parametr lambda np. 1
    D=100; %horyzont dynamiki (D)
    N=100;%horyzont predykcji (N)
    Nu=100; %horyzont sterowania (Nu)(ilosc przyszlych przyrostow wartosci sterowania)

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
    
    u(1:kk)=0; 
    y(1:kk)=0; 
    yzad(1:12)=0;
    yzad(12:kk)=skok; %skok sygna�u steruj�cego

    u=zeros(kk-N);
    deltaUP(1:D-1,1)=0;
    deltaU=0;
    Ku=K(1,:)*Mp;

    for k=12:kk-N %symulacja obiektu i regulatora
        %sygna� steruj�cy regulatora DMC
        y(k)=symulacja_obiektu5Y(u(k-10),u(k-11),y(k-1),y(k-2));
        
        %symulacja zak��cenia 
%         if k>100    
%             y(k)=y(k)+zaklocenie;
%         end

        deltaUP(2:D-1)=deltaUP(1:D-2);
        deltaUP(1) = u(k-1)-u(k-2);  
        Y0=Mp*deltaUP+y(k);
        Yzad=yzad(k+1:k+N);
        deltaU=K*(Yzad-Y0);	
        u(k)=u(k-1) + deltaU(1);
        
        %ograniczenia sygna�u steruj�cego
        
        if u(k)>Umax  
            u(k)=Umax;
        end
        
        if u(k)<Umin 
            u(k)=Umin;
        end
        
        if u(k)-u(k-1) >deltaUmax
            u(k)=u(k-1)+deltaUmax;
        end
        
        if u(k)-u(k-1) <-deltaUmax 
            u(k)=u(k-1)-deltaUmax;
        end
        
    end
%wyniki symulacji
    figure(1); stairs(u(1:kk-N));hold on
%      ylim([-1,3]);
    title('Sygna� sterowania DMC'); xlabel('Pr�bka');
    figure(2); stairs(y(1:kk-N)); hold on; 
    stairs(yzad(1:kk-N),':');      ylim([-1,3]);
    title('wyj�cie regulatora DMC'); xlabel('Pr�bka'); ylabel('Sygna� wyj�ciowy');
    legend('Wartosc wyjscia','y zadane');