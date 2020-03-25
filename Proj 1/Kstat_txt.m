newsize=600;


%xaxis=xaxis.*Divider;
xaxis=Ustat
Y=Ystat;

A=[xaxis; Y];
fName=['OUTy.txt'];
fileID=fopen(fName,'w');
formatSpec = '%4.4f %4.4f\n';
fprintf(fileID,formatSpec,A)
fclose(fileID);

