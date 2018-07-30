clf; close all;
f = imread('8.jpg');		% input image
h = abs(f(:,:,1)-f(:,:,3)); % R通道与B通道绝对值之差
% figure(1);imshow(h);
thr = graythresh(h);
hh = imbinarize(h,thr);     % 自适应二值化
% 自适应调整横竖
max1 = max(sum(hh));
max2 = max(sum(hh,2));
if max1 > max2
    hh = hh';
    hh = fliplr(hh);
end
% figure(2);imshow(hh);
sumH = sum(hh);             % 投影到横轴
% figure(3);plot(sumH);
ind1 = find(sumH>0);
H1 = sumH(sumH>0);
% 自适应调整左右（缺口在右）
len_gap = floor(length(H1)*65/1755);
left_gap = sum(H1(1:len_gap));
right_gap = sum(H1((end-len_gap+1):end));
if left_gap < right_gap
    H1 = fliplr(H1);
end
H1 = H1(1:(end-len_gap+1));  % 去除无关区域
figure(4);plot(H1);         
% 固定刻度的坐标在数组const_mark
diffH = diff(H1);
% figure(5);plot(diffH);
[diff_sort, ind] = sort(diffH);
% mark = [151,499,239,283,779,624,326,456,701,818,1326,369,935,973,1150,...
%     1061,196,1591,541,662,740,857,896,1414,583,1503,413,1238];
% mark = sort(mark);
const_mark_ratio = 1690;
const_mark = [151,196,239,283,326,369,413,456,499,541,583,624,662,701,740,...
    779,818,857,896,935,973,1061,1150,1238,1326,1414,1503,1591];
const_mark = const_mark/const_mark_ratio;   % 归一化
% figure(6);plot(mark,'.');
% 找小球
const_ball_ratio = 54.5161;
ball_len = floor(length(H1)/const_ball_ratio);
mymin = max(H1)*ball_len;
ball_ind = -1;
for i = 1:(length(H1)-ball_len)
    myball = sum(H1(i:(i+ball_len)));
    if myball < mymin
        ball_ind = i;
        mymin = myball;
    end
end
% disp(['ball_ind: ',num2str(ball_ind)]);
ball_ind = ball_ind/length(H1);     % 归一化
% 计算ball_ind在const_mark中的位置
cnt = 28;
res = -1;
for i = const_mark
    if ball_ind < i
        res = cnt;
        break;
    end
    cnt = cnt - 1;
end
disp(['between mark ',num2str(res),' and mark ',num2str(res+1)]);