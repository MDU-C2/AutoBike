function [variance_diff variance_real variance_estimated Mean_diff Mean_real Mean_estimated, real_value, estimated_value] = variance_calculator(real,estimated)
% function to evaluate mean and variance of measurement, estimation, and the
% difference between them. the code will understand itself if the data
% comes from GPS or not. The imput must be
f= size(real);
flag=f(2);
F=0;
estimated_value=[];
real_value=[];
if(flag==3)
    index=unique(real(:,3));
else index=real;
end
    if F==0
        for i = 1:size(index)
            if(flag==3)
                time_index(i,1)=find((real(:,3)==index(i)),1,'last');
            else 
                time_index(i,1)=i;
            end
                if isempty(find(estimated(:,1)==round(real(time_index(i,1),1),2)))
                    F=1;
                else
                    real_value(i,1)=real(time_index(i),2);
                    estimated_time_index(i,1)=find(estimated(:,1)==round(real(time_index(i,1),1),2,'decimal'));
                    estimated_value(i,1)=estimated(estimated_time_index(i),2);
                end
        end
    end
    N=size(estimated_value);
    diff=real_value-estimated_value;
    Mean_diff=mean(diff);
    Mean_estimated=mean(estimated_value);
    Mean_real=mean(real_value);
    variance_diff=(1/N(1))*sum((Mean_diff-diff).^2);
    variance_estimated=(1/N(1))*sum((Mean_estimated-estimated_value).^2);
    variance_real=(1/N(1))*sum((Mean_real-real_value).^2);

end