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
U(1:kk)=U_pp;
Y=zeros(1, kk);
Y(1:11)=Y_pp;

for k=1:kk
   if k>11
        Y(k)=symulacja_obiektu5Y(U(k-10),U(k-11),Y(k-1),Y(k-2));  
   end
end

%WYKRESY
    figure 
    subplot(2,1,1);
    stairs(Y);    
    title('Wyjcie y(k)');
    xlabel('k');
    ylabel('wartoæ sygna³u');
    
    subplot(2,1,2);
    stairs(U);    
    title('Sygna³ steruj¹cy u(k)');
    xlabel('k');
    ylabel('wartoæ sygna³u');

    
   