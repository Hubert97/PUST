x0 = [2.5, 22, 7];
lb = [1 1 0.1];
ub = [80 80 80];
[nastawy_PID_fmincon,E]=fmincon((@(parameters) PID_fun(parameters)),x0,[],[],[],[],lb,ub);
[nastawy_PID_ga, ~, ~] = ga((@(parameters) PID_fun(parameters)), 3, [], [], [], [], [0 0.1 0], []);
save('optymalne_parametry_PID.mat', 'nastawy_PID_fmincon', 'nastawy_PID_ga');

