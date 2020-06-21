function probki_wyjsciowe = moduluj_bpsk(dane_do_wyslania, predkosc_transmisji, liczba_sampli, fc, fp, bity_bez_znaku)
    probki_wyjsciowe = zeros(1, liczba_sampli);
    
    f = waitbar(0,'Generowanie ciagu bitow zmodulowanego BPSK...');
    
    rrc_odczepy = liczba_sampli/128; % docelowo 64
    rrc_wspolczynniki = zeros(1, rrc_odczepy);
    beta = 0.9;
    T = rrc_odczepy/8;
    for n = 1:rrc_odczepy
        gora = cos(pi*beta*n/T);
        dol = 1-(2*beta*n/T)^2;
        rrc_wspolczynniki(n) = gora/dol;
    end
    
    rrc_reg = zeros(1, rrc_odczepy);
    dane_nrz = 2 * dane_do_wyslania - 1;
    liczba_bitow = numel(dane_nrz);
    bit_danych = 1;
    for n=1:liczba_sampli
        T = 1/predkosc_transmisji;
        LO = sqrt(2/T)*cos(2*pi*fc/fp*n);
        
        for k = rrc_odczepy:-1:3
            rrc_reg(k-1) = rrc_reg(k-2);
        end
        rrc_reg(1) = dane_nrz(bit_danych);
        rrc_y = 0;
        for k = 1:rrc_odczepy
            rrc_y = rrc_y + rrc_wspolczynniki(k) * rrc_reg(k);
        end
        
        probki_wyjsciowe(n) = rrc_y * LO;

        if mod(n, predkosc_transmisji)==0
            bit_danych = bit_danych + 1;
            waitbar(n/liczba_sampli,f,'Generowanie ciagu bitow zmodulowanego BPSK...');
        end
        if bit_danych > liczba_bitow
            bit_danych = 1;
        end
    end
    
    % Kwantyzacja - symulacja ADC
    max_wartosc = max([max(probki_wyjsciowe), abs(min(probki_wyjsciowe))]);
    potega_2 = 2^bity_bez_znaku;
    for n=1:liczba_sampli
        probki_wyjsciowe(n) = round(probki_wyjsciowe(n)/max_wartosc * potega_2)/potega_2; 
    end
    
    close(f)
end