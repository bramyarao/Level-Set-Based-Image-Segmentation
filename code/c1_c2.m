function [c1, c2] = c1_c2(imageinp, phi, e, hx, hy)
c1num = 0; c1den = 0; %c1num = c1 numerator, c1den = c1 denominator
c2num = 0; c2den = 0;
for ii = 1:size(imageinp,1)
    for jj = 1:size(imageinp,2)
        zz = phi(ii,jj);
        u0 = imageinp(ii,jj);
        Heav = 1/2*(1 + 2/pi*atan( zz /e ));
        c1num = c1num + u0*Heav*hx*hy;
        c1den = c1den + Heav*hx*hy;
        c2num = c2num + u0*(1-Heav)*hx*hy;
        c2den = c2den + (1-Heav)*hx*hy;
    end
end

c1 = c1num/c1den;
c2 = c2num/c2den;
        
        