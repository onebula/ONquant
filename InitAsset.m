function Asset = InitAsset(DB)
NT = DB.NK;

% 当前持仓量
Asset.CurrentPosition = 0;
Asset.CurrentStock = [];
% 成交量序列
Asset.Volume = cell(NT,1);
% 成交价序列
Asset.Price = cell(NT,1);
% 成交标的序列
Asset.DealStock = cell(NT,1);
% 持仓量序列
Asset.Position = cell(NT,1);
% 持仓标的序列
Asset.Stock = cell(NT,1);
% 可用现金序列
Asset.Cash = zeros(NT,1);
% 总资产序列
Asset.GrossAssets = zeros(NT,1);