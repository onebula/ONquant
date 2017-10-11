# ONquant
基于Matlab的事件驱动量化回测框架

在Main.m中订阅股票池，运行Main.m得到策略回测结果。在Strategy.m中编写策略。根据当前拿到的数据DB生成信号Signal:
  DB为数据结构体，字段包括K线数据游标CurrentK、时间轴Times、yymmdd格式时间轴TimesStr、标的数据（如DB.SH600000）。
    标的数据由LoadData.m获取，目前包括行情数据、证券交易信息、证券基本信息。字段包括名称Code、基本信息Info、
      时间轴Times、yymmdd格式时间轴TimesStr、证券存续状态Sec_status、交易状态Trade_status、涨跌幅Pct_chg、
      开盘价Open、最高价High、最低价Low、收盘价Close、成交量Volume、行情数据量NK
  Signal为结构体数组，多次买卖操作按先后次序编号，字段包括方向Direction、下单量Volume、标的名称Stock。

20171011 update:
目前支持多支股票的日线回测。待加入自定义全局变量、数据清洗、手续费、详细回测报告
