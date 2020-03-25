function tabl_to_txt(U,NAME_STR,newsize)
%TABL_TO_TXT Summary of this function goes here
%   Detailed explanation goes here
xaxis=[1:newsize];

U=Desampler(U,newsize);
fName=NAME_STR;
fileID=fopen(fName,'w');
formatSpec = '%4.4f %4.4f\n';

A=[xaxis; U];
fprintf(fileID,formatSpec,A);
fclose(fileID);



end

