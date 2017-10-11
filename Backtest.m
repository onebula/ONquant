function [Asset] = Backtest(StrategyFunc,windcode,start_time,end_time,Options)
% 加载K线数据
if ischar(windcode)
    % 定位游标位置到第一条K线
    DB.CurrentK = 1;
    [Data flag] = LoadData(windcode,start_time,end_time,Options);
    DB=setfield(DB,[windcode(8:9) windcode(1:6)],Data);
    if flag==0
        disp('=== Back test shutting down! ===')
        return;
    end
end
if iscell(windcode)
    % 定位游标位置到第一条K线
    DB.CurrentK = 1;
    for i=1:max(size(windcode))
        [Data flag] = LoadData(windcode{i},start_time,end_time,Options);
        DB=setfield(DB,[windcode{i}(8:9) windcode{i}(1:6)],Data);
        if flag==0
            disp('=== Back test shutting down! ===')
            return;
        end
    end
end
% 时间轴
DB.Times = Data.Times;
DB.TimesStr = datestr(Data.Times,'yymmdd');%按年月日格式的时间戳（交易日）
% K线总数
DB.NK = length(Data.Open);

% 初始化资产池
Asset = InitAsset(DB);

% 按K线循环
for K = 1:DB.NK
    DB.CurrentK = K; %当前K线
    Signal = StrategyFunc(DB); %运行策略函数，生成交易信号
    if ~isempty(Signal)
        for sig=1:length(Signal)
            if strcmp(Signal{sig}.Direction,'BUY') == 1
                Asset = Buy(DB,Asset,Signal{sig}.Stock,Signal{sig}.Volume,NaN,'Close'); % 落单，按收盘价买
            elseif strcmp(Signal{sig}.Direction,'SELL') == 1
                Asset = Sell(DB,Asset,Signal{sig}.Stock,Signal{sig}.Volume,NaN,'Close'); % 落单，按收盘价卖
            end
        end
    end
    
    % 每条K线在运行结束时都要清算
    Asset = Clearing(DB,Asset);
end

Summary(DB,Asset);
disp('=== Back test complete! ===')