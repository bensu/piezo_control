classdef Run
    % Stores all the relevant data from one test run with the device
    properties (SetAccess = immutable)
        t_stamp     % Time Stamp
        T           % Sampling Period [Float]
        t           % Time vector  [N x 1][Float][sec] 
        acc         % ADC readings [N x 1][Int:0-1023]
        x           % State vector [2 x N][Float][g;g*sec;g*sec^2]
        V           % Actuator values [N x 1][Float: -150-+150][Volts]
    end
    properties (Dependent)
        g
    end
    methods
        function obj = Run(T,t,acc,x,V)
            % obj = Run(T,t,acc,x,V)
            % Initializer
            obj.t_stamp = Run.TimeStamp();
            obj.T = T;
            % Some of the vectors might not be the same length as t
            V   = Run.expand(t,V);
            x   = Run.expand(t,x')';
            acc = Run.expand(t,acc);
            % The run might not have filled all the allocated memory -> the
            % extra values are eliminated.
            index_values = (t ~= 0);
            obj.t = t(index_values);
            obj.acc = acc(index_values);
            obj.x = x(:,index_values);
            obj.V = V(index_values);
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
                    if length(y) ~= length(run.t)
                        error('Argument with wrong length: %d vs %d', ...
                                 length(run.t),  length(y));
                    else 
                        plot(run.t,Run.nm(base,y),'color',cc(i+N,:));
                    end
                end   
            end
            hold off
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
                    signal = n_to_g(3,run.acc);
                case 4
                    name = 'acc';
                    signal = run.acc;
                case 5
                    name = 'V';
                    signal = run.V;
            end
        end
        function store(run)
            % store(run)
            % Stores the run object in the /db directory.
            directory_name = 'db/';
            file_name = run.t_stamp;
            whole_name = strcat(directory_name,file_name);
            save(whole_name,'run');
        end
        function g = get.g(run)
            g = n_to_g(3,run.acc);
        end
    end
    methods (Static)
        function new_x = expand(t,x)
            % new_x = expand(t,x)
            % When the time extends beyond the original memory allocation,
            % not all the vectors are the same size. To solve that, we
            % expand them to match the longest one and leave them a trail of zeros.
            new_N = length(t);
            original_N = length(x);
            if original_N < new_N
                new_x = [x; zeros(new_N - original_N,size(x,2))];
            else
                new_x = x;
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