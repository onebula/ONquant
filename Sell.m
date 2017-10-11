function Asset = Sell(DB,Asset,Stock,volume,price,flag)
%当前K线位置
I = DB.CurrentK;
%标的
Asset.DealStock{I} = [Asset.DealStock{I},{Stock}];
%成交量， 买入为正
Asset.Volume{I} = [Asset.Volume{I} -volume];
%成交价
if(strcmp(flag,'CLOSE')==0)
    Data=getfield(DB,[Stock(8:9) Stock(1:6)]);
    Asset.Price{I} = [Asset.Price{I} Data.Close(I)]; %成交价 恒为正
else
    Asset.Price{I} = [Asset.Price{I} price];
end