%读取每一列数据：时间，最高价，最低价，结束价
minute_time = data(:,1);
minute_max = cell2mat(data(:,3));
minute_min = cell2mat(data(:,4));
minute_close = cell2mat(data(:,5));
minute_time_num = datenum(minute_time);
%minute_time_num = datetime(minute_time_num,'ConvertFrom','datenum');
%date = datestr(datenum(minute_time_num,'mmdd'))

%创建一个以天数为单位的时间序列
Y = [2015];
M = [01];
D = [5:9,12:13];
date_sample = datetime(Y,M,D);
date_sample = datenum(date_sample);

%新建每日最高价、最低价、收盘价数组
daily_max_mat = [];
daily_min_mat = [];
daily_close_mat = [];

%计算每日最高、最低、收盘价，放入mat中
for i = 1:length(date_sample)-1
    ind = find(minute_time_num>=date_sample(i) & minute_time_num<date_sample(i+1));
    daily_max = max(minute_max(ind(1):ind(end)));
    daily_max_mat(i) = daily_max;
    daily_min = min(minute_min(ind(1):ind(end)));
    daily_min_mat(i) = daily_min;
    daily_close = minute_close(ind(end));
    daily_close_mat(i) = daily_close;
end
