%use the principle component analysis (PCA) to do the affine registration
%of before image (orininal1.jpg) and after image (original2.jpg)

clear;close all;

o_name1='original1.jpg'; %the before image: original1.jpg
o_name2='original2.jpg'; %the after image: original2.jpg

s_name1='segment1.jpg'; %the segmentation result of original1.jpg
s_name2='segment2.jpg'; %the segmentation result of original2.jpg

o_im1=imread(o_name1);
o_im2=imread(o_name2);

im1=imread(s_name1);
im2=imread(s_name2);

im1=rgb2gray(im1);
im2=rgb2gray(im2);

im1=im2bw(im1,0.9);
im2=im2bw(im2,0.9);

%get the boundary
[bw1,L1]=bwboundaries(im1,'holes');
[bw2,L2]=bwboundaries(im2,'holes');

boundary1=bw1{1}; % the boundary of the before image
boundary2=bw2{1}; %the boundary of the after image

x1=boundary1(:,1);
y1=boundary1(:,2);
str=sprintf('mean1 is %5.2f,%5.2f',mean(x1),mean(y1));
disp(str)
cov1=getCov(boundary1,mean(boundary1,1));
disp('covariance')
disp(cov1)

x2=boundary2(:,1);
y2=boundary2(:,2);
str=sprintf('mean2 is %5.2f,%5.2f',mean(x2),mean(y2));
disp(str)
cov2=getCov(boundary2,mean(boundary2,1));
disp('covariane')
disp(cov2)

%show centered boundary1 and boundary2
disp_x1=x1-mean(x1);
disp_y1=y1-mean(y1);

disp_x2=x2-mean(x2);
disp_y2=y2-mean(y2);

figure,plot(disp_y1,disp_x1,'r-',disp_y2,disp_x2,'b-');
axis on;
axis ij;
%%
%calculate eigen value of boundary1
[eigV1,eigD1]=eig(cov1);

if eigD1(1,1)<eigD1(2,2)
    eigV1=[eigV1(:,2),eigV1(:,1)];
    eigD1=diag([eigD1(2,2),eigD1(1,1)]);
end

%calculate eigen value of boundary2
[eigV2,eigD2]=eig(cov2);

if eigD2(1,1)<eigD2(2,2)
    eigV2=[eigV2(:,2),eigV2(:,1)];
    eigD2=diag([eigD2(2,2),eigD2(1,1)]);
end

%%
%preform the affine transformation to register the before and after images
S=sqrt(eigD1)*inv(sqrt(eigD2));
disp2=eigV1*S*eigV2'*[x2';y2'];
b=[mean(x1);mean(y1)]-eigV1*S*eigV2'*[mean(x2);mean(y2)];
repb=repmat(b,[1,size(disp2,2)]);
disp2=disp2+repb;

%%
%show the registration result on a coordinate plane
figure
for i=1:length(bw1)
    curXY=bw1{i};
    curX=curXY(:,1);
    curY=curXY(:,2);
   hold on, plot(curX,curY,'r*');
end

for i=1:length(bw2)
    curXY=bw2{i};
    transformed=eigV1*S*eigV2'*curXY';
    repb=repmat(b,[1,size(curXY,1)]);
    transformed=transformed+repb;
    hold on, plot(transformed(1,:),transformed(2,:),'g*');
end
    
%%
%show the results of two registerred images
A=(eigV1*S*eigV2')';
A=[A(2,:);A(1,:)];
A=[A(:,2),A(:,1)];
B=b';
B=[B(2),B(1)];
t=maketform('affine',[A;B]);
bounds=findbounds(t,[1 1;size(o_im2,2) size(o_im2,1)]);
bounds(1,:)=[1 1];

[J1,xdata,ydata] = imtransform(o_im2,t,'XData',bounds(:,2)','YData',bounds(:,1)');
figure,imshow(J1,'XData',xdata,'YData',ydata);
for i=1:length(bw2)
    curXY=bw2{i};
    transformed=eigV1*S*eigV2'*curXY';
    repb=repmat(b,[1,size(curXY,1)]);
    transformed=transformed+repb;
    hold on, plot(transformed(2,:),transformed(1,:),'g-');
end
hold on,h=imshow(o_im1);
for i=1:length(bw1)
    curXY=bw1{i};
    curX=curXY(:,1);
    curY=curXY(:,2);
    hold on, plot(curY,curX,'r-');
end
set(h,'AlphaData',0.6);

    
    
    
    
    
    
    
    
    
    
    

