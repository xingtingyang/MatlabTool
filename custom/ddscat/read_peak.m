function read_peak(varargin)
%READ_PEAK from qtable and save peak info into peaks.log

    % check input parameters
    if(nargin<1&&narargin>2)
        error('no input paramters.');
    elseif(nargin==1)
        input_file = varargin{1};
        flag = 'off';
    else
        input_file = varargin{1};
        flag = varargin{2};
    end
    
    spec = importdata(input_file,' ',14);
    data = spec.data;
    x_data = data(:,2)'*1000;
    y_data = data(:,3)';
    
    % first we should interp the xdata and ydata to get more accurate peak
    % info.
    x_minmax = minmax(x_data);
    data_series = linspace(x_minmax(1),x_minmax(2),2000);
    y_data_interp = interp1(x_data,y_data,data_series);  
    [pks,loc] = findpeaks(y_data_interp,'NPEAKS',2);

    x_peaks = data_series(loc);
    y_peaks = pks;
    
    if strcmp(flag,'on')
        hold on
        plot(data_series,y_data_interp);
        scatter(x_peaks,y_peaks,'s');
        hold off
    end
       
    % write peaks data into peaks.log
    dlmwrite('peaks.log',[x_peaks,y_peaks],'-append','delimiter', '\t');
end
