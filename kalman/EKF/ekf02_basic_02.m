close all;
clear all;

% X: [x; vx; y; vy]
% y: [����r���Ƕ�alpha]
%%  ��ʵ�켣��ģ�⣩
kx = 0.01;   ky = 0.05;     % ����ϵ��
g = 9.8;                    % ����
t = 15;                     % ����ʱ��
Ts = 0.1;                   % �������� 
len = fix(t/Ts);            % ���沽��
dax = 0.3; day = 0.3;       % ϵͳ����
X = zeros(len,4);           % ״̬�Ŀվ���
X(1,:) = [0, 50, 500, 0];   % ״̬ģ��ĳ�ֵ
for k=2:len
    x = X(k-1,1); vx = X(k-1,2); y = X(k-1,3); vy = X(k-1,4); 
    x = x + vx*Ts;
    vx = vx + (-kx*vx^2+dax*randn(1,1))*Ts;
    y = y + vy*Ts;
    vy = vy + (ky*vy^2-g+day*randn(1))*Ts;
    X(k,:) = [x, vx, y, vy];
end
%%  �����״����ֵ
dr = 8;  dafa = 0.1;        % ��������
for k=1:len
    r = sqrt(X(k,1)^2+X(k,3)^2) + dr*randn(1,1);
    a = atan(X(k,1)/X(k,3))*57.3 + dafa*randn(1,1);
    Z(k,:) = [r, a];
end
%% EKF ��չ�������˲�
Qk = diag([0; dax; 0; day])^2;  
Rk = diag([dr; dafa])^2;        %W(k)��V(k)�ֱ��ʾ���̺Ͳ��������������Ǳ�����ɸ�˹������(White Gaussian Noise)�����ǵ�Э����(covariance)�ֱ���Q��R���������Ǽ������ǲ���ϵͳ״̬�仯���仯��
Pk = 10*eye(4);                 %����������
Pkk_1 = 10*eye(4);              %״̬Э�������
x_hat = [0,40,500,0]';          %����״̬���̱���
X_est = zeros(len,4);           %���ŵ�״̬
x_forecast = zeros(4,1);        %Ԥ���״̬����
z = zeros(4,1);                 %�۲����
for k=1:len
    % 1 ״̬Ԥ��    
    x1 = x_hat(1) + x_hat(2)*Ts; % �⼸��״̬Ԥ�ⷽ�̣���java����ε��룿
    vx1 = x_hat(2) + (-kx*x_hat(2)^2)*Ts; % �˴��з����Ե� ƽ����
    y1 = x_hat(3) + x_hat(4)*Ts;
    vy1 = x_hat(4) + (ky*x_hat(4)^2-g)*Ts; %��ƽ��
    x_forecast = [x1; vx1; y1; vy1];        %Ԥ��ֵ
    % 2  �۲�Ԥ��
    r = sqrt(x1*x1+y1*y1);
    alpha = atan(x1/y1)*57.3;  %57.3=180/pi,matlab�û��Ȳ��ýǶ�
    y_yuce = [r,alpha]';
    %  ״̬ Э��������ſɱȾ���
    vx = x_forecast(2);  vy = x_forecast(4);
    F = zeros(4,4);
    F(1,1) = 1;  F(1,2) = Ts;
    F(2,2) = 1-2*kx*vx*Ts;
    F(3,3) = 1;  F(3,4) = Ts;
    F(4,4) = 1+2*ky*vy*Ts;
    Pkk_1 = F*Pk*F'+Qk;
    %�۲� Э��������ſɱȾ���
    %�۲ⷽ�̵��ſ˱Ⱦ����ǹ۲�����״̬���󵼣�����۲����о���ͽǶȣ�״̬��4������ÿһ���۲����ֱ��4��״̬�󵼣�����������ſ˱Ⱦ�����2x4�ľ���
    x = x_hat(1); y = x_hat(3);
    H = zeros(2,4);
    r = sqrt(x^2+y^2);  xy2 = 1+(x/y)^2;
    H(1,1) = x/r;  H(1,3) = y/r;
    H(2,1) = (1/y)/xy2;  H(2,3) = (-x/y^2)/xy2;
    %���㿨��������
    Kk = Pkk_1*H'*(H*Pkk_1*H'+Rk)^-1;
    %У��
    x_hat = x_forecast+Kk*(Z(k,:)'-y_yuce);      
    Pk = (eye(4)-Kk*H)*Pkk_1;
    X_est(k,:) = x_hat;
end
%%��ͼ 
figure, hold on, grid on;
plot(X(:,1),X(:,3),'-r');    %��ʵλ��
plot(Z(:,1).*sin(Z(:,2)*pi/180), Z(:,1).*cos(Z(:,2)*pi/180), 'b');   %�۲�λ��
plot(X_est(:,1),X_est(:,3), 'k', 'LineWidth', 2);   %����λ��
xlabel('X'); 
ylabel('Y'); 
title('EKF simulation');
legend('real', 'measurement', 'ekf estimated');
axis([-5,230,290,530]);