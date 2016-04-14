function [p_x, p_y] = updateMouse(x_v,y_v)
    [p_x,p_y] = GetMouse;
%    p_x = temp(1);
%    p_y = temp(2);
    threshold = 30;
    displacement = 50;
    if (abs(x_v) > threshold && abs(y_v) < threshold)
        p_x = p_x + displacement*sign(x_v);
    elseif (abs(x_v) < threshold && abs(y_v) > threshold)
        p_y = p_y + displacement*sign(y_v);
    elseif (abs(x_v) > threshold && abs(y_v) > threshold)
        p_x = p_x + displacement*sign(x_v);
        p_y = p_y + displacement*sign(y_v);
    end
    p_x = round(p_x);
    p_y = round(p_y);
        


end