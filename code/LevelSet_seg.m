%=====================================================================
% Level Set image segmentation using Semi Implicit Finite Difference Method
%=====================================================================
clc
close all
%-----------------------------------------------------------------------              
% Input Parameters

e = 1;
totalStep = 80;
reinitial = 100001;
dt = 1;

mu = 100;
lamda = 1;
v = 0;

centerX = 200;
centerY = 120;
Rad_R = 40;


%=============== SELECTING THE IMAGE ==================

imageinpo = imread('level1.png');
%size(imageinpo)
imageinp = imageinpo(:,:,1);

%======================================
imageinp = double(transpose(imageinp)); 

%size(imageinp)
max_color = max(max(imageinp));
min_color = min(min(imageinp));
fprintf('min & max color [%d %d]\n',min_color,max_color)

figure(1) 
% imagesc again transposes
imagesc(transpose(imageinp))
colormap(gray)
axis on
axis equal
%colorbar
caxis([0 255])

%===================================================================

Lx = size(imageinp,1) ;
Ly = size(imageinp,2);

hx = 1; %between the nodes in the x-direction
hy = 1; %between the nodes in the y-direction
h=1;
xx = 1:Lx; %Discretisation in the x-direction
yy = 1:Ly; %Discretisation in the y-direction
%-----------------------------------------------------------------------

% PLOTTING THE INITIAL CIRCLE
phi = zeros(Lx,Ly); % Initial value of phi

for ii = 1:Lx
    for jj = 1:Ly
        phi(ii,jj) = -sqrt( (xx(ii)-centerX)^2 + (yy(jj)-centerY)^2 ) + Rad_R;        
    end
end
phio=phi;

figure(2)  
imagesc(transpose(imageinp))
colormap(gray)
hold on
% contour commond inverts the phi, so take transpose of phi
c100=contour(transpose(phi),[0,0],'y','LineWidth',2.5); 
hold off
title('Initial contour','FontSize',14)
axis on
axis equal
%colorbar
caxis([0 255])

% % %============================
% % [XXX, YYY] = ndgrid(1:Lx,1:Ly);
% % 
% % figure(5)
% % hold on
% % mesh(XXX,YYY,phi)
% % [C,h1]=contour(transpose(phi),[0,0],'k','LineWidth',2.5); 
% % hold off
% % % clabel(C,h1,'LabelSpacing',175)
% % % clabel(C,h1,'FontSize',16,'Color','k','Rotation',0)
% % % h1 = clabel(C,h1);
% % % set(h1,'BackgroundColor',[1 1 0])
% % % legend('zeroth level set')




% =============== NUMERICAL PROCEDURE ==================

for kk = 1:totalStep
    fprintf('Step # %d',kk);
    
    % Function to find the colors average
    [c1, c2] = c1_c2(imageinp, phi, e, hx, hy);
    
    % Re-initialising
    if mod(kk,reinitial) == 0
        phi = reinitialize(phi, hx, hy, Lx, Ly);        
        fprintf('ReInitialize');
    end
    
    % ==== Semi Implicit scheme for solving the Levelset equation ====
    phi_new = zeros(Lx,Ly)  ;   
    
    for ii = 1:Lx
        for jj = 1:Ly

            u0 = imageinp(ii,jj); 
            zz1 = phi(ii,jj);            
            delta1 = (1/pi)*(e/(1+zz1^2/e^2));            
            Heav1 = 1/2*(1 + 2/pi*atan( zz1 /e ));            
            
            % Image boundary point - just giving something
            if ii == 1 || ii == Lx || jj == 1 || jj == Ly
                phi_new(ii,jj) = phi(ii,jj)+ (dt*delta1)*lamda*((-(u0-c1)^2)+((u0-c2)^2));                             
                continue;
            end
            %-------------------
            % C1
            C1_d1 = (phi(ii+1,jj)- phi(ii,jj))/h;
            C1_d2 = (phi(ii,jj+1)- phi(ii,jj-1))/(2*h);
            C1 = 1/(sqrt(C1_d1^2+C1_d2^2));
            
            % C2
            C2_d1 = (phi(ii,jj)- phi(ii-1,jj))/h;
            C2_d2 = (phi(ii-1,jj+1)- phi(ii-1,jj-1))/(2*h);
            C2 = 1/(sqrt(C2_d1^2+C2_d2^2));
            
            % C3
            C3_d1 = (phi(ii+1,jj)- phi(ii-1,jj))/(2*h);
            C3_d2 = (phi(ii,jj+1)- phi(ii,jj))/h;
            C3 = 1/(sqrt(C3_d1^2+C3_d2^2));
            
            % C4
            C4_d1 = (phi(ii+1,jj-1)- phi(ii-1,jj-1))/(2*h);
            C4_d2 = (phi(ii,jj)- phi(ii,jj-1))/h;
            C4 = 1/(sqrt(C4_d1^2+C4_d2^2));
            
            m1 = (dt*mu*delta1)/h^2;
            C = 1 + m1*(C1+C2+C3+C4);
            
                    
            phi_new(ii,jj) = (1/C)*(phi(ii,jj)+ m1*( C1*phi(ii+1,jj) + C2*phi(ii-1,jj) + C3*phi(ii,jj+1) + C4*phi(ii,jj-1)) + (dt*delta1)*lamda*((-(u0-c1)^2)+((u0-c2)^2)));
                                       
        end
    end
    
    phi = phi_new;    

    imagetemp = imageinp;
    
    figure(3)
    imagesc(transpose(imagetemp))
    colormap(gray)
    hold on
    % contour commond inverts the phi, so take transpose of phi
    c1=contour(transpose(phi),[0,0],'r','LineWidth',2.5); 
    hold off
    title(sprintf('Level set contour: Step %d',kk))
    %title('Final Contour','FontSize',14)
    axis on
    axis equal      
    caxis([0 255])
    
    fprintf('\n');
end

figure(4); hold on
% Plots a contour of the points where phi=[0,0]
c = contour(transpose(phi),[0 0],'r','LineWidth',2.5) ;
% c is a 2 rows matrix
% xlim([0 100])
% ylim([0 100])
% Reversing the direction of the y-axis to match with the medical image
set(gca,'YDir','reverse')
colormap(hot)
axis equal
caxis([0 255])

%=================
figure(6)
hold on
imagesc(transpose(imageinp))
colormap(gray)
cc = contour(transpose(phio),[0 0],'w','LineWidth',2.5) ;
hold off
set(gca,'YDir','reverse')
% axis equal
axis off
caxis([0 255])

figure(7)
hold on
imagesc(transpose(imageinp))
colormap(gray)
ccc = contour(transpose(phi),[0 0],'w','LineWidth',2.5) ;
hold off
set(gca,'YDir','reverse')
% axis equal
axis off
caxis([0 255])

