newsize=500;

[sa,sb]=size(Y);
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


Divider=1;
TabSize=1;
if sa>sb
    TabSize=sa;
else
    TabSize=sb;
end;
TabSize
if TabSize>newsize
Divider=TabSize/newsize;
end;
Divider=ceil(2*Divider)/2

xaxis=xaxis.*Divider;

A=[xaxis; U];
fName=['OUTu.txt'];
fileID=fopen(fName,'w');
formatSpec = '%4.4f %4.4f\n';
fprintf(fileID,formatSpec,A)
fclose(fileID);

A=[xaxis; Y];
fName=['OUTy.txt'];
fileID=fopen(fName,'w');
formatSpec = '%4.4f %4.4f\n';
fprintf(fileID,formatSpec,A)
fclose(fileID);

A=[xaxis; yzad ];
fName=['OUTyzad.txt'];
fileID=fopen(fName,'w');
formatSpec = '%4.4f %4.4f\n';
fprintf(fileID,formatSpec,A);
fclose(fileID);