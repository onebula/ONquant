function Asset = Summary(DB,Asset)
Asset.GrossAssets = zeros(DB.NK,1);
for k=1:DB.NK
    Asset.GrossAssets(k) = Asset.Cash(k);
    for p=1:length(Asset.Position{k})
        Data = getfield(DB,[Asset.Stock{k}{p}(8:9) Asset.Stock{k}{p}(1:6)]);
        Asset.GrossAssets(k) = Asset.GrossAssets(k) + Asset.Position{k}(p)*Data.Close(k);
    end
end
figure;
plot(Asset.GrossAssets);
title('总资产曲线（初始为100W）')
xtick=get(gca,'xtick')+1;
xtick=xtick(xtick<=size(DB.Times,1));
set(gca,'xtick',xtick,'xticklabel',datestr(DB.Times(xtick),'yymmdd'));