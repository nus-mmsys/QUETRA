function simloop(filename)
  t1 = clock;
  fileID = fopen(filename,'w');
  fprintf(fileID,'Th R rho K BO Xk\n');

  %B = [4100,2200,1200,4077,2313,1622,4103,1974,1198,4140,1794,1143,2116,1784,946,577,342,6193,5177,3034,2102,1460,1015,706,452,344,254,3413,2460,1498,722,315];
  %T = [5000,4000,3000,2000,1500];
  
  %K = [5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95];
  %BO = [5,10,15,20,25,30,35,40];
  Th = [4100, 2200, 1200, 577, 254];
  R = [5000, 3000, 2000, 1500];
  K = [30, 60, 120, 240];
  BO = [5, 10, 20];
  
  for r = 1:numel(R)
    for t = 1:numel(Th)
      for k = 1:numel(K)
        for b = 1:numel(BO)
          rho = Th(t)/R(r);
          [lost_arr, total_arr, state_hist, time_history] = sim_md1k(rho, K(k), 50000, BO(b));
          Xk=mean(time_history);
          X =[Th(t), R(r), rho, K(k), BO(b), Xk];
          fprintf(fileID,'%d %d %f %d %d %f\n', X);
          %display(X)
        end
      end
    end
  end
  fclose(fileID);
  t2 = clock;
  disp(t2-t1);
endfunction