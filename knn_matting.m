function [ curr_mask ] = knn_matting( curr_frame, curr_trimap )

lambda=100;
level=1;
im=double(curr_frame)/255;
tri = double(curr_trimap);
scrib=reshape(tri(:,:,1),[],1);
nn=[10;2];
[m, n, d]=size(im);
val=scrib>0.99;
map=(scrib<0.01)+val;
[a, b]=ind2sub([m n],1:m*n);
feature=[reshape(im,m*n,d)';[a;b]/sqrt(m*m+n*n)*level+rand(2,m*n)*1e-6];
now=0;
for i=1:size(nn,1)
    ind=vl_kdtreequery(vl_kdtreebuild(feature),feature,feature,'NUMNEIGHBORS',nn(i),'MAXNUMCOMPARISONS',nn(i)*2);
    a=reshape(repmat(uint32(1:m*n),nn(i),1),[],1);
    b=reshape(ind,[],1);
    row(now+1:now+m*n*nn(i),:)=[min(a,b) max(a,b)];
    feature(d+1:d+2,:)=feature(d+1:d+2,:)/100;
    now=now+m*n*nn(i);
end
value=max(1-sum(abs(feature(1:d+2,row(:,1))-feature(1:d+2,row(:,2))))/(d+2),0);
A=sparse(double(row(:,1)),double(row(:,2)),value,m*n,m*n);
A=A+A';
D=spdiags(sum(A,2),0,n*m,n*m);
M=D-A+lambda*spdiags(map,0,m*n,m*n);
L=ichol(M);
x=pcg(M,lambda*val,[],2000,L,L');
curr_mask = reshape(x,m,n);

end

