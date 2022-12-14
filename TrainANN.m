
%Training data
trainData=Input(1:end, 1:5);
trainTarget=Input(1:end, 6);

%Sigmoid function
sig = @(X) 1./(1 + exp(-X));
%Traning factor
n = 0.01;
iterations = 500;

if firstTime == 0
    %Initial delta
    d1 = ones(1500, 3);
    d2 = ones(1500, 1);
    
    %Initial weigths
    w1 = 2*rand(5, 5) - 1;
    w2 = 2*rand(5, 1) - 1;
    
    %Initial bias
    b1 = 2*rand(5,1) - 1;
    b2 = 2*rand(1) - 1;
end
i=0;
%Train ANN-----------------------------------------------------------------
while i <= iterations
    
    toSig1=trainData*w1;
    toSig1(:,1)=toSig1(:,1)+b1(1,1); %x1*w11+...+x3*w13+bias1
    toSig1(:,2)=toSig1(:,2)+b1(2,1); %x2*w21+...+x3*w33+bias2
    toSig1(:,3)=toSig1(:,3)+b1(3,1); %x3*w21+...+x3*w33+bias3
    
    Out1=sig(toSig1); %Hidden layer output
    
    tosig2=Out1*w2+b2; %O1*w4+...+O3*w6+bias4
    Q=sig(tosig2); %Output layer output
    
    %Backward propagation
    d2=Q.*(1 - Q).*(trainTarget-Q); %d2=O(1-O)(T-O)
    d1=Out1.*(1 - Out1)*w2.*d2; %d1=O(1-O)w2*d2
    
    %Weights delta
    dw1=n*trainData'*d1; %dw1=n*x*d1
    dw2=n*Out1'*d2; %dw2=n*O1*d2
    
    %Bias delta
    dbias1=n*d1'*ones(max(size(d1)), 5); %dw1=n*1*d1
    dbias2=n*d2'*ones(max(size(d2)), 1); %dw2=n*1*d2
    
    %Update weights
    w1=w1+dw1;
    w2=w2+dw2;
    
    %Update bias
    b1=b1+dbias1;
    b2=b2+dbias2;
    
    i=i+1;
end
