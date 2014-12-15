function [tree averageMLength]=buildTunstallTree(root,q,p)
% Function: buildTunstallTree，创建Tunstall 树 (仅当D=2,K=2)
% Input: root  q( q steps) p(probability of one of the source lex) 
% Output: the built Tunstall tree; the average message length
%       输入 树根节点 建树步骤q 信源取1的概率p
%       输出 建好的树，平均编码长

%% @version 1.2 增加计算平均码值长的部分
%    @author RenaicC
%    @date 2014-10-23 22:53:21

%%
tree(1)=root;
select=1;
count=numel(tree); %    N = numel(A) returns the number of elements, Num, in array A(tree).

%% ----------------------Build the tree----------------------%
for ii=0:q
    maxPro=0;
    for k=1:count  % for: to select the maximum probability and its node (kk)
        if (tree(k).probability>maxPro)&&(tree(k).left==0)
            maxPro=tree(k).probability;
            select=k;
        end%end if
    end%end for
    % add the new tree to the chosen node
    tree(select).left=count+1;%left child
    tree(select).right=count+2;%right child
    tree(count+1).parent=select; %parent
    tree(count+2).parent=select;
    tree(count+1).level=tree(select).level+1; %level
    tree(count+2).level=tree(select).level+1;
    tree(count+1).probability=tree(select).probability*p;  %multiple by p(left child)
    tree(count+2).probability=tree(select).probability*(1-p);  %multiple by 1-p(right child)
    tree(count+1).val=-1;%val codeword 存放编码码字
    tree(count+1).label=-1;
    tree(count+2).val=-1;
    tree(count+2).label=-1;
    %create new  empty node    
    tree(count+1).left=0;
    tree(count+2).left=0;
    tree(count+1).right=0;
    tree(count+2).right=0;
    count=numel(tree);
end%end for
%% 为树上的叶子赋码字, 求平均码字长
%%---------give the codeword for the leaf and calculate the average message lenght------
averageMLength=0;
M=2*q+2;
cL=ceil(log2(M));%fixed length
%cL==N
jj=0;%由于是定长码字，将码字赋值为0~2^N-1即可
for k=1:count
%     disp(k);
%     disp(tree(k).level);
%     disp(tree(k).probability);
    if tree(k).left==0 %is leaf 为叶子赋值（即码字节点）
        tree(k).val=jj;
        jj=jj+1;
    else 
        averageMLength=averageMLength+tree(k).probability;%内结点的概率和即平均码字长
    end %end if
end%end for

