function [P_t, x_t w_Q, w_r] =AKFTracking ( P_t_1 , x_t_M_1 , z_t ,w_Q,w_r)
    %% Set parameters 
    % Note that the timer interval defined here is 1 second, we sample
    % every 0.1 seconds so may have to do some averaging as a preprocessing
    % step
    delta_t = .1;
    A = [1 0 delta_t 0; 0 1 0 delta_t; 0 0 1 0; 0 0 0 1];
    H = [1 0 0 0; 0 1 0 0 ];
    C = H;
    D = 0;
    B = zeros(4,4);
    
    %% Define the 4x4 identity matrix used for equation 19
    Iden = eye(4);
    
    %% Define Q and R
    %w_Q = 1;
    %w_r = 1;
    Q = w_Q*eye(4);
    f = 0.1845;
    R = w_r*[f f/40; f/40 f/4];
    
    %% Equation 15 and 16
    x_t_M = A*x_t_M_1;%+ B*u_t_1; % State estimate for next time step
    P_priori_t = A*P_t_1*A' + Q;
    
    %% Equation 17-19
    K_t = P_priori_t*H'*inv(H*P_priori_t*H' + R);
    x_t = x_t_M + K_t*(z_t'-H*x_t_M);
    P_t = (Iden -K_t*H)*P_priori_t;
    
    a_x = abs((x_t(1)-x_t_M_1(1))/delta_t);
    a_y = abs((x_t(2)-x_t_M_1(2))/delta_t);
    T_acc = 1; %% Acceleration threshold.
    if (a_x >= T_acc || a_y >= T_acc)
        w_r = 7.5/(T_acc.^2);
        w_Q = 0.75/(T_acc);
    else
        w_r = 7.5/(T_acc);
        w_Q = 0.25/(T_acc);
    end
        

end


