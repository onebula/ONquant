% 基于K线的回测模板
%clear all
close all
clc
Options = 1;
Asset = Backtest(@Strategy,{'600000.SH','600001.SH'},'2014-12-01 09:00:00','2015-1-31 12:00:00',Options);

%%
% windcode={'600000.SH','300104.SZ','300372.SZ'};
% for i=1:size(windcode,2)
%     [DB]=LoadData(windcode{i},'2014-12-01 09:00:00','2017-10-10 12:00:00',Options);
%     DB.NK
% end