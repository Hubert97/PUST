clear all
x0 = [35, 5, 1];
lb = [1 1 1];
ub = [80 80 80];
[nastawy_DMC_fmincon,E_dmc]=fmincon((@(parameters) DMC_fun(parameters)),x0,[],[],[],[],lb,[]);
nastawy_DMC_fmincon=round(nastawy_DMC_fmincon);
%[nastawy_DMC_ga, ~, ~] = ga((@(parameters) DMC_fun(parameters)), 3, [], [], [], [], lb, ub);
%nastawy_DMC_ga=round(nastawy_DMC_ga);
save('optymalne_parametry_DMC.mat', 'nastawy_DMC_fmincon');