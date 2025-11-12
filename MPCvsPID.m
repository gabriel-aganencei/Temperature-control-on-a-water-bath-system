%schimbare de referinta
figure;
t = out.tout;
ref=out.ref_MPCs;
subplot(2,1,1);
hold on; grid on;
plot(t, out.iesire_MPC_eu2, 'r', 'LineWidth', 1.5);
plot(t, out.iesire_haalmanscref, 'b', 'LineWidth', 1.5);
plot(t, out.referinta_haalman, 'k--', 'LineWidth', 1.5);
plot(t, ref, 'k--', 'LineWidth', 1.5);
ylabel('Temperatura [°C]');
ylim([34 38]);
title('Ieșiri – MPC vs PID schimbare referință');
legend({'MPC', 'PID', 'Referință'}, ...
    'Location', 'southeast');
subplot(2,1,2);
hold on; grid on;
plot(t, out.comanda_MPC_eu2, 'r', 'LineWidth', 1.5);
plot(t, out.comanda_haalmanscref, 'b', 'LineWidth', 1.5);

xlabel('Timp [s]');
ylabel('Comandă [kW]');
title('Comenzi – MPC vs PID schimbare referință');
legend({'MPC', 'PID'}, ...
    'Location', 'southeast');

set(gcf, 'Position', [100 100 900 600]);
%% rejectia perturbatiei
figure;
t = out.tout;
ref=37*ones(301,1);
subplot(2,1,1);
hold on; grid on;
plot(t, out.iesire_MPC_eu1, 'r', 'LineWidth', 1.5);
plot(t, out.iesire_haalmanpert, 'b', 'LineWidth', 1.5);
plot(t, out.referinta_haalman, 'k--', 'LineWidth', 1.5);
plot(t, ref, 'k--', 'LineWidth', 1.5);
ylabel('Temperatura [°C]');
title('Ieșiri – MPC vs PID rejectarea perturbației');
legend({'MPC', 'PID', 'Referință'}, ...
    'Location', 'southeast');
subplot(2,1,2);
hold on; grid on;
plot(t, out.comanda_MPC_eu1, 'r', 'LineWidth', 1.5);
plot(t, out.comanda_haalmanpert, 'b', 'LineWidth', 1.5);

xlabel('Timp [s]');
ylabel('Comandă [kW]');
title('Comenzi – MPC vs PID rejectarea perturbației');
legend({'MPC', 'PID'}, ...
    'Location', 'southeast');

set(gcf, 'Position', [100 100 900 600]);
%% saturatie vs restrictii
figure;
t = out.tout;
ref=37*ones(501,1);
subplot(2,1,1);
hold on; grid on;
plot(t, out.iesire_MPC_eu, 'r', 'LineWidth', 2);
plot(t, out.iesire_haalman11, 'b', 'LineWidth', 1.5);
plot(t, out.referinta_haalman, 'k--', 'LineWidth', 1.5);
plot(t, ref, 'k--', 'LineWidth', 1.5);
ylabel('Temperatura [°C]');
title('Ieșiri – MPC vs PID saturație vs restricție');
legend({'MPC', 'PID', 'Referință'}, ...
    'Location', 'southeast');
subplot(2,1,2);
hold on; grid on;
plot(t, out.comanda_MPC_eu, 'r', 'LineWidth', 1.5);
plot(t, out.comanda_haalman11, 'b', 'LineWidth', 1.5);

xlabel('Timp [s]');
ylabel('Comandă [kW]');
title('Comenzi – MPC vs PID saturație vs restricție');
legend({'MPC', 'PID'}, ...
    'Location', 'southeast');

set(gcf, 'Position', [100 100 900 600]);
%% regim tranzitoriu
figure;
metode = {'MPC','PID'};
t_tranzitor = [1050, 4200];
bar(t_tranzitor);
set(gca, 'xticklabel', metode);
yline(4500, '--k', '4500s', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'top');
ylabel('Durata regimului tranzitoriu [s]');
title('Compararea duratelor regimului tranzitoriu');
grid on;

%% Calcul și grafic pentru suprareglare (overshoot)
% Referința finală
y_ref = 37;

% Lista etichetelor și vectorilor de ieșire
etichete_suprareglare = {
    'MPC', ...
    'PID'
};

% Extragere și calcul suprareglare din structura 'out'
valori_suprareglare = [ ...
    (max(out.iesire_MPC_eu) - y_ref) / y_ref * 100, ...
    (max(out.iesire_haalman) - y_ref) / y_ref * 100
  
]
% Creare grafic bară pentru suprareglare
figure;
b = bar(valori_suprareglare, 'FaceColor', [0.8 0.3 0.3]);  % roșu deschis

% Afișare valori numeric deasupra barelor
text(1:length(valori_suprareglare), valori_suprareglare, ...
    num2str(valori_suprareglare','%.2f'), ...
    'HorizontalAlignment','center', 'VerticalAlignment','bottom', ...
    'FontSize', 10);

% Personalizare axă X
set(gca, 'XTickLabel', etichete_suprareglare, 'XTickLabelRotation', 45, 'FontSize', 10);

% Etichete și titlu
ylabel('Suprareglare [%]');
title('Suprareglare pentru metodele MPC');
grid on;

% Setează dimensiune figură
set(gcf, 'Position', [100 100 900 500]);

%% Medie comanda

% Valori deja calculate ale mediei comenzilor
valori_medie_comanda = [
  mean(out.comanda_MPC_eu),...
mean(out.comanda_haalman),...

];

etichete_medie = {
    'MPC', ...
    'PID' ...
   
};

% Creare grafic bară pentru media comenzii
figure;
b = bar(valori_medie_comanda, 'FaceColor', [0.3 0.6 0.4]);  % verde-albăstrui

% Afișare valori numeric deasupra barelor
text(1:length(valori_medie_comanda), valori_medie_comanda, ...
    num2str(valori_medie_comanda','%.2f'), ...
    'HorizontalAlignment','center', 'VerticalAlignment','bottom', ...
    'FontSize', 10);

% Personalizare axă X
set(gca, 'XTickLabel', etichete_medie, 'XTickLabelRotation', 45, 'FontSize', 10);

% Etichete și titlu
ylabel('Media comenzii [kW]');
title('Efortul de control – media comenzii pentru metodele MPC');
grid on;

% Setează dimensiunea ferestrei 
set(gcf, 'Position', [100 100 900 500]);

% Salvare imagine (opțional)
saveas(gcf, 'MediaComanda_MPC_manual.png');

%% MSE
referinta=37*ones(501,1);
% Valori MSE pentru metodele testate 
valori_MSE = [...
 mean((referinta - out.iesire_MPC_eu).^2),...
 mean((referinta - out.iesire_haalman).^2)
];

% Etichetele corespunzătoare
etichete_MSE = {...
    'MPC', ...
    'PID', ...
 

   };

% Creare grafic bară
figure;
b = bar(valori_MSE, 'FaceColor', [0.3 0.4 0.8]);  % culoare albastru deschis

% Afișare valori numeric deasupra barelor
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