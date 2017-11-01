function Asset = InitAsset(DB,Options)
NT = DB.NK;
% 时间轴
Asset.Times = [];
% 当前持仓量
Asset.CurrentPosition = 0;
Asset.CurrentStock = [];
% 下单量序列
Asset.OrderVolume = cell(NT,1);
% 下单价序列
Asset.OrderPrice = cell(NT,1);
% 下单标的序列
Asset.OrderStock = cell(NT,1);
% 成交量序列
Asset.DealVolume = cell(NT,1);
% 成交价序列
Asset.DealPrice = cell(NT,1);
% 成交标的序列
Asset.DealStock = cell(NT,1);
% 成交手续费序列
Asset.DealFee = cell(NT,1);
% 持仓量序列
Asset.Position = cell(NT,1);
% 持仓标的序列
Asset.Stock = cell(NT,1);
% 可用现金序列
Asset.Cash = zeros(NT,1);
% 总资产序列
Asset.GrossAssets = zeros(NT,1);
% 初始资金量
Asset.InitCash = Options.InitCash;