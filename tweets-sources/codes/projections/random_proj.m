%%
% Generate a polygon.

rep = 'results/';
[~,~] = mkdir(rep);
if not(exist('test'))
    test=1;
end


% click and play
clf; hold on;
Q = [];
while true
    axis([-1 1 -1 1]);
    [a,b,button] = ginput(1);
    plot(a,b, '.', 'MarkerSize', 15);   
    if button==3
        break;
    end
    Q(:,end+1) = [a;b];
end
Z = Q(1,:) + Q(2,:)*1i;

N = size(Q,2);
R = 100; % #points in segments
t = (0:R-1)'/R;
Zi = [];
for i=1:N
    j = mod(i,N)+1;
    Zi = [Zi; Z(i)*(1-t)+Z(j)*t ];
end
Ri = length(Zi);

% generate random points
P = 200;
a = randn(P,1)*2*pi;
b = .2*randn(P,1)+1.5;
Q = b.*( cos(a) + 1i*sin(a));

% distance matrix
D = abs( repmat(Zi,[1 P]) - repmat(permute(Q,[2 1]),[Ri 1]) );
[Dm,I] = min(D, [], 1);

clf; hold on;
fill(real(Z),imag(Z), [1 1 1]*.8);
plot(Zi([1:end 1]), 'k', 'LineWidth', 2);
for k=1:P
    i = I(k);
    c = rand(3,1);
    t = (i-1)/(Ri-1);
    c = [cos(2*pi*t)+1 1-sin(2*pi*t) sin(2*pi*t)+1]/2;
    z = Zi(i);
    plot([z Q(k)], '.', 'MarkerSize', 25, 'Color', c);
    plot([z Q(k)], ':', 'LineWidth', 1, 'Color', c);    
end
axis tight; axis equal; axis off;
saveas(gcf, [rep 'proj-' num2str(test), '.png'], 'png');

test = test+1;