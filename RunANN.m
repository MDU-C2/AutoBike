%Run ANN-------------------------------------------------------------------
toSig1=Eval*w1;
toSig1(:,1)=toSig1(:,1)+b1(1,1); %x1*w11+...+x3*w13+bias1
toSig1(:,2)=toSig1(:,2)+b1(2,1); %x2*w21+...+x3*w33+bias2
toSig1(:,3)=toSig1(:,3)+b1(3,1); %x3*w21+...+x3*w33+bias3
Out1=sig(toSig1); %Hidden layer output

toSig2=Out1*w2+b2; %O1*w4+...+O3*w6+bias4
Q = abs(toSig2);
%Q=sig(toSig2);%Output layer output