files = dir('Logging_data\Test_AstaZero_25_08\data\data39.csv');
len=length(files);
filename_cell = cell(len,1);
description_cell = cell(len,1);
exp_last_list = zeros(len,1);
longitude_rad_cell = cell(len,1);
latitude_rad_cell = cell(len,1);
X_position_m_cell = cell(len,1);
Y_position_m_cell = cell(len,1);
R_e = 6357000;

Fig_plot_Pos = figure();
hold on
grid on
for ind=1:len
    csv_name=files(ind).name;
        data_table = readtable(csv_name); 
        non_zero_ind = find(data_table.LongGPS_deg_ > 0.0001, 1, 'first');
        data_table = data_table(non_zero_ind:end, :);
        exp_last_list(ind) = data_table.Time(end);
        filename_cell{ind} = csv_name;
        longitude_rad = data_table.LongGPS_deg_;
        latitude_rad = data_table.LatGPS_deg_;
        ini_longitude_deg = rad2deg(longitude_rad(1));
        if abs(ini_longitude_deg - 12.77) < 0.1
            location_str = 'AstaZERO';
        elseif abs(ini_longitude_deg - 11.97) < 0.1
            location_str = 'Johanneberg';
        else
            location_str = 'UnknownLocation';
        end
        description_cell{ind} = [ location_str ' Exp: ' csv_name(end-8:end)];
        
        longitude_rad_cell{ind} = data_table.LongGPS_deg_;
        latitude_rad_cell{ind} = data_table.LatGPS_deg_;
        data_length = length(data_table.LatGPS_deg_);
        
        ini_longitude_rad = longitude_rad(1);
        ini_latitude_rad = latitude_rad(1);
        inix_GPS = R_e * ( ini_longitude_rad * cos(ini_latitude_rad));
        iniy_GPS =  R_e *  ini_latitude_rad;
        
        x_path_NED = zeros(data_length, 1);
        y_path_NED = zeros(data_length, 1);
        for ind_path = 2:length(x_path_NED)
            x_path_NED(ind_path) = R_e * ( longitude_rad(ind_path) * cos(ini_latitude_rad)) - inix_GPS;
            y_path_NED(ind_path) =  R_e * ( latitude_rad(ind_path)) - iniy_GPS;
        end
        X_position_m_cell{ind} = x_path_NED;
        Y_position_m_cell{ind} = y_path_NED;

        figure(Fig_plot_Pos)
        plot(x_path_NED, y_path_NED)

end
clickableLegend(description_cell)