function mrr = material_removal_rate_N(Do, Df, f, N)
% Do [mm] original diameter of workpiece
% Df[mm] final diameter of workpiece
% f [mm/rev] feed
% d [mm] depth of cut
% N [rpm] rotational speed of the workpiece
D_avg = (Do + Df) / 2;
d = (Do - Df) / 2;
% mrr[mm^3/min] material removal rate
mrr = pi * D_avg * d * f * N;
end