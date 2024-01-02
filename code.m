%loading the data-set
load data_country

%Feeling the data 
sz=size(Countrydata);
mn=min(Countrydata);
M=max(Countrydata);
R=M-mn;
STD=std(Countrydata);
means=mean(Countrydata);


%making the histograms
 
   figure(1)
   subplot(3,3,1), histogram(Countrydata(:,1)),title('Child mortality')
   subplot(3,3,2),histogram(Countrydata(:,2)), title('Exports')
   subplot(3,3,3), histogram(Countrydata(:,3)), title('Health')
   subplot(3,3,4), histogram(Countrydata(:,4)), title('Imports')
   subplot(3,3,5), histogram(Countrydata(:,5)), title('Income')
   subplot(3,3,6), histogram(Countrydata(:,6)), title('Inflation')
   subplot(3,3,7), histogram(Countrydata(:,7)), title('Life expectancy')
   subplot(3,3,8), histogram(Countrydata(:,8)), title('Total fertility')
   subplot(3,3,9), histogram(Countrydata(:,9)), title('Gdpp')
  

%computing the correlation coefficient of each pair of features
cor=corrcoef(Countrydata);

%standard score normalization
X=(Countrydata-ones(167,1)*means)./(ones(167,1)*STD);


%minmax feature scaling normalization [0,100]
X=(X-ones(167,1)*mn)./(ones(167,1)*(M-mn))*10;

%Calcaculating coefficient matrix 
co2=corrcoef(X);


%we drop columns 1,8,9 of the original matrix X because they have big correlation with others
X(:,1)=[];
X(:,7)=[];
X(:,7)=[];

% naming the columns in X
exports=X(:,1);
health=X(:,2);
imports=X(:,3);
income=X(:,4);
inflation=X(:,5);
life_epx=X(:,6);
X=X';


%Ploting column by column to get an idea about the shape of the clusters
figure(2)
subplot(2,2,1), scatter(health,exports,'r'), title ('health-exports')
subplot(2,2,2), scatter(health, imports,'y') , title('health-imports')
subplot(2,2,3), scatter(health,income,'m'), title('health-income')
subplot(2,2,4), scatter(health,inflation,'c'), title('health-inflation')

figure(3)
subplot(2,2,1),scatter3(health,income,inflation,'r'), title('health-income-inflation')
subplot(2,2,2),scatter3(health,income,exports,'k'), title('health-income-exports')
subplot(2,2,3),scatter3(health,income,imports,'m'), title('health-income-imports')
subplot(2,2,4),scatter3(health,income,income,'c'), title('health-income-income')



%ploting number of clusters-cost function versus number of clusters k for k-means
m=1;
j=ones(1,17);

%k-means 
while m<17
%we initialize theta using random points from our dataset
[l,N]=size(X);
theta_ini=zeros(l,m);
for i=1:m
i2=randi([1 N]);
theta_ini(:,i)=X(:,i2);
end
%running the k_means algorithm
[~,~,J]=k_means(X,theta_ini);
j(m)=J;
m=m+1;
end

num=2:16;
figure(4), plot(num,j(2:16),'g')
xlabel('Number of clusters')
ylabel('Cost Function')
grid on
title('k-means')

%k-means k=4
%we initialize theta using random points from our dataset
m=4;
[l,N]=size(X);
theta_ini=zeros(l,m);
for i=1:m
i2=randi([1 N]);
theta_ini(:,i)=X(:,i2);
end

%k-means for 6-dim vector 
[~,bel,J]=k_means(X,theta_ini);

%plotting the clusters

figure(5),
subplot(2,2,1),plot(X(1,bel==1),X(2,bel==1),'r.',...
X(1,bel==2),X(2,bel==2),'g*',X(1,bel==3),X(2,bel==3),'bo',...
X(1,bel==4),X(2,bel==4),'cx')
title('exports-health')
subplot(2,2,2),plot(X(1,bel==1),X(3,bel==1),'r.',...
X(3,bel==2),X(3,bel==2),'g*',X(1,bel==3),X(3,bel==3),'bo',...
X(1,bel==4),X(3,bel==4),'cx')
title('  exports-imports ')
subplot(2,2,3),plot(X(1,bel==1),X(4,bel==1),'r.',...
X(1,bel==2),X(4,bel==2),'g*',X(1,bel==3),X(4,bel==3),'bo',...
X(1,bel==4),X(4,bel==4),'cx')
title(' exports-income ')
subplot(2,2,4),plot(X(1,bel==1),X(6,bel==1),'r.',...
X(1,bel==2),X(6,bel==2),'g*',X(1,bel==3),X(6,bel==3),'bo',...
X(1,bel==4),X(6,bel==4),'cx')
title(' exports-life expectancy ')
sgtitle('Resulting clusters k=4')

%ploting the pdfs for the first dimension of the clusters
[f1,X1] = ksdensity(X(1,bel==1));
[f2,X2] = ksdensity(X(1,bel==2));
[f3,X3] = ksdensity(X(1,bel==3));
[f4,X4] = ksdensity(X(1,bel==4));

figure (6), hold on
figure (6), plot(X1,f1,'r'), plot(X2,f2,'g'), plot(X3,f3,'b'),plot(X4,f4,'--c');
 title('Exports pdfs k=4')
%ploting the pdfs for the all the dimensions of the clusters
figure(7)
subplot(2,3,1)
[f1,X1] = ksdensity(X(1,bel==1));
[f2,X2] = ksdensity(X(1,bel==2));
[f3,X3] = ksdensity(X(1,bel==3));
[f4,X4] = ksdensity(X(1,bel==4));
hold on
plot(X1,f1,'r'), plot(X2,f2,'g'), plot(X3,f3,'b'),plot(X4,f4,'--c')
title('Exports pdfs k=4')


subplot(2,3,2)
[f1,X1] = ksdensity(X(2,bel==1));
[f2,X2] = ksdensity(X(2,bel==2));
[f3,X3] = ksdensity(X(2,bel==3));
[f4,X4] = ksdensity(X(1,bel==4));
hold on
plot(X1,f1,'r'), plot(X2,f2,'g'), plot(X3,f3,'b'),plot(X4,f4,'--c')
title('Health pdfs k=4')



subplot(2,3,3)
[f1,X1] = ksdensity(X(3,bel==1));
[f2,X2] = ksdensity(X(3,bel==2));
[f3,X3] = ksdensity(X(3,bel==3));
[f4,X4] = ksdensity(X(1,bel==4));
hold on
plot(X1,f1,'r'), plot(X2,f2,'g'), plot(X3,f3,'b'),plot(X4,f4,'--c')
title('Imports pdfs k=4')

subplot(2,3,4)
[f1,X1] = ksdensity(X(4,bel==1));
[f2,X2] = ksdensity(X(4,bel==2));
[f3,X3] = ksdensity(X(4,bel==3));
[f4,X4] = ksdensity(X(1,bel==4));
hold on
plot(X1,f1,'r'), plot(X2,f2,'g'), plot(X3,f3,'b'),plot(X4,f4,'--c')
title('Income pdfs k=4')


subplot(2,3,5)
[f1,X1] = ksdensity(X(5,bel==1));
[f2,X2] = ksdensity(X(5,bel==2));
[f3,X3] = ksdensity(X(5,bel==3));
[f4,X4] = ksdensity(X(1,bel==4));
hold on
plot(X1,f1,'r'), plot(X2,f2,'g'), plot(X3,f3,'b'),plot(X4,f4,'--c')
title('Inflation pdfs k=4')

subplot(2,3,6)
[f1,X1] = ksdensity(X(6,bel==1));
[f2,X2] = ksdensity(X(6,bel==2));
[f3,X3] = ksdensity(X(6,bel==3));
hold on
plot(X1,f1,'r'), plot(X2,f2,'g'), plot(X3,f3,'b'),plot(X4,f4,'--c')
title('Life expectancy pdfs k=4')



%we run the k-means k=3
m=3;
%we initialize theta using random points from our dataset
[l,N]=size(X);
mn=min(X);
M=max(X);
theta_ini=zeros(l,m);
for i=1:m
i2=randi([1 N]);
theta_ini(:,i)=X(:,i2);
end
[theta,bel,J]=k_means(X,theta_ini);

%plotting the clusters
figure(8), 
subplot(2,2,1),plot(X(1,bel==1),X(2,bel==1),'r.',...
X(1,bel==2),X(2,bel==2),'g*',X(1,bel==3),X(2,bel==3),'bo',...
X(1,bel==4),X(2,bel==4),'cx')
title(' exports-health ')
subplot(2,2,2),plot(X(1,bel==1),X(3,bel==1),'r.',...
X(1,bel==2),X(3,bel==2),'g*',X(1,bel==3),X(3,bel==3),'bo',...
X(1,bel==4),X(3,bel==4),'cx')
title(' exports-imports ')
subplot(2,2,3),plot(X(1,bel==1),X(4,bel==1),'r.',...
X(1,bel==2),X(4,bel==2),'g*',X(1,bel==3),X(4,bel==3),'bo',...
X(1,bel==4),X(4,bel==4),'cx')
title(' exports-income')
subplot(2,2,4),plot(X(1,bel==1),X(6,bel==1),'r.',...
X(1,bel==2),X(6,bel==2),'g*',X(1,bel==3),X(6,bel==3),'bo',...
X(1,bel==4),X(6,bel==4),'cx')
title('exports-life expectancy k=3')
sgtitle('Resulting clusters k=3')

%ploting the pdfs for the first dimension of the clusters
[f1,X1] = ksdensity(X(1,bel==1));
[f2,X2] = ksdensity(X(1,bel==2));
[f3,X3] = ksdensity(X(1,bel==3));
figure(9), hold on
figure (9), plot(X1,f1,'r'), plot(X2,f2,'g'), plot(X3,f3,'b');
title('Exports pdfs k=3')




%Characterization of the clusters

M1=[mean(X(1,bel==1)) mean(X(2,bel==1)) mean(X(3,bel==1)) mean(X(4,bel==1)) mean(X(5,bel==1)) mean(X(6,bel==1))];

M2=[mean(X(1,bel==2)) mean(X(2,bel==2)) mean(X(3,bel==2)) mean(X(4,bel==2)) mean(X(5,bel==2)) mean(X(6,bel==2))];

M3=[mean(X(1,bel==3)) mean(X(2,bel==3)) mean(X(3,bel==3)) mean(X(4,bel==3)) mean(X(5,bel==3)) mean(X(6,bel==3))];


STD1=[std(X(1,bel==1)) std(X(2,bel==1)) std(X(3,bel==1)) std(X(4,bel==1)) std(X(5,bel==1)) std(X(6,bel==1))];

STD2=[std(X(1,bel==2)) std(X(2,bel==2)) std(X(3,bel==2)) std(X(4,bel==2)) std(X(5,bel==2)) std(X(6,bel==2))];

STD3=[std(X(1,bel==3)) std(X(2,bel==3)) std(X(3,bel==3)) std(X(4,bel==3)) std(X(5,bel==3)) std(X(6,bel==3))];


%ploting the pdfs for the all the dimensions of the clusters
figure(10)
subplot(2,3,1)
[f1,X1] = ksdensity(X(1,bel==1));
[f2,X2] = ksdensity(X(1,bel==2));
[f3,X3] = ksdensity(X(1,bel==3));
hold on
plot(X1,f1,'r'), plot(X2,f2,'g'), plot(X3,f3,'b')
title('Exports pdfs k=3')


subplot(2,3,2)
[f1,X1] = ksdensity(X(2,bel==1));
[f2,X2] = ksdensity(X(2,bel==2));
[f3,X3] = ksdensity(X(2,bel==3));
hold on
plot(X1,f1,'r'), plot(X2,f2,'g'), plot(X3,f3,'b')
title('Health pdfs k=3')



subplot(2,3,3)
[f1,X1] = ksdensity(X(3,bel==1));
[f2,X2] = ksdensity(X(3,bel==2));
[f3,X3] = ksdensity(X(3,bel==3));
hold on
plot(X1,f1,'r'), plot(X2,f2,'g'), plot(X3,f3,'b')
title('Imports pdfs k=3')

subplot(2,3,4)
[f1,X1] = ksdensity(X(4,bel==1));
[f2,X2] = ksdensity(X(4,bel==2));
[f3,X3] = ksdensity(X(4,bel==3));
hold on
plot(X1,f1,'r'), plot(X2,f2,'g'), plot(X3,f3,'b')
title('Income pdfs k=3')


subplot(2,3,5)
[f1,X1] = ksdensity(X(5,bel==1));
[f2,X2] = ksdensity(X(5,bel==2));
[f3,X3] = ksdensity(X(5,bel==3));
hold on
plot(X1,f1,'r'), plot(X2,f2,'g'), plot(X3,f3,'b')
title('Inflation pdfs k=3')

subplot(2,3,6)
[f1,X1] = ksdensity(X(6,bel==1));
[f2,X2] = ksdensity(X(6,bel==2));
[f3,X3] = ksdensity(X(6,bel==3));
hold on
plot(X1,f1,'r'), plot(X2,f2,'g'), plot(X3,f3,'b')
title('Life expectancy pdfs k=3')



