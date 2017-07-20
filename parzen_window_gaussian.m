function p_n = parzen_window_gaussian(samples, hn, space)
    xs_len = length(samples);
    xn_len = length(space);
    p_n = zeros(xn_len, 1); 
    for mu = 1:xn_len
        sum = 0;
        for k = 1:xs_len
            sum = sum + (1/hn)* psi_u((samples(k) - space(mu))/hn);
        end
        p_n(mu) = sum / xs_len;
    end