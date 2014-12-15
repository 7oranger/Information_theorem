%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: translate a string(for letters & numbers only) into Morse code
% and calculate its length  
% Input: a string(letters & numbers only)
% Output: coded string and its length(count by the number of dots )
% Date: 2014-09-18 23:37:03 Version 1
% Date: 2014-09-25 22:05:08 Version 2£¬revised the code refer to the definition 
% from http://en.wikipedia.org/wiki/Morse_code
% Comment: homework assignment 1 for Elements of Information Theory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
source=input('Please input your string(letter&number):','s');
coded=[];
sum=0;
spaceNum=1; % to cal the num of words
srcLexicon=['A':'Z','1':'9','0'];        %original lexicon,from A to Z and 0 to 9
morseTable={'.-','-...','-.-.','-..','.','..-.','--.','....','..','.---','-.-','.-..','--','-.','---','.--.','- -.-','.-.','...','-','..-','...-','.--','-..-','-.--','--..','.----','..---','...--','....-','.....','-... .','--...','---..','----.','-----'};        %corresponding morse code
disp('Now begin coding¡­¡­');       
%--------------------coding---------------------------------%
for count=1:length(source)
    if source(count)>='a' && source(count)<='z'        %donnot discriminate upper case or lower case
        source(count)=source(count)-32;                          %trans them to capital letters
    end
    index=find(srcLexicon==source(count));        %find index
    if isempty(index)        %empty(cannot find,suppose it is a space between two words,cost 7 dots)
        coded=[coded,'  '];        %append two spaces(one)
        spaceNum=spaceNum+1;
    else
        if count==length(source)
            coded=[coded,morseTable{index}]; % the end
        else
            coded=[coded,morseTable{index},' '];        %add a space(dot)
        end
    end
end
%--------------------cal length------------------------------
for k=1:length(coded)
    if coded(k)=='-'
        sum=sum+4;  % dash 
    else
        sum=sum+2;  % dot or space
    end
end
sum=sum-1;%the end do not need a dot

%---------------------display ans---------------------------
disp('Original string:');
disp(source);
fprintf('%d  words\n', spaceNum) ;
disp('Coded string:');
disp(coded);
fprintf('The length is %d(counted as dot) \n', sum) ;
       