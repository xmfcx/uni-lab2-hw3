clear
clc
% Question: 150-mm-long, 12.5 mm diameter 304 stainless steel rod is being
% reduced in diameter to 12.0 mm by turning on a lathe. The spindle rotates
% at N=400 rpm, and the tool is traveling at an axial speed of 200 mm/min.
% Calculate the cutting speed, material-remocalrate, cutting_time, power
% dissipated and cutting force
% Solution: The cutting speed is the tangential speed of the workpiece.
% The maximum cutting speed is at the outer diameter; Do, and is ontained
% from the euquationV_c=pi*Do*N

N = 400; % [rev/min] rotational speed of workpiece

indices_material = [ 1, 5, 8, 10];

sizeof_indices_material = size(indices_material, 2);

% Choosing material
n = 8;

N_x_max = 1000;
N_x_min = 1;
N_x_step_size = 3;

sizeof_F_c_width = (N_x_max - N_x_min) / N_x_step_size;

F_c = zeros(sizeof_indices_material, sizeof_F_c_width);
N_x = N_x_min: N_x_step_size: N_x_max;

for N = N_x_min:N_x_step_size:N_x_max
    Do = 12.5; % [mm] original diameter
    Df = 12; % [mm] machined diameter
    % the maximum cutting speed is
    V_c_max = cutting_speed(Do, N); % [mm/min]
    % the cutting speed at the machined diameter is
    V_c_mac = cutting_speed(Df, N); % [mm/min]
    % from the information given, note that the depth of cut is
    d = (Do - Df) / 2; % [mm]
    % and the feed is f=v/N
    v = 200; % [mm/min]
    f = v / N; % [mm/rev]

    % according to MRR equation given before (MRR=pi*D_avg*d*f*N)
    mrr = material_removal_rate_N(Do, Df, f, N); % [mm^3/min]
    % the actual time to cut, according to equation (t_c=)
    l = 150; % [mm] cutting length
    t_c = cutting_time(l, f, N); % [min]
    t_c = t_c * 60; % [s]
    % The power required can be calculated by referring to Table and taking an
    % average value for stainless steel as 4 W.s/mm^3 by chosingn=8 as given
    % below
    % Specific energy table [W*s/mm^3]
    % AlluminumAlloys: n=1
    % Cast Irons: n=2
    % Copper Alloys: n=3
    % High-Temperature Alloys: n=4
    % Magnesium Alloys: n=5
    % Nickel Alloys: n=6
    % Refractory Alloys: n=7
    % Stainless Steels: n=8
    % Steels: n=9
    % Titanium Alloys: n=10
    for indice_n = 1:1:sizeof_indices_material
        n = indices_material(indice_n);
        Spec_energy_table = [0.7; 3; 2; 5; 0.5; 5.4; 6; 4; 4.5; 5];

        Spec_energy = Spec_energy_table(n);
        % Therefore, the power dissipated is
        Power = Spec_energy * mrr / 60; % [W]
        % Since W=60*N.m/min
        Power = 60 * Power; % [N.m/min]
        % The cutting force, Fc, is the tangential force exerted by the tool. Power
        % is the product of torque, T, and the rotational speed in radians per unit
        % time; hence
        T = Power / (2 * pi * N); % [Nm] Torque
        % Since T=Fc*Davg/2;
        Fc = T * 1000 / (((Do + Df) / 2) / 2); % [N] Cutting force
        F_c(indice_n, (N-N_x_min) / N_x_step_size + 1) = Fc;
    end
end



figure(1);
plot(N_x, F_c(1,:), 'r-.',N_x, F_c(2,:), 'b:',N_x, F_c(3,:), 'k-',N_x, F_c(4,:), 'm--', 'LineWidth',2);
legend('Alluminium Alloys', 'Magnesium Alloys', 'Stainless Steel', 'Titanium Alloys')
xlabel('N [rev/min]')
ylabel('F_c [N]')
axis([200 500 0 1400])
grid on


N = 400; % [rev/min] rotational speed of workpiece
Do = 12.5; % [mm] original diameter
Df = 12: - 0.02:10; % [mm] machined diameter
v = 150:250; % [mm/min]

%disp(size(Df));
%disp(size(v));

f = v ./ N; % [mm/rev]
d = (Do - Df) ./ 2; % [mm]
D_avg = (Do + Df) ./ 2; % [mm]
size_Df = size(Df, 2);
size_v = size(v, 2);

Spec_energy = 4;
mrr = zeros(size_Df, size_v);
Fc = zeros(size_Df, size_v);

for i = 1:1:size_Df
    for j = 1:1:size_v
        mrr(i, j) = pi * D_avg(i) * d(i) * v(j);
        Fc(i, j) = pi * D_avg(i) * d(i) * v(j) * Spec_energy / (2 * pi * N) * 1000 / (((Do + Df(i)) / 2) / 2);
    end
end

figure(2);
subplot(2, 2, 1); 
mesh(v, Df, mrr); 
xlabel('$$ \nu $$[mm/min]', 'Interpreter', 'latex'); 
ylabel('D_f[mm]'); 
zlabel('MRR[mm^3/min]');
grid on; 

subplot(2, 2, 2); 
mesh(v, Df, Fc);
xlabel('$$ \nu $$[mm/min]', 'Interpreter', 'latex'); 
ylabel('D_f[mm]'); 
zlabel('F_c[N]');
grid on; 

subplot(2, 2, 3); 
plot(v, mrr(1, :), 'r--');
axis([150 250 1000 2500]); 
xlabel('$$ \nu $$[mm/min]', 'Interpreter', 'latex');
ylabel('MRR[mm^3/min]');
legend('D_f=12[mm]','Location','northwest');
grid on; 

subplot(2, 2, 4);
plot(v, Fc(1, :), 'k-.');
axis([150 250 300 700]);
xlabel('$$ \nu $$[mm/min]', 'Interpreter', 'latex'); 
ylabel('F_c[N]');
legend('D_f=12[mm]','Location','northwest');
grid on; 





