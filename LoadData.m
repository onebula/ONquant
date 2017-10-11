function [DB flag] = LoadData(windcode,start_time,end_time,Options)
% 运行量化接口取数据
w = windmatlab;

% 行情数据
[w_wsd_data_0,w_wsd_codes_0,w_wsd_fields_0,w_wsd_times_0,w_wsd_errorid_0,w_wsd_reqid_0]= ...
    w.wsd(windcode,'open,high,low,close,volume',start_time,end_time,'PriceAdj=F');
if w_wsd_errorid_0~=0
    disp(['!!! 加载' windcode '行情数据错误: ' w_wsd_data_0{1} ' Code: ' num2str(w_wsd_errorid_0) ' !!!']);
    flag=0;
    return;
end
% 证券交易信息
[w_wsd_data_1,w_wsd_codes_1,w_wsd_fields_1,w_wsd_times_1,w_wsd_errorid_1,w_wsd_reqid_1]= ...
    w.wsd(windcode,'sec_status,trade_status,pct_chg',start_time,end_time,'PriceAdj=F');
if w_wsd_errorid_1~=0
    disp(['!!! 加载' windcode '交易信息数据错误: ' w_wsd_data_1{1} ' Code: ' num2str(w_wsd_errorid_1) ' !!!']);
    flag=0;
    return;
end
% 证券基本信息
[w_wsd_data_2,w_wsd_codes_2,w_wsd_fields_2,w_wsd_times_2,w_wsd_errorid_2,w_wsd_reqid_2]= ...
    w.wsd(windcode,'ipo_date,concept,industry_CSRC12,industry_gics',start_time,start_time,'industryType=1','PriceAdj=F');
if w_wsd_errorid_2~=0
    disp(['!!! 加载' windcode '基本信息数据错误: ' w_wsd_data_2{1} ' Code: ' num2str(w_wsd_errorid_2) ' !!!']);
    flag=0;
    return;
end
% 数据拼接
DB.Code = windcode;
DB.Info = w_wsd_data_2;%上市日期，概念板块（回测开始日期概念），所属证监会行业名称，所属wind行业名称
DB.Times = w_wsd_times_0;%时间戳（交易日）
DB.TimesStr = datestr(w_wsd_times_0,'yymmdd');%按年月日格式的时间戳（交易日）
DB.Sec_status = w_wsd_data_1(:,1);%证券存续状态：L上市，N未上市新证券，D退市
DB.Trade_status = w_wsd_data_1(:,2);%交易状态：交易，停牌一天，临时停牌等
DB.Pct_chg = w_wsd_data_1(:,3);%涨跌幅（未显示百分号）
DB.Open = w_wsd_data_0(:,1);%开
DB.High = w_wsd_data_0(:,2);%高
DB.Low = w_wsd_data_0(:,3);%低
DB.Close = w_wsd_data_0(:,4);%收
DB.Volume = w_wsd_data_0(:,5);%量
DB.NK = length(DB.Open);%行情数据量

% 数据清洗

%数据加载成功
flag=1;