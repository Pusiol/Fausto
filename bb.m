clear all;
tdf=8;
ldf=5;

apontador=1;
contadorderestricoes=zeros(1,tdf);
bandera=0;

load('problema.txt')
load('fob.txt')
load('rdi.txt')

t=size(problema);

xsupremo=zeros(1,t(2)-1);
fvalsupremo=0;

a=zeros(ldf,t(2)-1,tdf); %deveria ser dinãmico, mas...
b=zeros(ldf,1,tdf);

a0=problema(:,1:(t(2)-1));
b0=problema(:,t(2));

lb=zeros(1,t(2)-1);
ub=inf*ones(1,t(2)-1);

for j=1:tdf
if apontador<j
    disp('*********************')
    disp('A solução é:')
    disp(xsupremo)
    disp('O valor da fob é')
    disp(fvalsupremo)
    disp(sprintf('Foram resolvidos %d simplexes.',j))
    return;
end
[x fval l]=linprog(fob,[a0;a(1:contadorderestricoes(j),:,j)],[b0;b(1:contadorderestricoes(j),:,j)],[],[],lb,ub);
if l==-2 
    continue;
elseif fval>fvalsupremo
    continue;
else
        for i=1:t(2)-1
            if (rdi(i)==1)&&(        abs(  x(i)-round(x(i))  )  >0.000001        )
                apontador=apontador+1;contadorderestricoes(apontador)=contadorderestricoes(j)+1;
                if contadorderestricoes(apontador)>ldf
                    disp('Otimização não terminada, alocar mais memória (na variável ldf)')
                    return;
                end
                a(1:contadorderestricoes(j),1:(t(2)-1),apontador)=a(1:contadorderestricoes(j),1:(t(2)-1),j);
                b(1:contadorderestricoes(j),1,apontador)=b(1:contadorderestricoes(j),1,j);
                a(contadorderestricoes(apontador),i,apontador)=1;
                b(contadorderestricoes(apontador),1,apontador)=floor(x(i));
                
                apontador=apontador+1;contadorderestricoes(apontador)=contadorderestricoes(j)+1;
                a(1:(contadorderestricoes(apontador)-1),1:(t(2)-1),apontador)=a(1:contadorderestricoes(j),1:(t(2)-1),j);
                b(1:contadorderestricoes(j),1,apontador)=b(1:contadorderestricoes(j),1,j);
                a(contadorderestricoes(apontador),i,apontador)=-1;
                b(1:contadorderestricoes(apontador),1,apontador)=-1*(floor(x(i))+1);
                bandera=1;break;
            end
        end
        if bandera==1
            bandera=0;
            continue;
        end
        if fvalsupremo>fval
            xsupremo=x;
            fvalsupremo=fval;
        end
end 
end

disp('Otimização não terminada, alocar mais memória (na variável tdf)')