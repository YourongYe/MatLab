%读取每一列数据：时间，最高价，最低价，结束价
minute_time = data(:,1);
minute_max = cell2mat(data(:,3));
minute_min = cell2mat(data(:,4));
minute_close = cell2mat(data(:,5));
minute_time_num = datenum(minute_time);
%minute_time_num = datetime(minute_time_num,'ConvertFrom','datenum');
%date = datestr(datenum(minute_time_num,'mmdd')


%计算历史波动率
hist_vol = std(minute_close);

%最高价
max_price = max(minute_max);

%最低价
min_price = min(minute_min);

%日涨跌最大幅度
dif_max = max(minute_max-minute_min);

%创建装动向值和真实波幅、DX、ADX的mat
up_DM_mat = [];
down_DM_mat = [];
TR_mat = [];
DX_mat = [];
ADX_mat = [];
up_DI_mat = [];
down_DI_mat = [];
ADXR_mat = [];

for i = 2:length(minute_max)
    
  %计算当日动向值
    up_DM = max([minute_max(i) - minute_max(i-1),0]);
    down_DM = max([minute_min(i)- minute_min(i-1),0]);
    if up_DM > down_DM
        down_DM = 0;
    elseif up_DM < down_DM
        up_DM = 0;
    else
        up_DM = 0;
        down_DM = 0;
    end
    
    up_DM_mat(i) = up_DM;
    down_DM_mat(i) = down_DM;
   
  %计算真实波幅（TR）  
    A = minute_max(i) - minute_min(i);
    B = minute_max(i) - minute_close(i-1);
    C = minute_min(i) - minute_close(i-1);
    TR = max([A,B,C]);
  
    TR_mat(i) = TR;
    
  %计算方向线DI
    if i >= 12
        up_DM_mean = mean(up_DM_mat(i-11:i));
        down_DI_mean = mean(down_DM_mat(i-11:i));
        TR_mean = mean(TR_mat(i-11:i));
  
        up_DI = (up_DM_mean/TR_mean)*100;
        down_DI = (down_DI_mean/TR_mean)*100;
        
        up_DI_mat(i) = up_DI;
        down_DI_mat(i) = down_DI;
        
    
  %计算动向值DX
        DX = abs(up_DI-down_DI)/(up_DI+down_DI)*100;
        DX_mat(i) = DX;
    end
  %计算平均动向值ADX
    if i >= 24
        ADX = mean(DX_mat(i-12:i));
        ADX_mat(i) = ADX;
    end
    
  %计算评估数值ADX
    if i >=25
        ADXR = (ADX_mat(i)+ADX_mat(i-1))/2;
        ADXR_mat(i) = ADXR;
    end

end

hold on;
plot(up_DI_mat);
plot(down_DI_mat);
plot(ADX_mat);
plot(ADXR_mat);
hold off;
