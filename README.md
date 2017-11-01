基于matlab的事件驱动回测框架

首先安装wind量化接口并注册账号，确认可在matlab中运行后可进行回测。

在Main.m中订阅股票池、指定回测开始结束日期和进行高级配置Options，运行Main.m得到策略回测结果。
资产相关信息保存在Asset变量里，可调用Summary(Asset,DB,Options)输出资金曲线等。
  Asset为数据结构体，字段包括时间轴Times、yymmdd格式时间轴TimesStr、初始现金InitCash
    当前持仓标的CurrentStock、当前持仓CurrentPosition、
    落单标的OrderStock、落单价格OrderPrice、落单量OrderVolume、
    成交标的DealStock、成交价格DealPrice、成交量DealVolume、手续费DealFee、
    持仓标的历史Stock、持仓历史Position、可用现金历史Cash、
    基准BenchmarkStock、基准收益率BenchmarkReturns、基准每日收益率BenchmarkDailyReturns、基准年化收益率BenchmarkAnnualReturns、
    总资产GrossAssets、仓位比例PositionsRatio、收益率Returns、每日收益率DailyReturns、年化收益率AnnualReturns、
    超额收益ExcessReturns、最大回撤MaxDrawdown、最大回撤左端点bar索引DrawdownTopInd、最大回撤右端点bar索引DrawdownBottomInd
    Alpha、Beta、Sharpe、Volatility

在Strategy.m中编写策略。根据当前拿到的数据DB生成信号Signal:
  DB为数据结构体，字段包括K线数据游标CurrentK、时间轴Times、yymmdd格式时间轴TimesStr、标的数据（如DB.SH600000）。
    标的数据由LoadData.m获取，目前包括行情数据、证券交易信息、证券基本信息。字段包括名称Code、基本信息Info、
      时间轴Times、yymmdd格式时间轴TimesStr、证券存续状态Sec_status、交易状态Trade_status、涨跌幅Pct_chg、
      开盘价Open、最高价High、最低价Low、收盘价Close、成交量Volume、行情数据量NK
  Signal为结构体数组，多次买卖操作按先后次序编号，字段包括下单量Volume、标的名称Stock、撮合方式Type。

20171030 update:
1. 更贴合实际的成交机制，包括引入滑点、佣金、印花税等
2. 加入交易失败的情况判断，包括未上市或退市、涨跌停、停牌等
3. 对交易失败的情况增加了自动延迟若干天落单的机制
4. 对成交量进行限制，包括整百买入、不得超过当日成交量的固定比例、剩余可用资金必须为正、是否开启做空模式
5. 进一步丰富了Summary模块的回测结果统计，例如最大回撤的计算和可视化
6. 引入策略自定义的全局变量Context，方便编写更复杂的策略和遍历自定义参数组合
7. 对策略每日允许调用的数据做了截断，避免了未来数据的使用

待引入T+0交易判断和更丰富的回测结果统计与分析

20171011 update:
目前支持多支股票的日线回测。待加入自定义全局变量、数据清洗、手续费、详细回测报告
