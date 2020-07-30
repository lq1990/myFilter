function [ y ] = myFilter( b, a, x )
    % b: coef of x
    % a: coef of y
    % x: data to be filtered
    % y: filtered data
    
    % exd.LFilter1D.apply() same as

    y = zeros(size(x));
    for n=1:length(x)
        for bi = 1 : min(n, length(b))
            y(n) = y(n) +  b(bi) * x(n-(bi-1));
        end
        for ai = 2 : min(n, length(a))
            y(n) = y(n) - a(ai) * y(n-(ai-1));
        end
    end

end

