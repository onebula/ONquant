function Asset = Summary(Asset,DB,Options)
%时间轴
Asset.Times = DB.Times;
Asset.TimesStr = DB.TimesStr;
%基准收益率
Asset.BenchmarkReturns = (DB.Benchmark - DB.Benchmark(1))/DB.Benchmark(1);
Asset.BenchmarkStock = DB.BenchmarkStock;
%基准每日收益率
Asset.BenchmarkDailyReturns = [0;(DB.Benchmark(2:end) - DB.Benchmark(1:end-1))./DB.Benchmark(1:end-1)];
%基准年化收益率
Asset.BenchmarkAnnualReturns = (1+Asset.BenchmarkReturns(end))^(250/DB.NK) - 1;
%总资产
Asset.GrossAssets = zeros(DB.NK,1);
for k=1:DB.NK
    Asset.GrossAssets(k) = Asset.Cash(k);
    for p=1:length(Asset.Position{k})
        Data = getfield(DB,[Asset.Stock{k}{p}(8:9) Asset.Stock{k}{p}(1:6)]);
        Asset.GrossAssets(k) = Asset.GrossAssets(k) + Asset.Position{k}(p)*Data.Close(k);
    end
end
%仓位比例
Asset.PositionsRatio = (Asset.GrossAssets - Asset.Cash)./Asset.GrossAssets;
%收益率
Asset.Returns = (Asset.GrossAssets - Asset.GrossAssets(1))/Asset.GrossAssets(1);
%年化收益率
Asset.AnnualReturns = (1+Asset.Returns(end))^(250/DB.NK) - 1;
%每日收益率
Asset.DailyReturns = [0;(Asset.GrossAssets(2:end)-Asset.GrossAssets(1:end-1))./Asset.GrossAssets(1:end-1)];
%超额收益
Asset.ExcessReturns = Asset.Returns - Asset.BenchmarkReturns;
%最大回撤
Drawdown = zeros(DB.NK,1);
DrawdownTopInd = zeros(DB.NK,1);
for k = 1:DB.NK
    [top DrawdownTopInd(k)] = max(Asset.GrossAssets(1:k));
    Drawdown(k) = (Asset.GrossAssets(k) - top)/top;
end
[Asset.MaxDrawdown Asset.DrawdownBottomInd] = min(Drawdown);%最大回撤，最大回撤区间右端点
Asset.DrawdownTopInd = DrawdownTopInd(Asset.DrawdownBottomInd);%最大回撤区间左端点
%Beta
Asset.Beta = cov(Asset.DailyReturns,Asset.BenchmarkDailyReturns);
Asset.Beta = Asset.Beta(1,2)/var(Asset.DailyReturns);
%Alpha
Asset.Alpha = Asset.AnnualReturns - Options.RiskFreeReturn - Asset.Beta * ( Asset.BenchmarkAnnualReturns - Options.RiskFreeReturn );
%Volatility
Asset.Volatility = std(Asset.DailyReturns) * sqrt(250);
%Sharpe
Asset.Sharpe = (Asset.AnnualReturns - Options.RiskFreeReturn) / Asset.Volatility;
%% plot
figure;
set(gcf,'position',[100 100 1000 500]);
% colnames = {'回测收益', '回测年化收益', '基准收益', '基准年化收益', 'Alpha', 'Beta', 'Sharpe', 'Volatility', '最大回撤'};
% t = uitable(gcf, 'Data', ...
%     [Asset.Returns(end) Asset.AnnualReturns Asset.BenchmarkReturns(end) Asset.BenchmarkAnnualReturns Asset.Alpha Asset.Beta Asset.Sharpe Asset.Volatility Asset.MaxDrawdown], ...
%     'ColumnName', colnames, 'Position', [20 20 960 50]);
subplot(2,1,1)
%总资产曲线
h1=plot(1:DB.NK,1+Asset.Returns,'b');
hold on
h2=plot(1:DB.NK,1+Asset.BenchmarkReturns,'r');
legend([h1 h2],{'User',Asset.BenchmarkStock},'location','northwest')
%最大回撤区间
plot(Asset.DrawdownTopInd,1+Asset.Returns(Asset.DrawdownTopInd),'r.','markersize',20);
plot(Asset.DrawdownBottomInd,1+Asset.Returns(Asset.DrawdownBottomInd),'r.','markersize',20);

title('总资产曲线')
xtick=get(gca,'xtick')+1;
xtick=xtick(xtick<=size(Asset.Times,1));
set(gca,'xtick',xtick,'xticklabel',datestr(Asset.Times(xtick),'yymmdd'));

subplot(2,1,2)
plot(1:DB.NK,100*Asset.PositionsRatio,'b.-')
title('仓位')
xtick=get(gca,'xtick')+1;
xtick=xtick(xtick<=size(Asset.Times,1));
set(gca,'xtick',xtick,'xticklabel',datestr(Asset.Times(xtick),'yymmdd'));

h=gca;
labels=get(h,'yticklabel'); % 获取Y轴
for i=1:size(labels,1)
   labels_modif2(i,:)=[labels(i,:) '%']; % 加上%符号
end
set(h,'yticklabel',labels_modif2); % Y轴变成百分制
%% Report
fprintf('=== 回测报告 ===\n')
fprintf('交易记录：\n')
TradeHis = cell(DB.NK,1);
for i=1:size(TradeHis,1)
    if ~isempty(Asset.DealStock{i})
        TradeHis{i} = Asset.TimesStr(i,:);
        for j=1:size(Asset.DealStock{i},2)
            TradeHis{i} = [TradeHis{i} ' // ' Asset.DealStock{i}{j} ' ' num2str(Asset.DealVolume{i}(j)) '@' num2str(Asset.DealPrice{i}(j)) ];
        end
        TradeHis{i} = [TradeHis{i} '\n'];
        fprintf(TradeHis{i})
    end
end
fprintf(['回测收益：    \t' num2str(Asset.Returns(end)) '\n'])
fprintf(['回测年化收益：\t' num2str(Asset.AnnualReturns) '\n'])
fprintf(['基准收益：    \t' num2str(Asset.BenchmarkReturns(end)) '\n'])
fprintf(['基准年化收益：\t' num2str(Asset.BenchmarkAnnualReturns) '\n'])
fprintf(['Alpha：      \t' num2str(Asset.Alpha) '\n'])
fprintf(['Beta：       \t' num2str(Asset.Beta) '\n'])
fprintf(['Sharpe：     \t' num2str(Asset.Sharpe) '\n'])
fprintf(['Volatility： \t' num2str(Asset.Volatility) '\n'])
fprintf(['最大回撤：   \t' num2str(Asset.MaxDrawdown) '\n'])