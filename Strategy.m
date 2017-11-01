% 最简单的双均线策略
function Signal = Strategy(DB,Context)
db=DB.SH600000;
Signal = [];
MA5 = MovAvg(db.Close,DB.CurrentK,Context.fast);  %5日均线
MA20 = MovAvg(db.Close,DB.CurrentK,Context.slow); %20日均线
if(MA5 > MA20) %5日均线上穿20日均线
    Signal{1}.Volume = 5000;
    Signal{1}.Stock = db.Code;
    Signal{1}.Type = 'TodayClose';
    Signal{2}.Volume = 5000;
    Signal{2}.Stock = '600300.SH';
    Signal{2}.Type = 'NextOpen';
elseif (MA5 < MA20) %5日均线下穿20日均线
    Signal{1}.Volume = -5000;
    Signal{1}.Stock = db.Code;
    Signal{1}.Type = 'NextOpen';
    Signal{2}.Volume = -5000;
    Signal{2}.Stock = '600300.SH';
    Signal{2}.Type = 'TodayClose';
end