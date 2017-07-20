clear;
clc;

%Import Data and get class lengths
TweetStruct = importdata('TwitterFinalData.csv');
TweetData = sortrows(TweetStruct.data, 1);
ClassLabels = TweetData(:,1);
nfeats = 10;
nclasses = 3; 
class_lens = zeros(nclasses, 1);
ind_lens = [0; zeros(nclasses ,1)];
for m = 1:nclasses
    class_lens(m) = sum(ClassLabels == m);
    ind_lens(m+1) = sum(class_lens);
end

%Feature Relationships Across Classes
    
Feats = {'SENTM', 'WC', 'PC', 'QC', 'EXC', 'TAGC', 'YR', 'M', 'D', 'TM'};
colorMat = ['r','g','b','m','c','y'];
    
%Basic Statistics for Twitter Data

TFeatMeans = mean(TweetData);
TFeatSTD = std(TweetData);
% 
%     %scatter sentiment vs wordcount
fig1 = scatterFeats(TweetData(:,2), TweetData(:,3), 3, ind_lens, Feats(1:2));
title('Sentiment v Wordcount')
% 
%     %scatter time vs num tags
% fig2 = scatterFeats(TweetData(:,11), TweetData(:,7), 3, ind_lens, [Feats(10), Feats(6)]);
% 
%     %histogram over time
% fig3 = histoClasses(TweetData(:,11), 3, ind_lens, 12);
% 
%     %Plot Matrix of Feature Relationships
% %fig4 = plotMatrixData(TweetData(:,2:11), 3, ind_lens, 10, Feats); %full Data

    %Eliminate Class Labels and low value features QMarks, Month and Year
Feats_Rev1 = [Feats(1:3), Feats(5:6) , Feats(9:10)];
TweetData_Rev1 = [TweetData(:, 2:4), TweetData(:, 6:7) , TweetData(:, 10:11)];
fig5 = plotMatrixData(TweetData_Rev1, 3, ind_lens, 7, Feats_Rev1);
nfeats = nfeats - 3;
TFeatMeans_Rev1 = mean(TweetData_Rev1);
TFeatSTD_Rev1 = std(TweetData_Rev1);
% 
% %Principal Component Analysis
%     
% 
    %Mean Normalization
TWDsize = size(TweetData_Rev1);
TweetDataMN = zeros(size(TweetData_Rev1));
for i = 1:TWDsize(1)
    for j = 1:TWDsize(2)
        TweetDataMN(i, j) = (TFeatMeans_Rev1(j) - TweetData_Rev1(i, j)) / TFeatSTD_Rev1(j);
    end
end

    %Get Matrix Decomposition
[U , S , V] = svd(TweetDataMN, 0);
Ur = U * S;
% 
%     %Scree Plot
[fig6, weights, cum] = scree(S, 'Twitter Data Scree Plot');

    %Loading Vectors
fig7 = PCAbars(V);

    %ScatterPlots comparing original and PCA features
fig8_1 = scatterClasses(Ur, TweetDataMN, nclasses, ind_lens, [1,2,3], Feats_Rev1);
fig8_2 = scatterClasses(Ur, TweetDataMN, nclasses, ind_lens, [2,3,4], Feats_Rev1);


%Classifying Density Distribution of Features with Parzen Window
% fig9 = figure;
% x = -3:.01:3;
% m = 1;
% n = nfeats;
% hold on;
% for i = 1:n  
%     subplot(ceil(n/2),ceil(n/2),m);
%     hold on;
%     for j = 2:(nclasses+1)
%         plot(x, parzen_window_gaussian(TweetDataMN((ind_lens(j-1)+1):ind_lens(j),i), .5, x),colorMat(j-1));
%         title(Feats_Rev1(i));
%     end
%     hold off;
%     m = m + 2;  
% end
% hold off;
    
% % Set up Training and Testing Data
% %     For Use with Training on Full Dataset
m1 = class_lens(1); 
m2 = class_lens(2);
m3 = class_lens(3);
TrainClasses = [ClassLabels(1:m1) ; ClassLabels(m1+1:m1+m2) ; ClassLabels(m1+m2+1:m1+m2+m3) ];
TrainMatrix = [TweetData_Rev1(1:m1, :) ; TweetData_Rev1(m1+1:m1 + m2, :) ; TweetData_Rev1(m1+m2+1:m1+m2+m3, :) ];
TestClasses = [ClassLabels(m+1:ind_lens(2)) ; ClassLabels(ind_lens(2)+m+1:ind_lens(3)) ; ClassLabels(ind_lens(3)+m+1:ind_lens(4)) ];
TestMatrix = [TweetData_Rev1(m+1:ind_lens(2),:) ; TweetData_Rev1(ind_lens(2)+m+1:ind_lens(3), :) ; TweetData_Rev1(ind_lens(3)+m+1:ind_lens(4), :) ];
TrainMatrixPCA = [Ur(1:m1, :) ; Ur(m1+1:m1+m2, :) ; Ur(m1+m2+1:m1+m2+m3, :) ];
TestMatrixPCA = [Ur(m+1:ind_lens(2),:) ; Ur(ind_lens(2)+m+1:ind_lens(3), :) ; Ur(ind_lens(3)+m+1:ind_lens(4), :) ];


%   %For Use With Seperate Training and Testing Classes
% m = 8; %m < 12
% TrainClasses = [ClassLabels(1:m) ; ClassLabels(ind_lens(2)+1:ind_lens(2)+m) ; ClassLabels(ind_lens(3) + 1:ind_lens(3) + m) ];
% TrainMatrix = [TweetData_Rev1(1:m, :) ; TweetData_Rev1(ind_lens(2)+1:ind_lens(2)+m, :) ; TweetData_Rev1(ind_lens(3) + 1:ind_lens(3) + m, :) ];
% TestClasses = [ClassLabels(m+1:ind_lens(2)) ; ClassLabels(ind_lens(2)+m+1:ind_lens(3)) ; ClassLabels(ind_lens(3)+m+1:ind_lens(4)) ];
% TestMatrix = [TweetData_Rev1(m+1:ind_lens(2),:) ; TweetData_Rev1(ind_lens(2)+m+1:ind_lens(3), :) ; TweetData_Rev1(ind_lens(3)+m+1:ind_lens(4), :) ];
% TrainMatrixPCA = [Ur(1:m, :) ; Ur(ind_lens(2)+1:ind_lens(2)+m, :) ; Ur(ind_lens(3) + 1:ind_lens(3) + m, :) ];
% TestMatrixPCA = [Ur(m+1:ind_lens(2),:) ; Ur(ind_lens(2)+m+1:ind_lens(3), :) ; Ur(ind_lens(3)+m+1:ind_lens(4), :) ];

n = length(TestMatrix(:,1));

%Quadratic Discriminant Performance (linear, case 1)
    %With Original Data Set
quad_classifier1 = fitcdiscr(TrainMatrix, TrainClasses, 'DiscrimType', 'quadratic');
[Label1, Score1, Cost1] = predict(quad_classifier1, TestMatrix);
Accuracy_qc1 = sum(Label1 == TestClasses)/n;

fig10 = figure;
hold on;
qcS2 = scatter(0:n+1, [0; TestClasses; 4]);
qcS1 = scatter(0:n+1, [0; Label1; 4]);
title('Quadratic Discriminant Classification on Twitter Data');
xlabel('sample');
ylabel('classification');
hold off;

Score_Reduced = zeros(n, 1);
for i = 1:n
    Score_Reduced(i) = Score1(i, TestClasses(i));
end
fig10_1 = figure;
scores = bar([Score1,Score_Reduced]);
title('Scores for Labels with Quad Classifier')
xlabel('sample');
ylabel('est. correct');

    %With PCA Data Set
quad_classifier2 = fitcdiscr(TrainMatrixPCA, TrainClasses, 'DiscrimType', 'quadratic');
[Label2, Score2, Cost2] = predict(quad_classifier2, TestMatrixPCA);
Accuracy_qc2 = sum(Label2 == TestClasses)/n;

fig11 = figure;
hold on;
qcS4 = scatter(0:n+1, [0; TestClasses; 4]);
qcS3 = scatter(0:n+1, [0; Label2; 4]);
title('Quadratic Discriminant Classification on Primary Components');
xlabel('sample');
ylabel('classification');
hold off;

%SVM Classifier
    %Training with original dataset
k12 = find(TrainClasses == 1 | TrainClasses == 2);
k23 = find(TrainClasses == 2 | TrainClasses == 3);
k13 = find(TrainClasses == 1 | TrainClasses == 3);
svm_classifier12 = svmtrain(TrainMatrix(k12,:), TrainClasses(k12), 'kernel_function', 'quadratic');
svm_classifier23 = svmtrain(TrainMatrix(k23,:), TrainClasses(k23), 'kernel_function', 'quadratic');
svm_classifier13 = svmtrain(TrainMatrix(k13,:), TrainClasses(k13), 'kernel_function', 'quadratic');
l12 = find(TestClasses == 1 | TestClasses == 2);
l23 = find(TestClasses == 2 | TestClasses == 3);
l13 = find(TestClasses == 1 | TestClasses == 3);
group12 = svmclassify(svm_classifier12, TestMatrix(l12, :));
Accuracy12 = sum(group12 == TestClasses(l12))/length(group12);
group23 = svmclassify(svm_classifier23, TestMatrix(l23, :));
Accuracy23 = sum(group23 == TestClasses(l23))/length(group23);
group13 = svmclassify(svm_classifier13, TestMatrix(l13, :));
Accuracy13 = sum(group13 == TestClasses(l13))/length(group13);
fig12 = figure;
subplot(1,3,1);
hold on;
stem(1:length(l12), TestClasses(l12), 'Marker', '+');
stem(1:length(l12), group12);
title('SVM Classes 1 & 2');
hold off;
subplot(1,3,2);
hold on;
stem(1:length(l23), TestClasses(l23), 'Marker', '+');
stem(1:length(l23), group23);
title('SVM Classes 2 & 3');
hold off;
subplot(1,3,3);
hold on;
stem(1:length(l13), TestClasses(l13), 'Marker', '+');
stem(1:length(l13), group13);
title('SVM Classes 1 & 3');
hold off;

    %Training with PC Dataset
svm_PCA_classifier12 = fitcsvm(TrainMatrixPCA(k12,:), TrainClasses(k12), 'KernelFunction', 'linear');
svm_PCA_classifier23 = svmtrain(TrainMatrixPCA(k23,:), TrainClasses(k23), 'kernel_function', 'quadratic');
svm_PCA_classifier13 = svmtrain(TrainMatrixPCA(k13,:), TrainClasses(k13), 'kernel_function', 'quadratic');
group12_PCA = predict(svm_PCA_classifier12, TestMatrixPCA(l12, :));
Accuracy12_PCA = sum(group12_PCA == TestClasses(l12))/ length(group12_PCA);
group23_PCA = svmclassify(svm_PCA_classifier23, TestMatrixPCA(l23, :));
Accuracy23_PCA = sum(group23_PCA == TestClasses(l23))/ length(group23_PCA);
group13_PCA = svmclassify(svm_PCA_classifier13, TestMatrixPCA(l13, :));
Accuracy13_PCA = sum(group13_PCA == TestClasses(l13))/ length(group13_PCA);
fig12 = figure;
subplot(1,3,1);
hold on;
stem(1:length(l12), TestClasses(l12), 'Marker', '+');
stem(1:length(l12), group12_PCA);
title('SVM PC Data Classes 1 & 2');
hold off;
subplot(1,3,2);
hold on;
stem(1:length(l23), TestClasses(l23), 'Marker', '+');
stem(1:length(l23), group23_PCA);
title('SVM PC Data Classes 2 & 3');
hold off;
subplot(1,3,3);
hold on;
stem(1:length(l13), TestClasses(l13), 'Marker', '+');
stem(1:length(l13), group13_PCA);
title('SVM PC Data Classes 1 & 3');
hold off;

performance = [Accuracy_qc1, Accuracy_qc2, 0; Accuracy12,Accuracy23,Accuracy13; Accuracy12_PCA, Accuracy23_PCA, Accuracy13_PCA]
