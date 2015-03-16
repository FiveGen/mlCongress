function graph_cv(plot_errors)

min_error = 1;
min_params = [0,0,0]; %k,d,s

colors = ['-*r';'-*g';'-*b';'-*c';'-*m';'-*y';'-*k';'-*w'];
colors_err = ['rx';'gx';'bx';'cx';'mx';'yx';'kx';'wx'];

cv = dlmread('./c_v_split.txt', ',');

hp_1 = cv(:,1);
hp_2 = cv(:,2);

x = cv(:,4);
y = cv(:,3);
sd = cv(:,5);

[me, ind] = min(y);
if me < min_error
    min_error = me;
    min_params = [hp_1(ind), hp_2(ind), x(ind)];
end

legend_labels = {};
prev_i = 1;
c = 1;
err_bars = {};
for i = 2:length(hp_1)
    if hp_1(i) ~= hp_1(i-1) || hp_2(i) ~= hp_2(i-1)
        mat = [x(prev_i:i-1), y(prev_i:i-1), sd(prev_i:i-1)];
        [values, order] = sort(mat(:,1));
        m = mat(order,:);
        
        plot(m(:,1),m(:,2),colors(c,:));
        hold on;
        legend_labels = [legend_labels, strcat('K=', int2str(hp_1(i-1)), ', depth=', int2str(hp_2(i-1)) )];
        err_bars{length(err_bars)+1} = {m(:,1),m(:,2),m(:,3),colors_err(c,:)};

        
        c = mod(c+1,size(colors,1));
        if c == 0
            c = c+1;
        end
        prev_i = i;
        hold on;
    end
end
if prev_i < length(hp_1)
    mat = [x(prev_i:length(hp_1)), y(prev_i:length(hp_1)), sd(prev_i:length(hp_1))];
    [values, order] = sort(mat(:,1));
    m = mat(order,:);
    plot(m(:,1),m(:,2),colors(c,:));
    hold on;
    legend_labels = [legend_labels, strcat('K=', int2str(hp_1(prev_i)), ', depth=', int2str(hp_2(prev_i)) )];
    err_bars{length(err_bars)+1} = {m(:,1),m(:,2),m(:,3),colors_err(c,:)};
    
    
    hold on;
end
legend(legend_labels,'FontSize',12,'FontWeight','bold');
if plot_errors == true
    for i = 1:length(err_bars)
        errorbar(err_bars{i}{1},err_bars{i}{2},err_bars{i}{3},err_bars{i}{4});
    end
end

ylabel('Cross Validation Error');
title('Cross Validation Error for Each Split Size');
xlabel('Number of features considered at each split');
grid on;

if plot_errors == true
    saveas(gcf, 'cv_split_err.fig');
else
    saveas(gcf, 'cv_split.fig');
end

hold off;

cv = dlmread('./c_v_depth.txt', ',');

hp_1 = cv(:,1);
hp_2 = cv(:,2);

x = cv(:,4);
y = cv(:,3);
sd = cv(:,5);

legend_labels = {};
prev_i = 1;
c = 1;
err_bars = {};
for i = 2:length(hp_1)
    if hp_1(i) ~= hp_1(i-1) || hp_2(i) ~= hp_2(i-1)
        mat = [x(prev_i:i-1), y(prev_i:i-1), sd(prev_i:i-1)];
        [values, order] = sort(mat(:,1));
        m = mat(order,:);
        
        plot(m(:,1),m(:,2),colors(c,:));
        hold on;
        legend_labels = [legend_labels, strcat('K=', int2str(hp_1(i-1)), ', split=', int2str(hp_2(i-1)) )];
        err_bars{length(err_bars)+1} = {m(:,1),m(:,2),m(:,3),colors_err(c,:)};

        
        c = mod(c+1,size(colors,1));
        if c == 0
            c = c+1;
        end
        prev_i = i;
        hold on;
    end
end

if prev_i < length(hp_1)
    mat = [x(prev_i:length(hp_1)), y(prev_i:length(hp_1)), sd(prev_i:length(hp_1))];
    [values, order] = sort(mat(:,1));
    m = mat(order,:);
    plot(m(:,1),m(:,2),colors(c,:));
    hold on;
    legend_labels = [legend_labels, strcat('K=', int2str(hp_1(prev_i)), ', split=', int2str(hp_2(prev_i)) )];
    err_bars{length(err_bars)+1} = {m(:,1),m(:,2),m(:,3),colors_err(c,:)};
    hold on;
end
legend(legend_labels,'FontSize',12,'FontWeight','bold');
if plot_errors == true
    for i = 1:length(err_bars)
        errorbar(err_bars{i}{1},err_bars{i}{2},err_bars{i}{3},err_bars{i}{4});
    end
end

ylabel('Cross Validation Error');
title('Cross Validation Error for Each Depth');
xlabel('Depth of Tree');

grid on;

if plot_errors == true
    saveas(gcf, 'cv_depth_err.fig');
else
    saveas(gcf, 'cv_depth.fig');
end

hold off;
cv = dlmread('./c_v_K.txt', ',');

hp_1 = cv(:,1);
hp_2 = cv(:,2);

x = cv(:,4);
y = cv(:,3);
sd = cv(:,5);

prev_i = 1;
c = 1;

for i = 2:length(hp_1)
    if hp_1(i) ~= hp_1(i-1) || hp_2(i) ~= hp_2(i-1)
        mat = [x(prev_i:i-1), y(prev_i:i-1), sd(prev_i:i-1)];
        [values, order] = sort(mat(:,1));
        m = mat(order,:);
        
        plot(m(:,1),m(:,2),colors(c,:));
        hold on;
        errorbar(m(:,1),m(:,2),m(:,3),colors_err(c,:));
        
        c = mod(c+1,size(colors,1));
        if c == 0
            c = c+1;
        end
        prev_i = i;
        hold on;
    end
end
if prev_i < length(hp_1)
    mat = [x(prev_i:length(hp_1)), y(prev_i:length(hp_1)), sd(prev_i:length(hp_1))];
    [values, order] = sort(mat(:,1));
    m = mat(order,:);
    plot(m(:,1),m(:,2),colors(c,:));
    hold on;
    errorbar(m(:,1),m(:,2),m(:,3),colors_err(c,:));
    
    hold on;
end

ylabel('Cross Validation Error');
title('Cross Validation Error per Number of Topics');
xlabel('Number of Topics');

grid on;

saveas(gcf, 'cv_K.fig');
close all;

[values, order] = sort(cv(:,3));
m = cv(order,:);
disp('Lowest Classification Errors:');
disp([m(1:4,4), m(1:4,1), m(1:4,2), m(1:4,3)]);


end