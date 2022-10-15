%初始化
LENGTH=2880;
WIDTH=1800;
[re,im]=meshgrid(linspace(-LENGTH/2,LENGTH/2,LENGTH),linspace(-WIDTH/2,WIDTH/2,WIDTH));%设置绘图范围、分辨率
Cmpx=re+im.*1j;                     %按设置的分辨路和范围生成复平面
root=[346,-173+300*1i,-173-300*1i]; %设置方程f的根（最好在绘图复平面范围内，不要太大也不要太小）
%root=[720+450i,720-450i,-720+450i,-720-450i];
f=poly(root);                       %通过根生成多项式函数
df=polyder(f);                      %对上面生成的多项式求一次导函数
itera=64;                           %设置迭代次数
%计算过程与数据整理
tic%开始计时
result=Cmpx-polyval(f,Cmpx)./polyval(df,Cmpx);%将复平面上所有的点带入牛顿迭代式x=x0-f(x0)/df(x0)，并迭代一定次数
for i=1:itera-1
    result=result-polyval(f,result)./polyval(df,result);
end
%计算迭代结束后复平面上各点的值与每个根的距离，将其分别存入distance矩阵的三个页中
distance=zeros(WIDTH,LENGTH,size(root,2));%生成用于储存平面上点与各根的距离的三维矩阵
for i=1:size(root,2)
    distance(:,:,i)=abs(result-root(i));%求平面上的点与第i个根的距离，存入第i页中
end
[dummy,PIC]=min(distance,[],3);%获取与每个点距离最近的根的序号（按页面维度取最小值）
toc%结束计时

%绘图
writemap=uint8([255,127,80;70,130,180;32,178,170]);%规定颜色映射（只有三个值，不规定的话会很难看清）
%writemap=uint8([255,127,80;70,130,180;32,178,170;128,128,128]);
colormap(writemap);
image(PIC);%显示图片
%colorbar;%显示颜色条
grid on;%显示坐标网格
axis equal;%xy等比例
%imwrite(PIC,writemap./255,'Newton_Fractal.png');%保存图片