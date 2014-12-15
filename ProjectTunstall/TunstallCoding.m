%%m script

%%信息论基础编程作业——Tunstall编解码(仅当D=2,K=2,N可任取)
%  步骤
%  0 生成随机01序列
%  1 创建Tunstall树
%  2&3 创建词典Lexicon&编码
%  4 解码
%  5 输出结果

%% @version 1.2 增加解码结果与输入序列的对比
%    @author RenaicC
%    @date 2014-10-23 23:04:04

%%
clc;
close all;
clear all;

%% --------------PART0: 生成01随机序列-----------------
%基本信息
N=4;  % block length，可以修改
D=2;  % D-ary code
K=2;  % K source lex
p=0.6; % P(x=1)=0.6,P(x=0)=0.4,可以修改
q=floor((D^N-K)/(K-1)); % number of steps of building the Tunstall tree ，
M=K+q*(K-1); 

seqLength=1000; %length of the source
ran=random('unid',1000,[1,seqLength]);
source=floor(mod(ran,10)/(10*(1-p))); % 0 1 sequence,P(x=1)=0.6,P(x=0)=0.4
in=find(source>1);
source(in)=1;
per=sum(source)/seqLength;%仅仅用来验证1的概率是否是p附近
%source=[0 0 0 1 1 1 1 1 1 1 1 0 1 0 1 1 1 1 0 0 0 0 0 1  1 1];%for debug

%% ---------------PART1: 创建Tunstall树 -----------------
%创建树根
root.left=0; %root
root.right=0;
root.parent=0;
root.probability=1;
root.level=0;
root.val=-1;
root.label=-1;
%调用buildTunstallTree创建树，并求得平均编码长度
[TunstallTree averageMLength]=buildTunstallTree(root,q,p);

%% -----------------PART2&3: 编码&创建字典-----------------
cL=ceil(log2(M));% here N==cL
lexicon=cell(1,2^cL);%创建字典
coded=[];%编码后的序列(十进制)
codedBinary=[];%编码后的序列(二进制)
lexSrc=[];%记录从树根到叶子的路径
index=1;
for t=1:length(source) 
    if source(t)==1  % source==1
        index=TunstallTree(index).left;
        lexSrc=[lexSrc '1'];
    else %soutce==0
        index=TunstallTree(index).right;
        lexSrc=[lexSrc '0'];
    end
    if TunstallTree(index).left==0%成功抵达一个叶子,成功找到
        %将叶子上的码字从十进制转换为二进制
        s=num2str(TunstallTree(index).val);
        sn=dec2bin(TunstallTree(index).val,cL);
        %st=mat2str(sn);
        %codedBinary=strcat(codedBinary,sn);
        codedBinary=[codedBinary sn];
        coded=[coded s];
        %display(TunstallTree(index).val+1);
        if(  TunstallTree(index).label==-1) % add to the lexicon
            lexicon{1,TunstallTree(index).val+1}=lexSrc;%value(0~2^cL-1)
        end
        lexSrc=[];%路径清零，从新开始
        TunstallTree(index).label=1;
        index=1;%return to the root
    end
end

%解码
%字典 lexicon
%输入 lexicon  codedBinary 
%输出 deSource
%% -----------------------PART4: 解码---------------------
ncodedBinary=codedBinary-'0';%转换为double类型
deSource=[];
for nn=1:length(ncodedBinary)/cL
     cw=ncodedBinary(cL*nn-cL+1:nn*cL);
     cwDec=0;
     for mm=1:cL
         cwDec=cwDec+cw(mm)*2^(cL-mm);
     end
     deSource=[deSource lexicon{1,cwDec+1}];%在字典中对应位置找到源信息
end

%% -----------PART5: Display the result---------
oriStr=num2str(source);
oriStr(oriStr==' ') = '';
display('源序列');
display(oriStr);
display('编码后');
display(codedBinary);
display('解码后');
display(deSource);
display('字典');
display(lexicon);
display('平均码字长');
display(averageMLength);
display('N/E(L)');
R=N/averageMLength;
display(R);