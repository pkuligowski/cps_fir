function [i, q] = moduluj_kwadraturowo(probki, precyzja, fc, fp)
    liczba_sampli = numel(probki);

    i = zeros(1, liczba_sampli);
    q = zeros(1, liczba_sampli);
    
    f = waitbar(0,'Modulowanie kwadraturowe...');
    %pi2_fc_tp = double(fi(2 * pi * fc / fp, 1, precyzja));
    pi2_fc_tp = 2 * pi * (fc / fp)
    for n=1:1:liczba_sampli
        pi2_fc_tp_n = pi2_fc_tp * n;
        
        %i(n) = cos(pi2_fc_tp_n) * probki(n);
        %q(n) = sin(pi2_fc_tp_n) * probki(n);
        i(n) = cos(2*pi*(21500000)*1/86000000*n) * probki(n);
        q(n) = sin(2*pi*(21500000)*1/86000000*n) * probki(n);
        
        if n == 100000
            waitbar(n/liczba_sampli,f,'Modulowanie kwadraturowe...');
        end
        if n == 200000
            waitbar(n/liczba_sampli,f,'Modulowanie kwadraturowe...');
        end
        if n == 300000
            waitbar(n/liczba_sampli,f,'Modulowanie kwadraturowe...');
        end
        if n == 400000
            waitbar(n/liczba_sampli,f,'Modulowanie kwadraturowe...');
        end
        if n == 500000
            waitbar(n/liczba_sampli,f,'Modulowanie kwadraturowe...');
        end
        if n == 600000
            waitbar(n/liczba_sampli,f,'Modulowanie kwadraturowe...');
        end
        if n == 700000
            waitbar(n/liczba_sampli,f,'Modulowanie kwadraturowe...');
        end
        if n == 800000
            waitbar(n/liczba_sampli,f,'Modulowanie kwadraturowe...');
        end
        if n == 900000
            waitbar(n/liczba_sampli,f,'Modulowanie kwadraturowe...');
        end
        if n == 990000
            waitbar(n/liczba_sampli,f,'Modulowanie kwadraturowe...');
        end
    end
    
    close(f)
end