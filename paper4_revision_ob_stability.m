clear all;
%% check stability and observability
load('Data8_for_revise_matrixrecorded.mat');
MaxEig=[];
MinEig=[];
CARank=[];
for i=1:306 % number of control intervals
    eigvals=eig(data{3}.Values.A.Data(:,:,i));
    MaxEig=[MaxEig,max(eigvals)];
    MinEig=[MinEig,min(eigvals)];
    if max(eigvals)>=1
        display([num2str(i),': openloop system unstable']);
    end
    for j=1:55
        CARank(i,j)=rank([(data{3}.Values.C.Data(:,:,i)'),data{3}.Values.A.Data(:,:,i)'-eigvals(j)*eye(55)]);
        if rank([(data{3}.Values.C.Data(:,:,i)'),data{3}.Values.A.Data(:,:,i)'-eigvals(j)*eye(55)])<55
            display([num2str(i),': unobservable']);
            break
        end
    end
end

figure
subplot(1,2,1)
scatter(data{1}.Values.time/60,MaxEig,'r','linewidth',1);
hold on
xlabel('time (min)','Interpreter','Latex');
ylabel('Maximum Eignvalue of $\mathbf{A}$','Interpreter','Latex');
xlim([0,150]);
xticks([0:15:150]);
L=legend('Maximum Eignvalue of $\mathbf{A}$');
set(L,'Interpreter','latex','location','east');
grid on 
box on;
set(gca,'FontSize',14,'FontName','Times New Roman'); 
subplot(1,2,2)
scatter(data{1}.Values.time/60,min(CARank'),'r','linewidth',1);
grid on 
box on;
xlim([0,150]);
xticks([0:15:150]);
xlabel('time (min)','Interpreter','Latex');
ylabel('min(rank([$\mathbf{C}^T,\mathbf{A}^T-\lambda_i\mathbf{I}$]))','Interpreter','Latex');
L=legend('min(rank([$\mathbf{C}^T,\mathbf{A}^T-\lambda_i\mathbf{I}]$))');
set(L,'Interpreter','latex','Location','Southeast');
set(gca,'FontSize',14,'FontName','Times New Roman'); 
set(gcf,'Position',[0,0,1400,400], 'color','w');
%% Deviations between the real states and the estimated states
figure
l1=plot(data{2}.Values.time/60,data{2}.Values.data(:,1)-273.15,'r-','linewidth',1);
hold on
plot(data{2}.Values.time/60,data{2}.Values.data(:,2:54)-273.15,'r-','linewidth',1);
l2=plot(data{2}.Values.time/60,data{2}.Values.data(:,55)-273.15,'k-','linewidth',1);
l3=plot(data{8}.Values.time/60,data{8}.Values.data(:,1)-273.15,'r--','linewidth',1);
l4=plot(data{8}.Values.time/60,data{8}.Values.data(:,2)-273.15,'r--','linewidth',1);
l5=plot(data{9}.Values.time/60,data{9}.Values.data(:,1)-273.15,'k--','linewidth',1);
xlabel('time (min)','Interpreter','Latex');
ylabel('temperature ($^\circ {\rm C}$)','Interpreter','Latex');
xlim([0,150]);
xticks([0:15:150]);
L=legend([l1,l2,l3,l4,l5],'Stack temperature $T_{\rm s}$ (estimated)',...
    'Hotbox temperature $T_{\rm f}$ (estimated)',...
    'Maximum stack temperature $T_{\rm s,max}$ (real)',...
    'Minimum stack temperature $T_{\rm s,min}$ (real)',...
    'Hotbox temperature $T_{\rm f}$ (real)');
set(L,'Interpreter','latex','location','southeast');
grid on 
box on;
set(gca,'FontSize',14,'FontName','Times New Roman'); 
set(gcf,'Position',[0,0,800,600], 'color','w');
%% plot the temperatrue during the heating up process
figure
load('Data8_for_revise_matrixrecorded.mat');
subplot(2,2,1)
plot(data{13}.Values.time/60,data{13}.Values.data,'r-','linewidth',1);
hold on
xlabel('time (min)','Interpreter','Latex');
ylabel('$P_{\rm heat}$ (W)','Interpreter','Latex');
ylim([0,15000]);
xlim([0,150]);
xticks([0:15:150]);
L=legend('$P_{\rm heat}$-MPC');
set(L,'Interpreter','latex','location','east');
grid on 
box on;
set(gca,'FontSize',14,'FontName','Times New Roman'); 
subplot(2,2,2)
plot(data{8}.Values.time/60,data{8}.Values.data(:,1)-273.15,'k-','linewidth',1);
grid on 
box on;
hold on
plot(data{8}.Values.time/60,data{8}.Values.data(:,2)-273.15,'r--','linewidth',1);
plot([0,150],[700,700],'k:','linewidth',2);
ylim([0,900]);
xlim([0,150]);
xticks([0:15:150]);
xlabel('time (min)','Interpreter','Latex');
ylabel('temperature ($^\circ {\rm C}$)','Interpreter','Latex');
L=legend('$T_{\rm s,max}$-MPC','$T_{\rm s,min}$-MPC');
set(L,'Interpreter','latex','Location','Southeast');
set(gca,'FontSize',14,'FontName','Times New Roman'); 
subplot(2,2,3)
plot(data{9}.Values.time/60,data{9}.Values.data(:,1)-273.15,'r-','linewidth',1);
grid on;
box on;
hold on
ylim([0,900]);
xlim([0,150]);
xticks([0:15:150]);
xlabel('time (min)','Interpreter','Latex');
ylabel('temperature ($^\circ {\rm C}$)','Interpreter','Latex');
L=legend('$T_{\rm f}$-MPC');
set(L,'Interpreter','latex','Location','Southeast');
set(gca,'FontSize',14,'FontName','Times New Roman'); 
subplot(2,2,4)
plot(data{12}.Values.time/60,data{12}.Values.data,'r-','linewidth',1);
grid on 
box on;
hold on
L=legend('$(T_{\rm s,max}-T_{\rm s,min})$-MPC');
set(L,'Interpreter','latex','location','south');
ylim([0,80]);
xlim([0,150]);
xticks([0:15:150]);
xlabel('time (min)','Interpreter','Latex');
ylabel('temperature ($^\circ {\rm C}$)','Interpreter','Latex');
set(gca,'FontSize',14,'FontName','Times New Roman'); 
set(gcf,'Position',[0,0,1400,800], 'color','w');