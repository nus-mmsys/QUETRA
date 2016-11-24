function simloop(filename)
  t1 = clock;
  fileID = fopen(filename,'w');
  fprintf(fileID,'Th R rho K BO Xk\n'); 
  Th = [6500, 6000, 4100, 2200, 1800, 1200];
  R = [5000, 3000, 2000, 1500];
  K = [30, 60, 120, 240];
  BO = [0, 5, 15, 20, 30, 50, 60, 100, 120, 200];
  
  for r = 1:numel(R)
    for t = 1:numel(Th)
      for k = 1:numel(K)
        for b = 1:numel(BO)
          if BO(b) > K(k)
            break;
          endif
          rho = Th(t)/R(r);
          [lost_arr, total_arr, state_hist, time_history] = sim_md1k(rho, K(k), 50000, BO(b));
          Xk=mean(time_history);
          X =[Th(t), R(r), rho, K(k), BO(b), Xk];
          fprintf(fileID,'%d %d %f %d %d %f\n', X);
          %display(X)
        endfor
      endfor
    endfor
  endfor
  fclose(fileID);
  t2 = clock;
  disp(t2-t1);
endfunction