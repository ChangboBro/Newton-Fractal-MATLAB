[re,im]=meshgrid(linspace(-1440,1440,2880),linspace(-900,900,1800)*1i);
%f=@(x) x.^3+213*x-41495434;
root=[346,-173+300*1i,-173-300*1i];%方程f的根
f=poly(root);
%df=@(x) 3*x.^2+213;
df=polyder(f);
itera=64;%迭代次数
%result=(re+im)-f(re+im)./df(re+im);
tic
result=(re+im)-polyval(f,(re+im))./polyval(df,(re+im));
for i=1:itera-1
    %result=result-f(result)./df(result);
    result=result-polyval(f,result)./polyval(df,result);
end
%计算迭代结束后复平面上各点与每个根的距离
distance=abs(result-root(1));
distance(:,:,2)=abs(result-root(2));
distance(:,:,3)=abs(result-root(3));
[dummy,PIC]=min(distance,[],3);%获取与每个点距离最近的根的序号
toc
%my color map
writemap=[32,178,170;70,130,180;255,127,80];
mymap=uint8(writemap);
image(PIC);
colormap(mymap)
%colorbar
axis equal
imwrite(PIC,writemap./255,'Newton_Fractal.png');