function mrr = material_removal_rate_V(Do, Df, f, V)
% Do [mm] original diameter of workpiece
% Df[mm] final diameter of workpiece
% f [mm/rev] feed
% d [mm] depth of cut
% N [rpm] rotational speed of the workpiece
d = (Do - Df) / 2;
% mrr[mm^3/min] material removal rate
mrr = d * f * V;
end