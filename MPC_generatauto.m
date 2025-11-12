% Sistem discretizat
Ts = 10;
hd = c2d(tf(3.75, [420 1], 'InputDelay', 90), Ts);

% Inițializare
obiecte = {};

%% Variație Hp (cu Hc și λ constante)
valori_Hp = [60, 80, 100, 120];
for Hp = valori_Hp
    mpc_tmp = mpc(hd, Ts);
    mpc_tmp.PredictionHorizon = Hp;
    mpc_tmp.ControlHorizon = 30;
    mpc_tmp.Weights.OutputVariables = 1;
    mpc_tmp.Weights.ManipulatedVariables = 5*1e-4;
    mpc_tmp.Weights.ManipulatedVariablesRate = 1;
    mpc_tmp.MV.Min = 0;
    mpc_tmp.MV.Max = 11;

    nume = sprintf('mpc_Hp%d', Hp);
    eval([nume ' = mpc_tmp;']);
    obiecte{end+1} = nume;
end

%% Variație Hc (cu Hp și λ constante)
valori_Hc = [30, 40, 50, 60,120];
for Hc = valori_Hc
    mpc_tmp = mpc(hd, Ts);
    mpc_tmp.PredictionHorizon = 120;
    mpc_tmp.ControlHorizon = Hc;
    mpc_tmp.Weights.OutputVariables = 1;
    mpc_tmp.Weights.ManipulatedVariables = 5*1e-4;
    mpc_tmp.Weights.ManipulatedVariablesRate = 1;
    mpc_tmp.MV.Min = 0;
    mpc_tmp.MV.Max = 11;

    nume = sprintf('mpc_Hc%d', Hc);
    eval([nume ' = mpc_tmp;']);
    obiecte{end+1} = nume;
end

%% Variație lambda (cu Hp și Hc constante)
valori_lambda = [0.1, 1, 10];
for lambda = valori_lambda
    mpc_tmp = mpc(hd, Ts);
    mpc_tmp.PredictionHorizon = 120;
    mpc_tmp.ControlHorizon = 120;
    mpc_tmp.Weights.OutputVariables = 1;
    mpc_tmp.Weights.ManipulatedVariables = 5*1e-4;
    mpc_tmp.Weights.ManipulatedVariablesRate = lambda;
    mpc_tmp.MV.Min = 0;
    mpc_tmp.MV.Max = 11;

    lambda_str = strrep(num2str(lambda), '.', '_');
    nume = sprintf('mpc_lambda_%s', lambda_str);
    eval([nume ' = mpc_tmp;']);
    obiecte{end+1} = nume;
end





%% Salvare toate obiectele într-un fișier .mat
save('obiecte_MPC.mat', obiecte{:});
disp('Obiectele MPC au fost generate și salvate.');





