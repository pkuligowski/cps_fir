%% Filtr FIR konfigurowany przez tablice wspolczynnikow

function probki_wyjsciowe = filtr_fir(probki, fir_wspolczynniki)
    fir_odczepy = numel(fir_wspolczynniki);
    liczba_sampli = numel(probki);
    probki_wyjsciowe = zeros(1, liczba_sampli);

    fir_reg = zeros(1, fir_odczepy);
    f = waitbar(0,'Przetwarzanie FIR...');
    for j=1:liczba_sampli
        for k = fir_odczepy:-1:3
            fir_reg(k-1) = fir_reg(k-2);
        end
        fir_reg(1) = probki(j);
        fir_y = 0;
        for k = 1:fir_odczepy
            fir_y = fir_y + fir_wspolczynniki(k) * fir_reg(k);
        end

        probki_wyjsciowe(j) = fir_y;

        if j == 100000
            waitbar(j/liczba_sampli,f,'Przetwarzanie FIR...');
        end
        if j == 200000
            waitbar(j/liczba_sampli,f,'Przetwarzanie FIR...');
        end
        if j == 300000
            waitbar(j/liczba_sampli,f,'Przetwarzanie FIR...');
        end
        if j == 400000
            waitbar(j/liczba_sampli,f,'Przetwarzanie FIR...');
        end
        if j == 500000
            waitbar(j/liczba_sampli,f,'Przetwarzanie FIR...');
        end
        if j == 600000
            waitbar(j/liczba_sampli,f,'Przetwarzanie FIR...');
        end
        if j == 700000
            waitbar(j/liczba_sampli,f,'Przetwarzanie FIR...');
        end
        if j == 800000
            waitbar(j/liczba_sampli,f,'Przetwarzanie FIR...');
        end
        if j == 900000
            waitbar(j/liczba_sampli,f,'Przetwarzanie FIR...');
        end
        if j == 990000
            waitbar(j/liczba_sampli,f,'Przetwarzanie FIR...');
        end
    end
    close(f)
end