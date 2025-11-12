referinta=35*ones(501,1);
%% MSE
meu = mean((referinta - out.iesire_MPC_eu).^2);
mHc10 = mean((referinta - out.iesire_MPC_hc10).^2);
mHc20 = mean((referinta - out.iesire_MPC_hc20).^2);
mHc30 = mean((referinta - out.iesire_MPC_hc30).^2);
mHc5 = mean((referinta - out.iesire_MPC_hc5).^2);
mHp100 =mean((referinta - out.iesire_MPC_hp100).^2);
mHp20 =mean((referinta - out.iesire_MPC_hp20).^2);
mHp40 =mean((referinta - out.iesire_MPC_hp40).^2);
mHp60 =mean((referinta - out.iesire_MPC_hp60).^2);
mHp80 =mean((referinta - out.iesire_MPC_hp80).^2);
mlambda10 =mean((referinta - out.iesire_MPC_lambda10).^2);
mlambda0_1 =mean((referinta - out.iesire_MPC_lambda_0_1).^2);
mlambda1 =mean((referinta - out.iesire_MPC_lambda1).^2);

% Valori MSE pentru metodele testate 
valori_MSE = [...
     72.4815,...    % eu
     62.4289, ...   % Hc10
     62.4293, ...   % Hc20
     62.4293, ...   % Hc30
     62.4286, ...   % Hc5
     62.4289, ...   % hp100
     62.4355, ...   % hp20
     62.4297, ...   % hp40
     62.4288, ...   % hp60
     62.4288, ...   % hp80
     66.3866, ...   % lambda10
     62.4291, ...   % lambda0_1
     62.4289, ...   % lambda1
];

% Etichetele corespunzătoare
etichete_MSE = {...
    'eu', ...
    'Hc10', ...
    'Hc20', ...
    'Hc30', ...
    'Hc5', ...
    'hp100',...
    'hp20',...
    'hp40',...
    'hp60',...
    'hp80',...
    'lambda10',...
    'lambda0_1',...
    'lambda1',...

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
saveas(gcf, 'MSE.png')

%% Medie comanda

% Valori deja calculate ale mediei comenzilor
valori_medie_comanda = [
  mean(out.comanda_MPC_eu),...
mean(out.comanda_MPC_hc30),...
mean(out.comanda_MPC_hc40),...
mean(out.comanda_MPC_hc50),...
mean(out.comanda_MPC_hc60),...
mean(out.comanda_MPC_hc120),...
mean(out.comanda_MPC_hp120),...
mean(out.comanda_MPC_hp100),...
mean(out.comanda_MPC_hp60),...
mean(out.comanda_MPC_hp80),...
mean(out.comanda_MPC_lambda10),...
mean(out.comanda_MPC_lambda_0_1),...
mean(out.comanda_MPC_lambda1)
];

etichete_medie = {
    'MPC_eu', ...
    'Hc30', ...
    'Hc40', ...
    'Hc50', ...
    'Hc60', ...
    'Hc120',...
    'Hp130', ...
    'Hp100', ...
    'Hp60', ...
    'Hp80', ...
    'lambda10', ...
    'lambda0_1', ...
    'lambda1'
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

%% 6. Calcul și grafic pentru suprareglare (overshoot)
% Referința finală
y_ref = 37;

% Lista etichetelor și vectorilor de ieșire
etichete_suprareglare = {
    'MPC_eu', ...
    'Hc10', ...
    'Hc20', ...
    'Hc30', ...
    'Hc100', ...
    'Hp100', ...
    'Hp20', ...
    'Hp40', ...
    'Hp60', ...
    'Hp80', ...
    'lambda10', ...
    'lambda0_1', ...
    'lambda1'
};

% Extragere și calcul suprareglare din structura 'out'
valori_suprareglare = [ ...
    (max(out.iesire_MPC_eu) - y_ref) / y_ref * 100, ...
    (max(out.iesire_MPC_hc10) - y_ref) / y_ref * 100, ...
    (max(out.iesire_MPC_hc20) - y_ref) / y_ref * 100, ...
    (max(out.iesire_MPC_hc30) - y_ref) / y_ref * 100, ...
    (max(out.iesire_MPC_hc100) - y_ref) / y_ref * 100, ...
    (max(out.iesire_MPC_hp100) - y_ref) / y_ref * 100, ...
    (max(out.iesire_MPC_hp20) - y_ref) / y_ref * 100, ...
    (max(out.iesire_MPC_hp40) - y_ref) / y_ref * 100, ...
    (max(out.iesire_MPC_hp60) - y_ref) / y_ref * 100, ...
    (max(out.iesire_MPC_hp80) - y_ref) / y_ref * 100, ...
    (max(out.iesire_MPC_lambda10) - y_ref) / y_ref * 100, ...
    (max(out.iesire_MPC_lambda_0_1) - y_ref) / y_ref * 100, ...
    (max(out.iesire_MPC_lambda1) - y_ref) / y_ref * 100 ...
];

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


%% Timpul tranzitoriu

figure;
metode = {'MPC_eu','Hc10','Hc20','Hc30','Hc100','Hp100','Hp20','Hp40','Hp60','Hp80','lambda10','lambda0_1', 'lambda1'};
t_tranzitor = [1100, 1000, 1000, 980, 950, 1000,1050, 1050, 1080,1000,1150,920,1000];
bar(t_tranzitor);
set(gca, 'xticklabel', metode);
yline(1200, '--k', '1200s', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'top');
ylabel('Durata regimului tranzitoriu [s]');
title('Compararea duratelor regimului tranzitoriu');
grid on;
saveas(gcf, 'durata_regimului_tranzitoriu_toate_metodele.png');

%% hp grafice
figure;
t = out.tout;
ref=37*ones(251,1);
subplot(2,1,1);
hold on; grid on;
plot(t, out.iesire_MPC_hp60, 'b', 'LineWidth', 1.5);
plot(t, out.iesire_MPC_hp80, 'r--', 'LineWidth', 1.5);
plot(t, out.iesire_MPC_hp100, 'c--' ,'LineWidth', 1.5);
plot(t, out.iesire_MPC_hp120, 'r', 'LineWidth', 1.5);%best
plot(t, ref, 'k--', 'LineWidth', 1.5);
ylabel('Temperatura [°C]');
title('Ieșiri – MPC');
legend({'Hp60', 'Hp80', 'Hp100', 'Hp120', 'Referință'}, ...
    'Location', 'southeast');
subplot(2,1,2);
hold on; grid on;
plot(t, out.comanda_MPC_hp60, 'b', 'LineWidth', 1.5);
plot(t, out.comanda_MPC_hp80, 'r--', 'LineWidth', 1.5);
plot(t, out.comanda_MPC_hp100, 'c--', 'LineWidth', 1.5);
plot(t, out.comanda_MPC_hp120, 'r', 'LineWidth', 1.5);

xlabel('Timp [s]');
ylabel('Comandă [kW]');
title('Comenzi – MPC');
legend({'Hp60', 'Hp80', 'Hp100', 'Hp120'}, ...
    'Location', 'southeast');

set(gcf, 'Position', [100 100 900 600]);

%% hc grafice
figure;
t = out.tout;
ref=37*ones(251,1);
subplot(2,1,1);
hold on; grid on;
plot(t, out.iesire_MPC_hc30, 'b', 'LineWidth', 1.5);
plot(t, out.iesire_MPC_hc40, 'r--', 'LineWidth', 1.5);
plot(t, out.iesire_MPC_hc50, 'c--' ,'LineWidth', 1.5);
plot(t, out.iesire_MPC_hc60, 'r', 'LineWidth', 1.5);
plot(t, out.iesire_MPC_hc120, 'g', 'LineWidth', 1.5);%best
plot(t, ref, 'k--', 'LineWidth', 1.5);
ylabel('Temperatura [°C]');
title('Ieșiri – MPC');
legend({'Hc30', 'Hc40', 'Hc50', 'Hc60','Hc120 ','Referință'}, ...
    'Location', 'southeast');
subplot(2,1,2);
hold on; grid on;
plot(t, out.comanda_MPC_hc30, 'b', 'LineWidth', 1.5);
plot(t, out.comanda_MPC_hc40, 'r--', 'LineWidth', 1.5);
plot(t, out.comanda_MPC_hc50, 'c--', 'LineWidth', 1.5);
plot(t, out.comanda_MPC_hc60, 'r', 'LineWidth', 1.5);
plot(t, out.comanda_MPC_hc120, 'g', 'LineWidth', 1.5);
xlabel('Timp [s]');
ylabel('Comandă [kW]');
title('Comenzi – MPC');
legend({'Hc30', 'Hc40', 'Hc50', 'Hc60','Hc120'}, ...
    'Location', 'southeast');

set(gcf, 'Position', [100 100 900 600]);
%% lambda grafice
figure;
t = out.tout;
ref=37*ones(251,1);
subplot(2,1,1);
hold on; grid on;
plot(t, out.iesire_MPC_lambda_0_1, 'b', 'LineWidth', 2);%best
plot(t, out.iesire_MPC_lambda1, 'r--', 'LineWidth', 2);
plot(t, out.iesire_MPC_lambda10, 'k--' ,'LineWidth', 2);
plot(t, ref, 'b--', 'LineWidth', 1.5);
ylabel('Temperatura [°C]');
title('Ieșiri – MPC');
legend({'Lambda 0.1', 'Lambda 1', 'Lamnda 10','Referință'}, ...
    'Location', 'southeast');
subplot(2,1,2);
hold on; grid on;
plot(t, out.comanda_MPC_lambda_0_1, 'b', 'LineWidth', 2);
plot(t, out.comanda_MPC_lambda1, 'r--', 'LineWidth', 2);
plot(t, out.comanda_MPC_lambda10, 'k--', 'LineWidth', 2);

xlabel('Timp [s]');
ylabel('Comandă [kW]');
title('Comenzi – MPC');
legend({'Lambda 0.1', 'Lambda 1', 'Lamnda 10'}, ...
    'Location', 'southeast');

set(gcf, 'Position', [100 100 900 600]);