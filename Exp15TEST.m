clc;
clear;
rand('state',1);
for T = 1:100000
    skeleton = zeros(3,3);
    skeleton(1,3)=1;
    skeleton(2,3)=1;
    n = 1000;
    alpha = 0.05;
    [skeleton, data] = Data_generator_double(1,skeleton,n);
    x = data(:,1);
    k = data(:,2);
    y = data(:,3);
    z = unidrnd(3,n,1)-1;
    x1 = zeros(n,1);
    x2 = zeros(n,1);
    M = perm_comb(3,2);
    M = M - 1;
    [h,s]=size(M);
    M = M(randperm(h),:);
    Div = perm_divi(h);
    for i = 1:3
        idx = find( x == i-1);
        L = length(idx);
        randM = unidrnd(Div(i),1,L);
        
        if i  == 1
            MT = M(1:Div(1),:);
        end
        if i == 2
            MT = M(Div(1)+1:Div(1)+Div(2),:);
        end
        if i == 3
            MT = M(Div(1)+Div(2)+1:Div(1)+Div(2)+Div(3),:);
        end
        MT;
        for j = 1:L
            x1(idx(j)) = MT(randM(j),1);
            x2(idx(j)) = MT(randM(j),2);
        end
    end
    [indx, gSquarex] = Independent_test(x, y, alpha);
    [indk, gSquarek] = Independent_test(k, y, alpha);
    [indz, gSquarez] = Independent_test(z, y, alpha);
    [ind1, gSquare1] = Independent_test(x1, y, alpha);
    [ind2, gSquare2] = Independent_test(x2, y, alpha);
    [ind1,gSquare1;ind2,gSquare2];
    if ind1+ind2 == 2 && gSquarex > 10 && gSquarek > 10 && indz == 1
        break;
    end
end
fprintf('1) Use CCI to find combined cause \n\n');
s1 = (z+1)*10+x1+1;
s2 = (x1+1)*10+x2+1;
s3 = (z+1)*100+(x1+1)*10+x2+1;
s4 = (x2+1)*1000+(z+1)*100+(x1+1)*10+k+1;
s5 = (k+1)*100+(x1+1)*10+x2+1;
resultM1 =  [ANMs(s1, y, alpha, 0),ANMs(y, s1, alpha, 0),MaxMI(s1,[x1,z],y)];
resultM2 =  [ANMs(s2, y, alpha, 0),ANMs(y, s2, alpha, 0),MaxMI(s2,[x1,x2],y)];
resultM3 =  [ANMs(s3, y, alpha, 0),ANMs(y, s3, alpha, 0),MaxMI(s3,[z,x1,x2],y)];
resultM4 =  [ANMs(s4, y, alpha, 0),ANMs(y, s4, alpha, 0),MaxMI(s4,[x1,x2,z,k],y)];
resultM5 =  [ANMs(s5, y, alpha, 0),ANMs(y, s5, alpha, 0),MaxMI(s5,[x1,x2,k],y)];
[resultM1;resultM2;resultM3;resultM4;resultM5]
value_residual1 = ANMs_residual([x1,x2], y, alpha, 0);
value_residual2 = ANMs_residual([x1], y, alpha, 0);
[value_residual1,value_residual2];
fprintf('Note that: the left term > 0.05 (threshold) and  the right term < 0.05 means X->Y, conversely Y<-X \n\n ');
fprintf('2) Use MHPC to find combined cause \n\n');
combined_cause_detected_By_MMHPC = MHPC(x,[k,y]);
if combined_cause_detected_By_MMHPC == true
    combined_cause_detected_By_MMHPC = 'x1x2'
else
    combined_cause_detected_By_MMHPC = []
end