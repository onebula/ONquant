function [Asset,DB] = Backtest(StrategyFunc,Context,windcode,start_time,end_time,Options)
% 运行量化接口取数据
w = windmatlab;
% 加载K线数据
if ischar(windcode)
    % 定位游标位置到第一条K线
    DB.CurrentK = 1;
    [Data flag] = LoadData(w,windcode,start_time,end_time,Options);
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
        [Data flag] = LoadData(w,windcode{i},start_time,end_time,Options);
        DB=setfield(DB,[windcode{i}(8:9) windcode{i}(1:6)],Data);
        if flag==0
            disp('=== Back test shutting down! ===')
            return;
        end
    end
end
% 加载回测基准行情数据
[w_wsd_data_0,w_wsd_codes_0,w_wsd_fields_0,w_wsd_times_0,w_wsd_errorid_0,w_wsd_reqid_0]= ...
    w.wsd(Options.Benchmark,'close',start_time,end_time,'PriceAdj=F');
if w_wsd_errorid_0~=0
    disp(['!!! 加载' Options.Benchmark '行情数据错误: ' w_wsd_data_0{1} ' Code: ' num2str(w_wsd_errorid_0) ' !!!']);
    return;
end
DB.Benchmark = w_wsd_data_0;
DB.BenchmarkStock = Options.Benchmark;
% 时间轴
DB.Times = Data.Times;
DB.TimesStr = datestr(Data.Times,'yymmdd');%按年月日格式的时间戳（交易日）
% K线总数
DB.NK = length(Data.Open);

% 初始化资产池
Asset = InitAsset(DB,Options);

% 按K线循环
for K = 1:DB.NK
    DB.CurrentK = K; %当前K线
    HisDB = HisData(DB,windcode,Options);
    Signal = StrategyFunc(HisDB,Context); %运行策略函数，生成交易信号
    if ~isempty(Signal)
        for sig=1:length(Signal) %按信号顺序落单
            if sum(strcmp(Signal{sig}.Stock, windcode))
                Asset = Order(DB,Asset,Signal{sig}.Stock,Signal{sig}.Volume,Signal{sig}.Type,Options); % 落单
            else
                disp(['!!! 未订阅' Signal{sig}.Stock '数据，请加入股票订阅池后再次运行回测 !!!']);
                return;
            end
        end
    end
    
    % 每条K线在运行结束时都要清算
    Asset = Clearing(Asset,DB,Options);
end

Asset=Summary(Asset,DB,Options);
disp('=== Back test complete! ===')