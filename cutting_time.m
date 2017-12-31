function t_c = cutting_time(l, f, N)
% f [mm/rev] feed
% l [mm] length of cut
% N [rpm] rotational speed of the workpiece
% t_op[min] duration of the operation
t_c = l / (f * N);
end