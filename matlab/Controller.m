classdef Controller < handle
    % class Controller
    % Data structure that contains the controller parameters
    properties
        system
        x       % State vector
        Mn      % Kalman filter coefficients
        cut_off
        K
        PID     % Cell with polinomials
    end
    properties (Dependent)
        n_samples
    end
    methods
        function obj = Controller(digital_system,cut_off)
            % obj = Controller(digita_system,cut_off,K)
            obj.system = digital_system;
            obj.cut_off = cut_off;
        end
        function add_pid(con,T,Kp,Ti,Td,N)
            [num,den] = tfdata(pidstd(Kp,Ti,Td,N,T));
            con.PID = {num{1},den{1}};
        end
        function uk = loop(con,k,tk,yk)
            con.x(:,k) = con.predict(k,con.x(:,k-1),0,yk);
            if any(abs([con.x(:,k)' yk]) > con.cut_off)
                uk = -con.K*[con.x(:,k); yk];
            else 
                uk = 0;
            end
        end
        function uk = pid_loop(con,k,u,y)
            if abs(y(k)) > con.cut_off(3)
                uk = -DSP.real_filter(con.PID{1},con.PID{2},k,y,u);
            else 
                uk = 0;
            end
        end
        function init(control,N)
            control.x = zeros(2,N);
        end
        function xk = predict(con,k,xk_1,uk,yk)
              % xk = predict(con,k,xk_1,uk,yk)
              M = con.Mk(k-1);
              % Measurement update, x[k|k]
              x_aux = xk_1 + M*(yk-con.system.C*xk_1);
              % Time update, x[k+1|k]
              xk = con.system.A*x_aux + con.system.B*uk;
        end
        function controller = find_Mn(controller,Q,R,tol)
            A = controller.system.A;
            B = controller.system.B;
            C = controller.system.C;
            %% Find optimal coefficients
            N_it = 20;
            M = zeros(2,N_it);
            P = zeros(2,2,N_it); 
            P(:,:,1) = B*Q*B';    % Initial error covariance
            i = 1;
            error = 1;
            while (error > tol) && (i < N_it)
                Pi = P(:,:,i);
                M(:,i) = Pi*C'/(C*Pi*C'+R);
                Pii = (eye(2)-M(:,i)*C)*Pi;      % P[n|n]
                P(:,:,i+1) = A*Pii*A' + B*Q*B';  % P[n+1|n]
                error = norm(P(:,:,i+1)-Pi);
                i = i + 1;
            end
            % P = P(:,:,1:i-1);
            M = M(:,1:i-1);
            controller.Mn = M;
        end
        function find_Kk(con,Q,R)
            con.K = [dlqr(con.system.A,con.system.B,Q,R,0) 0];
        end
        function viscous_control(con,Kv)
            con.K = [0 Kv 0];
        end
        function M = Mk(controller,k)
            % M = Mk(controller,k)
            % Wrapper
            if k < size(controller.Mn,2)
                M = controller.Mn(:,k);
            else
                M = controller.Mn(:,end);
            end
        end
        function K = Kk(controller,k)
            % K = Kk(controller,k)
            % Wrapper
            if k < size(controller.K,2)
                K = controller.K(:,k);
            else
                K = controller.K(:,end);
            end
        end
        function n = get.n_samples(con)
            n1 = 0;
            if ~isempty(con.Mn)
                n1 = 2;
            end
            n2 = 0;
            if ~isempty(con.PID)
                n2 = max([length(con.PID{1}),length(con.PID{2})]);
            end
            n = max([n1 n2]);
        end
    end
    methods (Static)
        function ds = second_order_system(T,omega,damping,bk)
            % ds = second_order_system(omega,damping,bk)
            Ac  = [0 1; -omega^2 -2*damping*omega];
            Bc  = [0; bk];
            C   = [-omega^2 -2*damping*omega];
            D   = 0;
            cs  = ss(Ac,Bc,C,D);	% Continuous system
            ds  = c2d(cs,T,'zoh');	% Discrete system
        end
    end
end