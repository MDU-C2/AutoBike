function  TrajectoryCreator()
% Create a GUI with buttons to plot different shapes, set their initial positions,
% and save their data
clc;
close all;
clear all;

% Set the default number of datapoints and initial positions
default_n = 100;
default_scale = 1;
default_x = 0;
default_y = 0;
default_head = 90;
default_dir = 0;
trajectory = [0;0];
global n;

% Create the main window and set its size
figure('Name','GUI','Position', [50, 250, 500, 500]);

% Create an edit box to enter number of points
edit_n = uicontrol('Style', 'edit', 'String', num2str(default_n), ...
                   'Position', [350, 450, 50, 30]);
uicontrol('Style', 'text', 'String', '# datapoints', ...
                   'Position', [400, 450, 50, 30]);

% Create an edit box to enter line settings
startline_x = uicontrol('Style', 'edit', 'String', num2str(default_x), ...
                   'Position', [100, 400, 50, 30]);
uicontrol('Style', 'text', 'String', 'Initial X', ...
                   'Position', [100, 430, 50, 30]);
startline_y = uicontrol('Style', 'edit', 'String', num2str(default_y), ...
                   'Position', [150, 400, 50, 30]);
uicontrol('Style', 'text', 'String', 'Initial Y', ...
                   'Position', [150, 430, 50, 30]);
endline_x = uicontrol('Style', 'edit', 'String', num2str(default_x), ...
                   'Position', [200, 400, 50, 30]);
uicontrol('Style', 'text', 'String', 'End X', ...
                   'Position', [200, 430, 50, 30]);
endline_y = uicontrol('Style', 'edit', 'String', num2str(default_y), ...
                   'Position', [250, 400, 50, 30]);
uicontrol('Style', 'text', 'String', 'End Y', ...
                   'Position', [250, 430, 50, 30]);

% Create an edit box to enter curve settings
startcurve_x = uicontrol('Style', 'edit', 'String', num2str(default_x), ...
                   'Position', [100, 350, 50, 30]);
startcurve_y = uicontrol('Style', 'edit', 'String', num2str(default_y), ...
                   'Position', [150, 350, 50, 30]);
edit_radiuscurve = uicontrol('Style', 'edit', 'String',num2str(default_scale), ...
                   'Position', [200, 350, 50, 30]);
uicontrol('Style', 'text', 'String', 'Radius', ...
                   'Position', [200, 380, 50, 20]);
heading_start = uicontrol('Style', 'edit', 'String', num2str(default_x), ...
                   'Position', [250, 350, 50, 30]);
uicontrol('Style', 'text', 'String', 'Initial heading', ...
                   'Position', [250, 380, 50, 20]);
heading_end = uicontrol('Style', 'edit', 'String', num2str(default_head), ...
                   'Position', [300, 350, 50, 30]);
uicontrol('Style', 'text', 'String', 'End heading', ...
                   'Position', [300, 380, 50, 20]);

% Create an edit box to enter circle settings
startcir_x = uicontrol('Style', 'edit', 'String', num2str(default_x), ...
                   'Position', [100, 250, 50, 30]);
startcir_y = uicontrol('Style', 'edit', 'String', num2str(default_y), ...
                   'Position', [150, 250, 50, 30]);
edit_radiuscir = uicontrol('Style', 'edit', 'String', num2str(default_scale), ...
                   'Position', [200, 250, 50, 30]);
uicontrol('Style', 'text', 'String', 'Radius', ...
                   'Position', [200, 280, 50, 20]);
startcir_heading = uicontrol('Style', 'edit', 'String', num2str(default_x), ...
                   'Position', [250, 250, 50, 30]);
uicontrol('Style', 'text', 'String', 'Initial heading deg', ...
                   'Position', [250, 280, 50, 20]);
startcir_dir = uicontrol('Style', 'edit', 'String', num2str(default_dir), ...
                   'Position', [300, 250, 50, 30]);
uicontrol('Style', 'text', 'String', 'direction 0 == right || 1 == left', ...
                   'Position', [300, 280, 50, 20]);
startcir_side = uicontrol('Style', 'edit', 'String', num2str(default_dir), ...
                   'Position', [350, 250, 50, 30]);
uicontrol('Style', 'text', 'String', 'side 0 == right || 1 == left', ...
                   'Position', [350, 280, 50, 20]);


% Create an edit box to enter sinus settings
startsin_x = uicontrol('Style', 'edit', 'String', num2str(default_x), ...
                   'Position', [100, 200, 50, 30]);
startsin_y = uicontrol('Style', 'edit', 'String', num2str(default_y), ...
                   'Position', [150, 200, 50, 30]);
sin_amp = uicontrol('Style', 'edit', 'String', num2str(default_scale), ...
                   'Position', [200, 200, 50, 30]);
uicontrol('Style', 'text', 'String', 'Amplitude', ...
                   'Position', [200, 230, 50, 20]);
sin_freq = uicontrol('Style', 'edit', 'String', num2str(default_scale), ...
                   'Position', [250, 200, 50, 30]);
uicontrol('Style', 'text', 'String', 'frequency', ...
                   'Position', [250, 230, 50, 20]);
sin_rep = uicontrol('Style', 'edit', 'String', num2str(default_scale), ...
                   'Position', [300, 200, 50, 30]);
uicontrol('Style', 'text', 'String', 'Repetitions', ...
                   'Position', [300, 230, 50, 20]);

% Create an edit box to enter bump settings
startbum_x = uicontrol('Style', 'edit', 'String', num2str(default_x), ...
                   'Position', [100, 300, 50, 30]);
startbum_y = uicontrol('Style', 'edit', 'String', num2str(default_y), ...
                   'Position', [150, 300, 50, 30]);
bum_amp = uicontrol('Style', 'edit', 'String', num2str(default_scale), ...
                   'Position', [200, 300, 50, 30]);
uicontrol('Style', 'text', 'String', 'Amplitude', ...
                   'Position', [200, 330, 50, 20]);
bum_freq = uicontrol('Style', 'edit', 'String', num2str(default_scale), ...
                   'Position', [250, 300, 50, 30]);
uicontrol('Style', 'text', 'String', 'frequency', ...
                   'Position', [250, 330, 50, 20]);
bum_rep = uicontrol('Style', 'edit', 'String', num2str(default_scale), ...
                   'Position', [300, 300, 50, 30]);
uicontrol('Style', 'text', 'String', 'Repetitions', ...
                   'Position', [300, 330, 50, 20]);



% Create an edit box to enter infinite settings
startinf_x = uicontrol('Style', 'edit', 'String', num2str(default_x), ...
                   'Position', [100, 150, 50, 30]);
startinf_y = uicontrol('Style', 'edit', 'String', num2str(default_y), ...
                   'Position', [150, 150, 50, 30]);
edit_radiusinf = uicontrol('Style', 'edit', 'String', num2str(default_scale), ...
                   'Position', [200, 150, 50, 30]);
uicontrol('Style', 'text', 'String', 'Radius', ...
                   'Position', [200, 180, 50, 20]);


% Create buttons to plot each shape
uicontrol('Style', 'pushbutton', 'String', 'Line', ...
          'Position', [50, 400, 50, 50], 'Callback', @plot_line);
uicontrol('Style', 'pushbutton', 'String', 'Curve', ...
          'Position', [50, 350, 50, 50], 'Callback', @plot_curve);
uicontrol('Style', 'pushbutton', 'String', 'bump', ...
          'Position', [50, 300, 50, 50], 'Callback', @plot_bump);
uicontrol('Style', 'pushbutton', 'String', 'Circle', ...
          'Position', [50, 250, 50, 50], 'Callback', @plot_circle);
uicontrol('Style', 'pushbutton', 'String', 'Sinus', ...
          'Position', [50, 200, 50, 50], 'Callback', @plot_sinus);
uicontrol('Style', 'pushbutton', 'String', 'infinite', ...
          'Position', [50, 150, 50, 50], 'Callback', @plot_infinite);
uicontrol('Style', 'pushbutton', 'String', 'Save', ...
          'Position', [50, 100, 50, 50], 'Callback', @save_data);

% Initialize the data matrix to an empty array
data = [];
figure('Name','Example of segment','Position', [550, 250, 500, 500])

figure('Name','Example of segment','Position', [1050, 250, 500, 500])
% Define the functions to plot each shape
       function [x, y] = plot_line(~, ~)
        n = str2double(get(edit_n, 'String'));
        x_init = str2double(get(startline_x, 'String'));
        y_init = str2double(get(startline_y, 'String'));
        x_end = str2double(get(endline_x, 'String'));
        y_end = str2double(get(endline_y, 'String'));
        x = linspace(x_init, x_end, n) ;
        y = linspace(y_init, y_end, n);
        figure(2)
        plot(x, y,'*');
        axis equal
        hold on;
        plot(x(1), y(1), 'o');
        hold off
        title('Line');
        data = [x; y];
       end

      function [x, y] = plot_curve(~, ~)
        n = str2double(get(edit_n, 'String'));
        x_init = str2double(get(startcurve_x, 'String'));
        y_init = str2double(get(startcurve_y, 'String'));
        radius = -str2double(get(edit_radiuscurve, 'String'));
        heading_s = deg2rad(str2double(get(heading_start, 'String')));
        heading_e = deg2rad(str2double(get(heading_end, 'String')));
        theta = linspace(0, (heading_s-heading_e), n);
        x = -radius*cos(theta-heading_s+(0.5*pi)) +  x_init - radius*sin(heading_s);
        y = radius*sin(theta-heading_s+(0.5*pi))  +  y_init - radius*cos(heading_s);
        figure(2)
        plot(x, y,'*');
        hold on;
        axis equal
        plot(x(1), y(1), 'o');
        hold off
        title('curve');
        data = [x; y];
       end
    
function [x, y] = plot_circle(~, ~)
        radius = str2double(get(edit_radiuscir, 'String'));
        n = str2double(get(edit_n, 'String'));
%         heading = deg2rad(str2double(get(startcir_heading, 'String')))-0.5*pi;
        heading = deg2rad(str2double(get(startcir_heading, 'String')));
        x_init = str2double(get(startcir_x, 'String'));
        y_init = str2double(get(startcir_y, 'String'));
        direction = str2double(get(startcir_dir, 'String'));
        side=str2double(get(startcir_side, 'String'));

        if direction == 0 || side==0
            theta = linspace(pi, pi, n);
            x = radius*cos(theta) +  x_init-(2*radius);
            y = radius*sin(theta) +  y_init;
        elseif direction == 0 || side==1
            theta = linspace(pi, -pi, n);
            x = radius*cos(theta) +  x_init;
            y = radius*sin(theta) +  y_init;
        elseif direction == 1 || side==0
            theta = linspace(pi, -pi, n);
            x = radius*cos(theta) +  x_init;
            y = radius*sin(theta) +  y_init;
        elseif  direction == 1 || side==1
            theta = linspace(pi, -pi, n);
            x = radius*cos(theta) +  x_init;
            y = radius*sin(theta) +  y_init;
        end

        theta = linspace(0, 2*pi, n);
        x = radius*cos(theta) +  x_init+radius;
%         x = radius*cos(theta+heading) +  x_init + sign(heading)*radius*cos(heading);
%         y = radius*sin(theta+heading) +  y_init + sign(heading)*radius*sin(heading);
        y = radius*sin(theta) +  y_init;
        figure(2)
        plot(x, y,'*');
        hold on;
        plot(x(1), y(1), 'o');
        hold off;
        title('Circle')
        data = [x;y];
end

    function [x, y] = plot_infinite(~, ~)
        radius = str2double(get(edit_radiusinf, 'String'));
        n = str2double(get(edit_n, 'String'));
        x_init = str2double(get(startinf_x, 'String'));
        y_init = str2double(get(startinf_y, 'String'));
        theta = linspace(0.17*pi, 0.17*pi+6*pi, n);
        y = radius*cos(1.5*theta) + x_init ;
        x = radius*sin(3*theta) / 3 + y_init;
        figure(2)
        plot(x, y,'*');
        hold on;
        plot(x(1), y(1), 'o');
        hold off;
        title('Infinite');
        data = [x; y];
    end

    function [x, y] = plot_sinus(~, ~)
        n = str2double(get(edit_n, 'String'));
        rep = str2double(get(sin_rep, 'String'));
        amplitude = str2double(get(sin_amp, 'String'));
        freq = str2double(get(sin_freq, 'String'));
        x_init = str2double(get(startsin_x, 'String'));
        y_init = str2double(get(startsin_y, 'String'));
        x = linspace(0, (2*pi*rep)/freq, n)+x_init;
        y = amplitude*sin(freq*(x-x_init))+y_init;
        figure(2)
        plot(x, y,'*');
        hold on;
        plot(x(1), y(1), 'o');
        hold off
        title('Sinus Wave');
        data = [x; y];
    end

    function [x, y] = plot_bump(~, ~)
        n = str2double(get(edit_n, 'String'));
        rep = str2double(get(bum_rep, 'String'));
        amplitude = -str2double(get(bum_amp, 'String'));
        freq = str2double(get(bum_freq, 'String'));
        x_init = str2double(get(startbum_x, 'String'));
        y_init = str2double(get(startbum_y, 'String'));
        x = linspace(0, (2*pi*rep)/freq, n)+x_init;
        y = 0.5*amplitude*cos(freq*(x-x_init))+y_init-amplitude*0.5;
        figure(2)
        plot(x, y,'*');
        hold on;
        plot(x(1), y(1), 'o');
        hold off
        title('Sinus Wave');
        data = [x; y];
    end


% Define a function to save the x and y data to a file
    function save_data(~, ~)
        x= data(1,:);
        y= data(2,:);
        figure(3)
        hold on
        plot(x,y)
        axis equal
        hold on
        
        trajectory = [trajectory(1,:) x; trajectory(2,:) y];

        trajectory_final = [trajectory(1,:); trajectory(2,:)]';
        trajectory_final(1,:) = trajectory_final(2,:);
       
        filename_trajectory = 'trajectorymat.csv'; % Specify the filename
        dlmwrite( filename_trajectory, trajectory_final, 'delimiter', ',', 'precision', 10);

        set(startline_x,'String',x(end));
        set(startline_y,'String',y(end));
        set(startcurve_x,'String',x(end));
        set(startcurve_y,'String',y(end));
        set(startsin_x,'String',x(end));
        set(startsin_y,'String',y(end));
        set(startbum_x,'String',x(end));
        set(startbum_y,'String',y(end));
        set(startcir_x,'String',x(end));
        set(startcir_y,'String',y(end));
        set(startinf_x,'String',x(end));
        set(startinf_y,'String',y(end));
    end

    end
