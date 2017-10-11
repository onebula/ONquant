% 最简单的双均线策略
function Signal = Strategy(DB)
db=DB.SH600000;
Signal = [];
MA5 = MovAvg(db.Close,DB.CurrentK,5);  %昨日 5日均线
MA20 = MovAvg(db.Close,DB.CurrentK,20); %昨日 20日均线
if(MA5 > MA20) %5日均线上穿20日均线 买
    Signal{1}.Direction = 'SELL';
    Signal{1}.Volume = 100;
    Signal{1}.Stock = db.Code;
    
    % Signal{2}.Direction = 'BUY';
    % Signal{2}.Volume = 100;
    % Signal{2}.Stock = '600000.SH';
elseif (MA5 < MA20) %5日均线下穿20日均线 卖
    Signal{1}.Direction = 'SELL';
    Signal{1}.Volume = 100;
    Signal{1}.Stock = db.Code;
    
    % Signal{2}.Direction = 'BUY';
    % Signal{2}.Volume = 100;
    % Signal{2}.Stock = '600000.SH';
end