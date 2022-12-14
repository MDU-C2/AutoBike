clc, clear, close all

Titanic = importdata('C:\Users\wickt\Documents\Skola\DVA439 - Intelligenta System\assignment 1 titanic.dat');

%Input 
data = Titanic.data;
%result
T = 1 - (0.5 - 0.25*data(1:1500, 4));  %Dead=0.25, Survived=0.75
%Data
A=data(1:1500, 1:3);

%Sigmoid function
sig = @(x) 1./(1 + exp(-x)); 

%Traning factor
n = 0.01; 
%Itherations
iter = 1000; 



%Evaluation
Eval= data(1501:2200, 1:3);
%Result
Y=data(1501:2200, 4);
%Data
Y(Y==-1)=0; %Dead=0

%Initial delta
d1 = ones(1500, 3);
d2 = ones(1500, 1);

%Initial weigths
w1 = 2*rand(3, 3) - 1;
w2 = 2*rand(3, 1) - 1;

%Initial bias
bias1 = 2*rand(3,1) - 1;
bias2 = 2*rand(1) - 1;



i=0;
%Train ANN-----------------------------------------------------------------
while i <= iter
tosig1=A*w1;
tosig1(:,1)=tosig1(:,1)+bias1(1,1); %x1*w11+...+x3*w13+bias1
tosig1(:,2)=tosig1(:,2)+bias1(2,1); %x2*w21+...+x3*w33+bias2
tosig1(:,3)=tosig1(:,3)+bias1(3,1); %x3*w21+...+x3*w33+bias3

Out1=sig(tosig1); %Hidden layer output

tosig2=Out1*w2+bias2; %O1*w4+...+O3*w6+bias4
Out2=sig(tosig2); %Output layer output

%Backward propagation
d2=Out2.*(1 - Out2).*(T-Out2); %d2=O(1-O)(T-O)
d1=Out1.*(1 - Out1)*w2.*d2; %d1=O(1-O)w2*d2

%Weights delta
dw1=n*A'*d1; %dw1=n*x*d1
dw2=n*Out1'*d2; %dw2=n*O1*d2

%Bias delta
dbias1=n*d1'*ones(1500, 3); %dw1=n*1*d1
dbias2=n*d2'*ones(1500, 1); %dw2=n*1*d2

%Update weights
w1=w1+dw1;
w2=w2+dw2;

%Update bias
bias1=bias1+dbias1;
bias2=bias2+dbias2;

i=i+1;
end

%Run ANN-------------------------------------------------------------------
tosig1=Eval*w1;
tosig1(:,1)=tosig1(:,1)+bias1(1,1); %x1*w11+...+x3*w13+bias1
tosig1(:,2)=tosig1(:,2)+bias1(2,1); %x2*w21+...+x3*w33+bias2
tosig1(:,3)=tosig1(:,3)+bias1(3,1); %x3*w21+...+x3*w33+bias3
Out1=sig(tosig1); %Hidden layer output

tosig2=Out1*w2+bias2; %O1*w4+...+O3*w6+bias4
Out2=sig(tosig2);%Output layer output

%Stats ANN-----------------------------------------------------------------

%Strict values
out2=round(Out2); %(less than 0.5 = dead, greater than 0.5 = survived)

check=out2-Y;
check2=out2+Y;


dead0 = out2(out2 == 0); %dead
dead = size(dead0);
dead=dead(1);
alive0 = out2(out2 == 1);%alive
alive = size(alive0);
alive=alive(1);

percentsurvived=alive/700*100;

%Real stats
alive1 = Y(Y == 1);%alive
alive2 = size(alive1);
alive2=alive2(1);
dead1 = Y(Y == 0);%dead
dead2 = size(dead1);
dead2=dead2(1);

percentsurvived1=alive2/700*100;


checkcorrect = check(check == 0);
checkfault1 = check(check == 1);
checkfault2 = check(check == -1);

correct = size(checkcorrect);
correct=correct(1);
fault = size(checkfault1)+size(checkfault2);
fault=fault(1);

correctalive=check2(check2 == 2);
correctdead=check2(check2 == 0);
alive3=size(correctalive);
alive3=alive3(1);
dead3=size(correctdead);
dead3=dead3(1);
percentcorrectalive=alive3/alive2;
percentcorrectdead=dead3/dead2;

percent=correct/700;

fprintf('INPUT DATA\ndead : %i\nsurvived : %i\npercent survived : %.2f\n\nANN DATA\ndead : %i/490\nsurvived : %i/210\npercent survived : %.2f\n\nRESULTS\ntotal correct : %i\ntotal fault : %i\n\ncorrect dead : %i/490\ncorrect survived : %i/210\n\npercent correct survived : %.2f\npercent correct dead : %.2f\npercent correct : %.2f\n',dead2, alive2, percentsurvived1, dead, alive, percentsurvived, correct, fault, dead3, alive3, percentcorrectalive*100, percentcorrectdead*100, percent*100)


