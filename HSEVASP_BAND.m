%Developed by Emad
clc
clear all
disp('This is to arange Band Structure raw data from VASP EIGENVAL')
%Open EIGENVAL file and see what numbers ranging like from 1 to what
l= input('please enter total number of points along one k vector');
fid=fopen('KPOINTS','r');
if fid == -1
    disp ('file name is wrong')
else
   a=textscan(fid,'%f %f %f %f', 'Headerlines',3);
end
fclose(fid)
b=0;
for v=1:size(a{1},1);
   if a{4}(v)~=0
       b=b+1;
   end
end
fid=fopen('EIGENVAL','r');
if fid == -1
    disp ('file name is wrong')
else
   t=textscan(fid,'%f %f %f %f %f', 'Headerlines',b*(l+2)+8);
end
fclose(fid)
fid=fopen('DOSCAR','r');
if fid == -1
    disp ('file name is wrong')
else
   f=textscan(fid,'%f %f %f %f %f','Headerlines',5);
end
fclose(fid)
soc=4;
spin_orbit=input('please type true if spin orbit coupling included in the calculations, otherwise type false');
if spin_orbit==1
    soc=4;
end
Ef=f{soc}(1,1); 
c= size(t,2);
d=size(t{1},1);
x=NaN(d,2);
z=size(x,1);
n=0;
Eshift=input('Energy shift')
    for j=1:z;
        if mod (j,(n+1)*l+n+1)~=0;
            x(j,1)=t{1} (j,1);
        else
            j=j+2;
            n=n+1;
        end
            if mod (j,l+1)~=0;
            x(j,2)=t{2} (j,1)-Ef-Eshift;
        else
            j=j+2;
            n=n+1;
    end
    end
        csvwrite('HSEcms.csv',x)
        m=size(x,1);
        y=NaN(m,2);
        k=(m+1)/(l+1);
        u=1;
        for p=1:m;
            for q=1:2;
                if mod (p,k+1)~=0
             y(p,q)=x((mod(p,k+1)-1)*(l+1)+u,q);
                    else
                    p=p+1;
                    u=u+1;
            end
            end
        end
        w=0;
       for p=1:m;
        if mod (p,k+1)~=0
             y(p,1)=w;
             w=w+0.01;
                    else
                    p=p+1;
                    w=0;
        end
       end
       min=m;
       if m>l*(k+1)
           min=l*(k+1);
       end
       s=zeros(min,2);
       for r=1:min
           for h=1:2;
           s(r,h)=y(r,h);
           end
       end
        csvwrite('HSEnoSOC.csv',s)
            
