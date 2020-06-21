function probki_wyjsciowe = iq_do_rzeczywistego(i, q)
    liczba_sampli = numel(i);
    probki_wyjsciowe = zeros(1, liczba_sampli);
    
    for n=1:liczba_sampli
        probki_wyjsciowe(n) = i(n) - q(n);
    end
end