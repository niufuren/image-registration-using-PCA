function boundaryCov=getCov(curBoundary, curMean)
%get covariance matrix of the boundary, curBoundary is a N*2 matrix
%curMean is a 1*2 matrix. It is the mean value of curBoundary
n=size(curBoundary,1);
repMean=repmat(curMean,[n,1]);
curBoundary=curBoundary-repMean;
preMat=zeros(2,2);
for i=1:n
    curVect=curBoundary(i,:);
    curMat=curVect'*curVect;
    preMat=preMat+curMat;
end
    boundaryCov=preMat/n;