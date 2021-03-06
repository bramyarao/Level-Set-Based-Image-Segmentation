function phi = reinitialize(phi,hx,hy,Lx,Ly)

dt = hx/10;
e = hx;
E  = 1000;
while E > dt*hx^2
    E =  0;
    for ii = 1:Lx
        for jj = 1:Ly        
            zz = phi(ii,jj);
            SS = zz/sqrt(zz^2 + e^2);
            
            
            ii_1 = ii - 1;
            jj_1 = jj - 1;
            iip1 = ii + 1;
            jjp1 = jj + 1;
            
            if ii_1 < 1; ii_1 = 1; end
            if iip1 > Lx; iip1 = Lx; end
            if jj_1 < 1; jj_1 = 1; end
            if jjp1 > Ly; jjp1 = Ly; end
            
            aa = (zz-phi(ii_1,jj))/hx;
            bb = (phi(iip1,jj)-zz)/hx;
            cc = (zz-phi(ii,jj_1))/hy;
            dd = (phi(ii,jjp1)-zz)/hy;
            if aa > 0
                aap = aa;
                aan = 0;
            else
                aap = 0;
                aan = aa;
            end

            if bb > 0
                bbp = bb;
                bbn = 0;
            else
                bbp = 0;
                bbn = bb;
            end

            if cc > 0
                ccp = cc;
                ccn = 0;
            else
                ccp = 0;
                ccn = cc;
            end
            if dd > 0
                ddp = dd;
                ddn = 0;
            else
                ddp = 0;
                ddn = dd;
            end

            if zz > 0
                GG = sqrt( max(aap^2, bbn^2) + max(ccp^2, ddn^2)) -1;
            elseif zz < 0
                GG = sqrt( max(aan^2, bbp^2) + max(ccn^2, ddp^2)) -1;
            else
                GG = 0;
            end
            
            phi(ii,jj) = phi(ii,jj) - dt*SS*GG;
            E = E + abs(dt*SS*GG);
        end
    end
end