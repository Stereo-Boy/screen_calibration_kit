function sortie=fitparam(x,y,fig)
%fit  curve (less mean root square) in a form of power
%
if exist('fig','var')==0; fig=1; end
options = optimset('MaxFunEvals',5000);
%load screenparam
%x=[1:15:255];
%y=lum;
e=@(par) sum((par(1).*(x.^par(2)) - y).^2);
par(1)=1;
par(2)=1;
sortie=fminsearch(e, par,options);
figure(fig);hold on;plot(x,y,'ok'); plot(x,sortie(1).*(x.^sortie(2)),'r-');
