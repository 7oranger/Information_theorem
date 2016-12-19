%% BEC信道编码性能测试 
% er BEC 随机擦除概率
% ep 典型集边界 
% cNum发送码字个数
% n col数  每个码字长为n
% 2014-12-02
% renaic@mai.ustc.edu.cn
% 默认参数
ep=0.2;
er=0.01;
cNum=15;
n=10;
sucRates=[];
for i=5:15 % n变化 5~15
    sucRates(i-4) = BEC_Test( ep, er, i, cNum );
end
figure;
stem(5:15,sucRates);
title('n变化');
sucRates=[];
for i=1:8 % ep变化，0.1~0.8
    sucRates(i) = BEC_Test( i/10, er, n, cNum );
end
figure;
stem((1:8)/10,sucRates);
title('ep变化');
sucRates=[];
for i=1:8 % er变化，0.01~0.08
    sucRates(i) = BEC_Test( ep, i*0.01, n, cNum );
end
figure;
stem((1:8)/100,sucRates);
title('er变化');
sucRates=[];
for i=10:20 % cNum变化，10-20
    sucRates(i-9) = BEC_Test( ep, er, n, i );
end
figure;
stem(10:20,sucRates);
title('cNum变化');
