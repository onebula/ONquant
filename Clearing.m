function Asset = Clearing(DB,Asset)
%当前K线位置
I = DB.CurrentK;
if(I == 1)
    Asset.CurrentStock = Asset.DealStock{I};
    Asset.CurrentPosition = Asset.Volume{I};
    Asset.Stock{I} = Asset.CurrentStock;
    Asset.Position{I} = Asset.CurrentPosition;
    Asset.Cash(I) = 1000000 - sum(Asset.Volume{I}.*Asset.Price{I});
else
    UnionStock= union(Asset.Stock{I-1},Asset.DealStock{I});
    Asset.CurrentStock = cell(1,length(UnionStock));
    Asset.CurrentPosition = zeros(1,length(UnionStock));
    for s=1:length(UnionStock)
        Asset.CurrentStock{s} = UnionStock{s};
        ind1=strcmp(UnionStock{s},Asset.Stock{I-1});
        ind2=strcmp(UnionStock{s},Asset.DealStock{I});
        if sum(ind1)>0 && sum(ind2)>0
            Asset.CurrentPosition(s) = sum(Asset.Position{I-1}(ind1)) + sum(Asset.Volume{I}(ind2));
        end
        if sum(ind1)>0 && sum(ind2)==0
            Asset.CurrentPosition(s) = sum(Asset.Position{I-1}(ind1));
        end
        if sum(ind1)==0 && sum(ind2)>0
            Asset.CurrentPosition(s) = sum(Asset.Volume{I}(ind2));
        end
    end
    Asset.Stock{I} = Asset.CurrentStock;
    Asset.Position{I} = Asset.CurrentPosition;
    Asset.Cash(I) = Asset.Cash(I-1) - sum(Asset.Volume{I}.*Asset.Price{I});
end