classdef Run
    % Stores all the relevant data from one test run with the device
    properties (SetAccess = immutable)
        t_stamp     % Time Stamp
        T           % Sampling Period [Float]
        t           % Time vector  [N x 1][Float][sec] 
        acc         % ADC readings [N x 1][Int:0-1023]
        V           % Actuator values [N x 1][Float: -150-+150][Volts]
        control
    end
    properties (Dependent)
        g
        x
    end
    methods
        function obj = Run(T,t,acc,control,V)
            % obj = Run(T,t,acc,x,V)
            % Initializer
            obj.t_stamp = Run.TimeStamp();
            obj.T = T;
            % Some of the vectors might not be the same length as t
            ns = Run.expand(t,acc,V);
            obj.t   = ns{1};
            obj.acc = ns{2};
            obj.V = ns{3};
            if ~isempty(control.x)
                ns = Run.expand(t,control.x(1,:)',control.x(2,:)');
                control.x = [ns{2}' ; ns{3}']; 
            end
            obj.control = control;
        end
        function [signal, name] = signal_index(run,index)
            % Establishes a numbering convention for the stored signals
            switch index
                case 1
                    name = 'x';
                    signal = run.x(1,:)';
                case 2
                    name = 'v';
                    signal = run.x(2,:)';
                case 3
                    name = 'g';
                    signal = Arduino.n_to_g(3,run.acc);
                case 4
                    name = 'acc';
                    signal = run.acc;
                case 5
                    name = 'V';
                    signal = run.V;
            end
        end
        function store(run,varargin)
            % store(run)
            % Stores the run object in the /db directory.
            directory_name = 'db/';
            file_name = run.t_stamp;
            if 0 < nargin
                whole_name = strcat(directory_name,varargin{1},file_name);
            else
                whole_name = strcat(directory_name,file_name);
            end
            save(whole_name,'run');
        end
        function plot_cutoff(run,index,cut_off)
            [signal, name] = run.signal_index(index);
            figure
            hax = axes;
            hold on
            grid on
            plot(run.t,signal,'k');
            line(get(hax,'XLim'),[cut_off cut_off]);
            title(name);
            xlabel('t [sec]');
            hold off
        end
        function plot(run,base_index,plot_index,varargin)
            % plot(base_index,plot_index)
            % Plots the functions given in plot_index by refering them to
            % the one given in base_index
            N = length(plot_index);
            [base, base_name] = run.signal_index(base_index);
            name_list = cell(N,1);
            cc = get(0,'DefaultAxesColorOrder');
            hold on
            for i = 1:N
                [signal, name] = run.signal_index(plot_index(i));
                name_list{i} = name;
                plot(run.t,Run.nm(base,signal),'color',cc(i,:))
            end
            grid on
            legend(name_list{:});
            title(['Normalized with respect to ',base_name]);
            xlabel('t [sec]');
            if 0 < length(varargin)
                for i = 1:length(varargin)
                    y = varargin{i};
                    if iscell(y)
                        plot(y{1},Run.nm(base,y{2}),'color',cc(i+N,:));
                    else
                        if length(y) ~= length(run.t)
                            error('Argument with wrong length: %d vs %d', ...
                                     length(run.t),  length(y));
                        else 
                            plot(run.t,Run.nm(base,y),'color',cc(i+N,:));
                        end
                    end
                end   
            end
            hold off
        end
        function g = get.g(run)
            g = Arduino.n_to_g(3,run.acc);
        end
        function x = get.x(run)
            % x = get.x(run)
            % Wrapper
            x = run.control.x;
        end
    end
    methods (Static)
        function file_list = find(directory,f)
            % file_list = find(directory,f)
            % Returns a cell containing the file names of the runs that
            % return true for function f.
            file_list = [];
            count = 1;
            run_list = dir([directory,'*.mat']);
            N = length(run_list);
            for i = 1:N
                file = [directory,'/',run_list(i).name];
                space = load(file);
                run = space.run;
                if f(run)
                    run_list(i).name = [directory,'/',run_list(i).name];
                    file_list = [file_list run_list(i)];
                end
            end
            
        end
        function out = map(run_list,varargin)
            % out = map(run_list,varargin)
            % run_list can be either a directory or a list of files
            if ischar(run_list)
                directory = run_list;
                run_list = dir([directory,'*.mat']);
                N = length(run_list);
                for i = 1:N
                    run_list(i).name = [directory,'/',run_list(i).name];
                end
            end
            N = length(run_list);
            NF = length(varargin);
            out = cell(NF,N);
            for i = 1:N
                space = load(run_list(i).name);
                run = space.run;
                for n = 1:NF
                    f = varargin{n};
                    out{n,i} = f(run);
                end
            end
        end
        function [t_vec,a,u] = sine_wave(a,total_t,g_max,T,A,f)
            f = @(k,t,g) A*sin(2*pi*f*t);
            s = @(k,t,g) (Arduino.n_to_g(3,g) < g_max);
            [t_vec,a,u] = Run.loop(a,total_t,T,2,s,f);
        end
        function run = pid_run(ard,control,total_t,T,g_max)
            % [t_vec,a,u] = loop(ard,total_t,T,k_init,f_stop,f_u)
            k = control.n_samples + 1;
            [t_vec,a,u] = Run.prepare_run(total_t,T);
            g = a;
            input('Press enter to start loop');
            % Start loop
            Run.sine_wave(ard,8,g_max,T,150,2.962);
            prev = 0;
            ard.roundTrip(0,0);
            tic
            elapsed_time = toc;
            while (elapsed_time < total_t)
                elapsed_time = toc;
                if Run.sample_time(1e-4,T,prev,elapsed_time)
                    a(k) = ard.sample;
                    g(k) = Arduino.n_to_g(3,a(k));
                    u(k) = control.pid_loop(k,u,g);
                    ard.piezo_actuate(u(k));
                    t_vec(k) = elapsed_time;
                    prev = elapsed_time;
                    k = k + 1;
                end
            end
            ard.roundTrip(0,0);
            run = Run(T,t_vec,a,control,u);
        end
        function [t_vec,a,u] = loop(ard,total_t,T,k_init,f_stop,f_u)
            % [t_vec,a,u] = loop(ard,total_t,T,k_init,f_stop,f_u)
            k = k_init;
            [t_vec,a,u] = Run.prepare_run(total_t,T);
            prev = 0;
            ard.roundTrip(0,0);
            tic
            elapsed_time = toc;
            while f_stop(k,elapsed_time,a(k-1)) && (elapsed_time < total_t)
                elapsed_time = toc;
                if Run.sample_time(1e-4,T,prev,elapsed_time)
                    a(k) = ard.sample;
                    u(k) = f_u(k,elapsed_time,a(k));
                    ard.piezo_actuate(u(k));
                    t_vec(k) = elapsed_time;
                    prev = elapsed_time;
                    k = k + 1;
                end
            end
            ard.roundTrip(0,0);
        end
        function run = control_run(ard,total_t,T,g_max,control)
            % Prepare Loop
            ard.roundTrip(0,0);
            control.init(Run.N_from_time(total_t,T));
            s = @(k,t,a) true;
            f = @(k,t,a) control.loop(k,t,Arduino.n_to_g(3,a));
            input('Press enter to start loop');
            % Start loop
            Run.sine_wave(ard,8,g_max,T,150,2.962);
            [t_vec,a,u] = Run.loop(ard,total_t,T, ...
                                control.n_samples+1,s,f);
            run = Run(T,t_vec,a,control,u);
        end
        function compare_runs(runU,runC)
            dU = DSP.get_damping(runU.T,runU.t,runU.g);
            dC = DSP.get_damping(runC.T,runC.t,runC.g);
            message = { DSP.to_str('\zeta_{uncontrolled}',dU,''), ...
                        DSP.to_str('\zeta_{controlled}',dC,'')};
            hold on
            title('Compare Runs')
            grid on
            plot(runU.t,runU.g)
            plot(runC.t,runC.g,'k')
            legend('Uncontrolled','Controlled')
            text(0.7*runU.t(end),0.5*max(runU.g),message)
            ylabel('g [gs]')
            xlabel('t [sec]')
            hold off
        end
        function [t,acc,V] = prepare_run(total_time,T)
            N = Run.N_from_time(total_time,T);
            t = zeros(N,1);
            acc = zeros(N,1);
            V = zeros(N,1);
        end
        function N = N_from_time(total_time,T)
            N = floor(total_time / T) + 30;
        end
        function b = sample_time(tol,T,prev,elapsed)
            % b = sample_time(tol,T,prev,elapsed)
            % Returns true if it's time to sample or the time has passed.
            b = (prev + T < elapsed) || abs(prev + T - elapsed) < tol;
        end
        function out_x = expand(t,varargin)
            % new_x = expand(t,x)
            % When the time extends beyond the original memory allocation,
            % not all the vectors are the same size. To solve that, we
            % expand them to match the longest one and leave them a trail of zeros.
            new_N = length(t);
            index = (t ~= 0);
            NS    = length(varargin) + 1;  % Number of signals + time
            out_x    = cell(NS,1);
            out_x{1} = t(index);
            for i = 2:NS
                x = varargin{i-1};
                original_N = length(x);
                if original_N < new_N
                    x = [x; zeros(new_N - original_N,size(x,2))];
                else
                    x = x;
                end
                out_x{i} = x(index);
            end
        end
        function s = TimeStamp()
            % s = TimeStamp()
            % time stamp in the format
            % year-month-day-hours-h-minutes-m-second-s
            time = clock; 
            hours = datestr(time,'HH:MM:SS');
            hours(3:3:9) = 'hms';
            s = [datestr(time,'yyyy-mm-dd'),' ',hours];
        end
        % Probably belong somewhere else (Signal processing?)
        function nx = nm(y,x)
            % nx = nm(y,x)
            % Normalizes x with respect to y
            % Useful for graphing
            nx = rms(y)*x/rms(x);
        end
        function phi = phase(x,y)
            % phi = phase(x,y)
            % Naive implementation of phase between signals.
            phi = (180/pi)*dot(x,y)/(norm(x)*norm(y));
        end
    end
end