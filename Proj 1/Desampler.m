function [OutTable] = Desampler(Table,destSize)
%DESAMPLER Summary of this function goes here
%   Detailed explanation goes here
OutTable=zeros(1 , destSize);
[sa,sb]=size(Table);
TabSize=1;
if sa>sb
    TabSize=sa;
else
    TabSize=sb;
end;
TabSize
if TabSize>destSize
Divider=TabSize/destSize;
else
    OutTable=Table;
    return;
end;
Divider=ceil(2*Divider)/2
for i=1:destSize

if i*Divider>TabSize
    return;
end;
OutTable(i)=Table(i*Divider);
end;

end

