function [ conts] = AverageCont(cont)
conts(:,1)=conv(cont(:,1),[0.1; 0.1;0.4; 0.1; 0.1]);
conts(:,2)=conv(cont(:,2),[0.1 ;0.1;0.4; 0.1; 0.1]);
% for i = 1: floor(size(conts,1)/4)
% cont2(i,:) = conts((i-1)*4+1,:);
% end
end

