function sucRate = BEC_Test( ep, er, n, cNum )
%% BEC信道编码性能测试 
% er BEC 随机擦除概率
% ep 典型集边界 
% cNum发送码字个数
% n col数  每个码字长为n
% 2014-12-02
% renaic@mai.ustc.edu.cn
R=1-er;
%C=1-er;
nRInt=ceil(n*R);
m=power(2,nRInt); % 2^nR 个码字
%% 计算接受序列的熵，联合熵及其典型集的上下界
Hy=-((1-er)*log2((1-er)/2)+er*log2(er));
HyU=Hy+ep; % 接收序列典型集的上下界
HyL=Hy-ep;
Hxy=-((1-er)*log2((1-er)/2)+er*log2(er/2));
HxyU=Hxy+ep; % 接收序列联合典型的上下界
HxyL=Hxy-ep;
xBook = random('Binomial',1,0.5,m,n); % 0-1  Bernoulli（1/2）码本
%% 发送多个码字，发送码字个数为cNum，且随机选取
wSeq=random('Discrete Uniform',m,1,cNum); 
wd=[]; % 发送序列
deCoded=[]; % 接受到的序列解码后的序列，出错时填-1
HyRcv=0; 
countSuc=0; % 正确解码个数
for i=1:cNum
    wd=[wd xBook(wSeq(i),:)];  % wd 发送序列
end
wdTrans=wd; % wdTrans 发送完成的序列
bitSent=length(wd);
for i=1:bitSent
    if (random('Binomial',1,er,1,1)==1) %擦除
        wdTrans(i)=-1;
    end
end

%% 解码: 分别计算接收序列是否典型，联合典型
for k=1:cNum %一共收到cNum个
    wdTrans1=wdTrans((k-1)*n+1:k*n); %取出各个码字 
    label=[]; %与码簿联合典型的标记
    for i=1:n % 计算接收序列的log(y^n)
        if(wdTrans1(i)==-1) %收到-1
            HyRcv=HyRcv+log2(er);
        else %收到0或者1
            HyRcv=HyRcv+log2((1-er)/2);
        end
    end
    HyRcv=-HyRcv/n; %接受序列的log(y^n) 
    
    xBookUni=unique(xBook,'rows');
    [mN, ~]=size(xBookUni); %比较时防止出现重复的行,导致解码是误判
    if(HyRcv>HyU || HyRcv<HyL) 
            display('接受到的序列不是典型序列');
            %display('解码失败！')
            deCoded=[deCoded -ones(1,n)]; %将解码失败的标记为-1
            continue; % 不是典型序列，不用计算是否联合典型
    end
    display('收到典型序列！');
    for j=1:mN %对每个码字一一比较
        HxyRcvJ=0; %log(x^n,y^n)
        wdT=xBookUni(j,:); % 第J个码字
        for i=1:n
            if(wdTrans1(i)~=wdT(i)) %收到-1,被擦除
                HxyRcvJ=HxyRcvJ+log2(er/2);
            else %收到0或者1，未被擦除
                HxyRcvJ=HxyRcvJ+log2((1-er)/2);
            end
        end
        HxyRcvJ=-HxyRcvJ/n;
        if(HxyRcvJ>=HxyL && HxyRcvJ<=HxyU)
            display('找到联合典型序列');
            display(k);
            display(HxyRcvJ)
            label=[label j]; %将是联合典型的脚码标记
            display(label);
        end
    end
    if(length(label)~=1)
        display('解码失败！') %不是存在且存在唯一一个下标
        deCoded=[deCoded -ones(1,n)]; %将解码失败的标记为-1
    else
        countSuc=countSuc+1;
        display('成功解出一个码字！');
        deCoded=[deCoded xBookUni(label(1),:)];
    end
end
display('解码成功率');
sucRate=countSuc/cNum;
display(sucRate);
end

