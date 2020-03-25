newsize=500;

Y=Y(1:kk-N);
U=U(1:kk-N);
yzad=yzad(1:kk-N)
Y=Desampler(Y,newsize);
U=Desampler(U,newsize);
yzad=Desampler(yzad,newsize);
%wyniki symulacji
figure; stairs(U);hold on
title('Sygna³ sterowania DMC'); xlabel('k');
figure; stairs(Y); hold on; 
stairs(yzad,':'); xlim([0, newsize]);     
title('Wyjœcie regulatora DMC'); xlabel('k'); ylabel('wartoœæ sygna³u');
legend('wyjœcie y(k)','wartoœæ zadana');
xaxis=[1:newsize];

A=[xaxis; U];
fName=['DMCu.txt'];
fileID=fopen(fName,'w');
formatSpec = '%4.4f %4.4f\n';
fprintf(fileID,formatSpec,A)
fclose(fileID);

A=[xaxis; Y];
fName=['DMCy.txt'];
fileID=fopen(fName,'w');
formatSpec = '%4.4f %4.4f\n';
fprintf(fileID,formatSpec,A)
fclose(fileID);

A=[xaxis; yzad ];
fName=['DMCyzad.txt'];
fileID=fopen(fName,'w');
formatSpec = '%4.4f %4.4f\n';
fprintf(fileID,formatSpec,A);
fclose(fileID);