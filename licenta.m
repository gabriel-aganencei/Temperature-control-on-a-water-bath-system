tih=420;
num=3.75;
den=[420 1];
Ts=10;
delay=90;
SYS=tf(num,den,'InputDelay',delay); %Functia de transfer continua
hd=c2d(SYS,Ts); %Functia de transfer discreta
step(SYS,hd)
Gm=tf(num,den); 
Gz=c2d(Gm,Ts);
t = 0:10:5000;                  % Interval de timp (secunde)



u = 11 * ones(size(t)); % kW

% Simularea răspunsului sistemului la intrare
[y, t_out] = lsim(SYS, u, t);

% Crearea figurii
figure;

% Subplotul 1: Ieșirea sistemului (Temperatura)
subplot(2,1,1);
plot(t_out, y, 'b', 'LineWidth', 2);
grid on;
title('Ieșirea sistemului (Temperatura)');
xlabel('Timp (s)');
ylabel('Temperatura (\circC)');
legend('T_{out}', 'Location', 'Best');

% Subplotul 2: Semnalul de intrare (Puterea)
subplot(2,1,2);
plot(t, u, 'r', 'LineWidth', 2);
grid on;
title('Semnal de intrare (Puterea încălzitorului)');
xlabel('Timp (s)');
ylabel('Putere (kW)');
legend('Q_{in}', 'Location', 'Best');

sgtitle('Sistem în buclă deschisă'); % Titlu general

%% proiectarea regulatorului
sigma=0.043;
tt=1200;
%rezulta
zeta=-log(sigma)/sqrt(pi^2+log(sigma)^2);
wn=4/(tt*zeta);
%calcularea Gr
Gd_num=wn^2;
Gd_den=[1 2*zeta*wn 0];
Gd=tf(Gd_num,Gd_den);

Gr=minreal(Gd/(Gm));
poli=abs(pole(Gm));
P1=2*zeta*wn;
GR=Gd*3.75;
%% Metoda lambda
kf=3.75;
lambda=200;
kpl=tih/(kf*(lambda+delay));


%% metoda Haalman
kf=3.75;
tih=420;
Gdh=tf(2,270,'InputDelay',90);
kph=2*420/(3*90*3.75);
%Zhuang-Atherton
R = delay / tih;
%% ISE
Kp_ISE =(1.048/kf)*((delay/tih)^(-0.897));
Ti_ISE = tih/(1.195+(-0.368*delay/tih));
Td_ISE = 0.489*tih*((delay/tih)^0.888);
kp_ISE = Kp_ISE;
ki_ISE = kp_ISE/Ti_ISE;
kd_ISE = kp_ISE*Td_ISE;

%% ISTE
Kp_ISTE =(1.042/kf)*((delay/tih)^(-0.897));
Ti_ISTE = tih/(0.987+(-0.368*delay/tih));
Td_ISTE = 0.489*tih*((delay/tih)^0.888);
kp_ISTE = Kp_ISTE;
ki_ISTE = kp_ISTE/Ti_ISTE;
kd_ISTE = kp_ISTE*Td_ISTE;

%% IST2E
Kp_IST2E =(0.968/kf)*((delay/tih)^(-0.904));
Ti_IST2E = tih/(0.977+(-0.253*delay/tih));
Td_IST2E = 0.316*tih*((delay/tih)^0.892);
kp_IST2E = Kp_IST2E;
ki_IST2E = kp_IST2E/Ti_IST2E;
kd_IST2E = kp_IST2E*Td_IST2E;

%% feedforward
kp=3;
Tp=50;
kp1=2;
Tp1=300;
kp2=5;
Tp2=200;
Gp=tf(kp,Tp);
Gp1=tf(kp1,Tp1);
Gp2=tf(kp2,Tp2);
s=tf('s');
Gff = - (kp * (1 + s*tih)) / (kf * (1 + s*Tp));
Gff1 = - (kp1 * (1 + s*tih)) / (kf * (1 + s*Tp1));
Gff2= - (kp2 * (1 + s*tih)) / (kf * (1 + s*Tp2));



%% MSE
%MSE_alocare_poli = mean((out.referinta_pp - out.iesire_pp).^2);
MSE_Lambda = mean((out.referinta_haalman - out.iesire_Lambda).^2);
MSE_Haalman = mean((out.referinta_haalman - out.iesire_haalman).^2);
MSE_ISE = mean((out.referinta_haalman - out.iesire_ISE).^2);
MSE_ISTE = mean((out.referinta_haalman - out.iesire_ISTE).^2);
MSE_IST2E = mean((out.referinta_haalman - out.iesire_IST2E).^2);
MSE_Smith =mean((out.referinta_haalman - out.iesire_Smith).^2);
MSE_ff =mean((out.referinta_haalman - out.iesire_feedforward).^2);

% Valori MSE pentru metodele testate (valorile tale)
valori_MSE = [...
    mean((out.referinta_haalman - out.iesire_Lambda).^2),...
mean((out.referinta_haalman - out.iesire_haalman).^2),...
mean((out.referinta_haalman - out.iesire_ISE).^2),...
mean((out.referinta_haalman - out.iesire_ISTE).^2),...
mean((out.referinta_haalman - out.iesire_IST2E).^2),...
mean((out.referinta_haalman - out.iesire_Smith).^2),...
mean((out.referinta_haalman - out.iesire_feedforward).^2)...
];

% Etichetele corespunzătoare
etichete_MSE = {...
    'Lambda', ...
    'Haalman', ...
    'ISE', ...
    'IST2E', ...
    'ISTE', ...
    'Smith',...
    'Feedforward',...
    'MPC'...
    
   };

% Creare grafic bară
figure;
b = bar(valori_MSE, 'FaceColor', [0.3 0.4 0.8]);  % culoare albastru deschis
text(1:length(valori_MSE), valori_MSE, num2str(valori_MSE','%.4f'), ...
    'HorizontalAlignment','center', 'VerticalAlignment','bottom', ...
    'FontSize', 10);

% Personalizare axă X
set(gca, 'XTickLabel', etichete_MSE, 'XTickLabelRotation', 45, 'FontSize', 10);

% Etichete și titlu
ylabel('MSE');
title('MSE pentru metodele de acordare PID');

% Activare grilă
grid on;

% Setează dimensiune figură
set(gcf, 'Position', [100 100 900 500]);
saveas(gcf, 'MSE.png')

%% iesire si comanda
figure;

% Subplot 1 – Ieșiri
subplot(2,1,1);
plot(out.tout, out.iesire_Lambda, 'g', 'LineWidth', 2); hold on;
plot(out.tout, out.referinta_haalman, 'k--', 'LineWidth', 2);  % după ieșire
xlabel('Timp [s]');
ylabel('Temperatura [C]');
title('Ieșire sistem');
legend('Funcție de transfer','Referință');
grid on;

% Subplot 2 – Comenzi
subplot(2,1,2);
plot(out.tout, out.comanda_Lambda, 'b', 'LineWidth', 2);
xlabel('Timp [s]');
ylabel('Comandă u [W]');
title('Comanda aplicată');
legend( 'Funcție de transfer');
grid on;

saveas(gcf, 'IST2E_comanda_raspuns.png')

%% DURATA REGIMULUI TRANZITORIU
figure;
metode = {'Lambda','Haalman', 'ISE', 'ISTE', 'IST2E', 'Smith', 'FeedForward'};
t_tranzitor = [1500, 1400, 2500,2400, 2500, 2300, 2200];
bar(t_tranzitor);
set(gca, 'xticklabel', metode);
yline(2500, '--k', '2500s', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'top');
ylabel('Durata regimului tranzitoriu [s]');
title('Compararea duratelor regimului tranzitoriu');
grid on;
saveas(gcf, 'durata_regimului_tranzitoriu_toate_metodele.png');

%% medie comanda

cLambda = mean(out.comanda_Lambda);
chaalman = mean(out.comanda_haalman);
cISE = mean(out.comanda_ISE);
cISTE = mean(out.comanda_ISTE);
cIST2E= mean(out.comanda_IST2E);
cSmith =mean(out.comanda_Smith);
cFF =mean(out.comanda_feedforward);

% Valori deja calculate ale mediei comenzilor
valori_medie_comanda_PID = [
mean(out.comanda_Lambda),...
mean(out.comanda_haalman),...
mean(out.comanda_ISE),...
mean(out.comanda_ISTE),...
mean(out.comanda_IST2E),...
mean(out.comanda_Smith),...
mean(out.comanda_feedforward)
];

etichete_medie_PID = {'Lambda','Haalman', 'ISE', 'ISTE', 'IST2E', 'Smith', 'FeedForward'};

i
figure;
b = bar(valori_medie_comanda_PID, 'FaceColor', [0.3 0.6 0.4]);  % verde-albăstrui

% Afișare valori numeric deasupra barelor
text(1:length(valori_medie_comanda_PID), valori_medie_comanda_PID, ...
    num2str(valori_medie_comanda_PID','%.4f'), ...
    'HorizontalAlignment','center', 'VerticalAlignment','bottom', ...
    'FontSize', 10);

% Personalizare axă X
set(gca, 'XTickLabel', etichete_medie_PID, 'XTickLabelRotation', 45, 'FontSize', 10);

% Etichete și titlu
yline(12);
ylabel('Media comenzii [kW]');
title('Efortul de control – media comenzii pentru metodele PID');
grid on;

% Setează dimensiunea ferestrei 
set(gcf, 'Position', [100 100 900 500]);

% Salvare imagine (opțional)
saveas(gcf, 'MediaComanda_MPC_manual.png');


%% Calcul și grafic pentru suprareglarea metodelor PID

y_ref = 37;  % Valoarea de referință finală

% Etichetele pentru metodele PID
etichete_PID = {
    'Lambda', ...
    'haalman', ...
    'ISE', ...
    'ISTE', ...
    'IST2E', ...
    'Smith', ...
    'Feedforward'
};

% Calcul suprareglare [%]
valori_suprareglare_PID = [ ...
    (max(out.iesire_Lambda) - y_ref) / y_ref * 100, ...
    (max(out.iesire_haalman) - y_ref) / y_ref * 100, ...
    (max(out.iesire_ISE) - y_ref) / y_ref * 100, ...
    (max(out.iesire_ISTE) - y_ref) / y_ref * 100, ...
    (max(out.iesire_IST2E) - y_ref) / y_ref * 100, ...
    (max(out.iesire_Smith) - y_ref) / y_ref * 100, ...
    (max(out.iesire_feedforward) - y_ref) / y_ref * 100 ...
];

% Creare grafic bară
figure;
bar(valori_suprareglare_PID, 'FaceColor', [0.9 0.6 0.2]);

% Afișare valori numeric deasupra barelor
text(1:length(valori_suprareglare_PID), valori_suprareglare_PID, ...
    num2str(valori_suprareglare_PID','%.2f'), ...
    'HorizontalAlignment','center', 'VerticalAlignment','bottom', ...
    'FontSize', 10);

% Personalizare axă X
set(gca, 'XTickLabel', etichete_PID, 'XTickLabelRotation', 45, 'FontSize', 10);

% Etichete și titlu
ylabel('Suprareglare [%]');
title('Suprareglare pentru metodele PID');
grid on;

% Setare dimensiune fereastră
set(gcf, 'Position', [100 100 900 500]);

%% toate metodele PID
figure;
t = out.tout;

subplot(2,1,1);
hold on; grid on;
plot(t, out.iesire_Lambda, 'b', 'LineWidth', 1.5);
plot(t, out.iesire_haalman, 'r', 'LineWidth', 1.5);
plot(t, out.iesire_ISE, 'c', 'LineWidth', 1.5);
plot(t, out.iesire_ISTE, 'y', 'LineWidth', 1.5);
plot(t, out.iesire_IST2E, '--b', 'LineWidth', 1.5);
plot(t, out.iesire_Smith, '--y', 'LineWidth', 1.5);
plot(t, out.iesire_feedforward, '--c', 'LineWidth', 1.5);
plot(t, out.referinta_haalman, 'k--', 'LineWidth', 2);  % Referință

ylabel('Temperatura [°C]');
title('Ieșiri – Metode PID');
legend({'Lambda', 'Haalman', 'ISE', 'ISTE', 'IST2E', 'Smith','Feedforward', 'Referință'}, ...
    'Location', 'southeast');
subplot(2,1,2);
hold on; grid on;
plot(t, out.comanda_Lambda, 'b', 'LineWidth', 1.5);
plot(t, out.comanda_haalman, 'r', 'LineWidth', 1.5);
plot(t, out.comanda_ISE, 'c', 'LineWidth', 1.5);
plot(t, out.comanda_ISTE, 'y', 'LineWidth', 1.5);
plot(t, out.comanda_IST2E, '--b', 'LineWidth', 1.5);
plot(t, out.comanda_Smith, '--y', 'LineWidth', 1.5);
plot(t, out.comanda_feedforward, '--c', 'LineWidth', 1.5);

xlabel('Timp [s]');
ylabel('Comandă [kW]');
title('Comenzi – Metode PID');
legend({'Lambda', 'Haalman', 'ISE', 'ISTE', 'IST2E', 'Smith','Feedforward'}, ...
    'Location', 'southeast');

set(gcf, 'Position', [100 100 900 600]);
saveas(gcf, 'rezultate_metode_PID_subplot.png');

save('rezultate_PID.mat', 'out');  % out.iesire_X, out.comanda_X, out.referinta_haalman


%Aleg Lambda


%% ff

figure;
t = out.tout;
ref=37*ones(301,1);
hold on; grid on;
plot(t, out.iesire_ff, 'r', 'LineWidth', 2);
plot(t, out.iesire_poli, 'b', 'LineWidth', 1.5);
plot(t, out.referinta_haalman, 'k--', 'LineWidth', 1.5);
plot(t, ref, 'k--', 'LineWidth', 1.5);
ylabel('Temperatura [°C]');
title('Ieșiri – Sistem cu și fără Feedforward');
legend({'Cu Ff', 'Fără Ff', 'Referință'}, ...
    'Location', 'southeast');
