% function [lost_arr, total_arr, state_hist, time_history]
% = sim_md1k(arr_rate, system_cap, sim_time, ini_state)
%
% simulates M/D/1/K system with service rate equal to 1 customer per time slot and other
% parameters being defined as follows:
%
% arr_rate : mean arrival rate of customers
% system_cap : system capacity -- the maximum number of customers in the system
% sim_time : simulation time -- the number of slots to be simulated
% ini_state : initial state -- the number of customers in the system at time slot 0
%
% lost_arr : the number of lost arrivals due to buffer overflow
% total_arr : the total number of customer arrivals
% state_hist : state histogram vector -- state_hist(n+1) specifies the number of time slots
% the system stays in state n, where n customers are present (one customer at
% the server and n-1 customers in the buffer)
% time_history : time history vector -- time_history(i+1) specifies system state at time slot i
%
%
% << EXAMPLE >>
%
% [lost_arr, total_arr, state_hist, time_history] = sim_md1k(1, 10, 100, 0)
%
% simulates the M/D/1/10 system with mean arrival rate of 1 customer/slot for 100 time slots
% and no customers are in the system at time slot 0


function [lost_arr, total_arr, state_hist, time_history]...
= sim_md1k(arr_rate, system_cap, sim_time, ini_state)


%%%%%%%%%%%%%%%%%
% Initialisation
%

current_slot = 1; % current slot in simulation loop
current_state = ini_state; % current state in simulation loop

lost_arr = 0;
total_arr = 0;
state_hist = zeros(1, system_cap + 1);
time_history = [current_state];


%%%%%%%%%%%%%%%%%%
% Simulation Loop
%

while (current_slot <= sim_time),

% Find the number of arrivals at current slot: num_arr %
% num_arr = random('Poisson', arr_rate);
num_arr =  poissrnd(arr_rate);

% Update the total number of arrivals %
total_arr = total_arr + num_arr;

% One customer is serviced at the END of current slot AFTER any arrivals in this slot %
current_state = max(0, current_state + num_arr - 1);

% Customers are lost if they arrive when system is full %
lost_arr = lost_arr + max(0, current_state - system_cap);
current_state = min(system_cap, current_state);

% Update time history %
time_history = [time_history, current_state];

% Update state histogram %
state_hist(current_state + 1) = state_hist(current_state + 1) + 1;

% Forward simulation time by one slot %
current_slot = current_slot + 1;

end;

%{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot time history and state histogram
%

plot_color = rand(1,3); % choose the colour for plotting randomly

subplot(2,1,1);
temp = stairs( [0: sim_time], time_history); set(temp, 'Color', plot_color);
xlabel('time slot'); ylabel('number of customers in system');
title(['M/D/1/K simulation: ', ...
'arrival rate = ', num2str(arr_rate), ' customers/slot, ', ...
'K = ', num2str(system_cap), ' customers, ', ...
'loss probability = ', num2str(lost_arr/total_arr)]);

subplot(2,1,2);
temp = semilogy([0: system_cap], state_hist/sim_time, 'x'); set(temp, 'Color', plot_color);
xlabel('number of customers in system (n)'); ylabel('P [ n customers in system ]');


% Written by: Dr C Aswakul (30 June 2002)
% Course: principles of traffic engineering in communication networks
%
% Remark: For those of you who have read up to this line, I recommend that you try
% modifying the above code so as to simulate M/D/C/K system. Of course, the
% number of service channels (C) must not exceed the total number of customers
% in the system (K). In addition, after completing M/D/C/K simulation, you
% are challenged again to write a simulator for G/D/C/K system, that is, for
% any general distribution of customer inter-arrival times!!! Then, come to
% discuss with me what you have achieved.
%}

endfunction
