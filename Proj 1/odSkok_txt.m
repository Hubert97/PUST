newsize=300;

hold on
stairs(odp_skok_tablica(5,:));
stairs(odp_skok_tablica(4,:)); 
stairs(odp_skok_tablica(3,:)); 
stairs(odp_skok_tablica(2,:)); 
stairs(odp_skok_tablica(1,:));  
hold off
title('Wyjœcie y(k)');
xlabel('k');
ylabel('wartoœæ sygna³u');
legend('\DeltaU=0.5','\DeltaU=0.4', '\DeltaU=0.3', '\DeltaU=0.2', '\DeltaU=0.1');



for i=1:5
    str=['skok i =' num2str(i) '.txt']
    tabl_to_txt(odp_skok_tablica(5,:),str,newsize);
    
end;
