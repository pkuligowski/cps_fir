function probki_wyjsciowe = iq_do_rzeczywistego(i, q)
    liczba_sampli = numel(i);
    probki_wyjsciowe = zeros(1, liczba_sampli);
    
    for n=1:liczba_sampli
        probki_wyjsciowe(n) = i(n) - q(n);
        %probki_wyjsciowe(n) = atan2(imag(q(n)), real(i(n)));
        %i_ = cos(2*pi*(0)*1/86000000*n) * i(n);
        %q_ = sin(2*pi*(0)*1/86000000*n) * q(n);
        %probki_wyjsciowe(n) = i_ - q_;
    end
end