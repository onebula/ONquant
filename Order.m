function Asset = Order(DB,Asset,stock,volume,type,Options)
I = DB.CurrentK;
if strcmp(type,'TodayClose')==1
    OrderDay = 0;
elseif strcmp(type, 'NextOpen')==1
    if I+1<=DB.NK
        OrderDay = 1;
    else
        return;
    end
end
if volume > 0
    ordertype = '买入';
else
    ordertype = '卖出';
end
flag = 0;
Data=getfield(DB,[stock(8:9) stock(1:6)]);
for k=0:Options.DelayDays % 交易失败则延迟交易
    if I+OrderDay+k <= DB.NK
        cond(1) = strcmp(Data.Sec_status{I+OrderDay+k},'L')==1;
        cond(2) = strcmp(Data.Trade_status{I+OrderDay+k},'交易')==1;
        cond(3) = -9.9<=Data.Pct_chg{I+OrderDay+k};
        cond(4) = Data.Pct_chg{I+OrderDay+k}<=9.9;
        if cond(1) && cond(2) && cond(3) && cond(4)
            flag = 1;
            break;
        else
            if cond(1)==0
                reason = '未上市或退市';
            end
            if cond(2)==0
                reason = '停牌';
            end
            if cond(3)==0
                reason = '跌停';
            end
            if cond(4)==0
                reason = '涨停';
            end
            disp(['Bar' num2str(I) '@' DB.TimesStr(I+OrderDay,:) ' Message: ' stock reason '导致交易失败，尝试延迟' num2str(k+1) '天' ordertype]);
        end
    else
        return
    end
end
if flag == 1
    OrderDay = OrderDay + k;
    if I+OrderDay <= DB.NK
        Asset.OrderStock{I+OrderDay} = [Asset.OrderStock{I+OrderDay},{stock}];
        Asset.OrderPrice{I+OrderDay} = [Asset.OrderPrice{I+OrderDay} Data.Close(I+OrderDay)];
        Asset.OrderVolume{I+OrderDay} = [Asset.OrderVolume{I+OrderDay} volume];
    end
end