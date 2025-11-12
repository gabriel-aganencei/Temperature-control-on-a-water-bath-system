
%% Configurare MPC
tih=420;
num=3.75;
den=[420 1];
Ts=10;
delay=90;
SYS=tf(num,den,'InputDelay',delay); %Functia de transfer continua
hd=c2d(SYS,Ts);
mpcobj = mpc(hd, Ts);
mpcobj.PredictionHorizon = 120;%hp
mpcobj.ControlHorizon =120;%hc
mpcobj.Weights.OutputVariables = 10;
mpcobj.Weights.ManipulatedVariables = 5*1e-6; %agresivitate pe comanda
mpcobj.Weights.ManipulatedVariablesRate = 0.1; %lambda
mpcobj.MV.Min = 0;
mpcobj.MV.Max = 11;%kW
%Best Mpc hp=120,hc=120,lambda=0.1
%% figura MPC in_out

figure;
t = out.tout;
ref=37*ones(301,1);
subplot(2,1,1);
hold on; grid on;
plot(t, out.iesire_MPC_eu, 'b', 'LineWidth', 1.5);%best
plot(t, ref, 'k--', 'LineWidth', 1.5);
ylabel('Temperatura [°C]');
title('Ieșire');
subplot(2,1,2);
hold on; grid on;
plot(t, out.comanda_MPC_eu, 'b', 'LineWidth', 1.5);


xlabel('Timp [s]');
ylabel('Comandă [kW]');
title('Comanda');


set(gcf, 'Position', [100 100 900 600]);



