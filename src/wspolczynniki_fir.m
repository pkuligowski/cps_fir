%% Generator wspolczynnikow filtru FIR z oknem Gaussa

function wspolczynniki = wspolczynniki_fir(liczba_odczepow, kwantyzacja_ze_znakiem)
    wspolczynniki = zeros(1, liczba_odczepow);
    fir_gaus_alpha = 3;
    for n = 1:liczba_odczepow
        wspolczynniki(n) = exp(-0.5*((fir_gaus_alpha*n)/(liczba_odczepow/2))^2);
    end
    wspolczynniki = kwantyzuj(wspolczynniki, kwantyzacja_ze_znakiem);
    wspolczynnik_wzmocnienia = sum(wspolczynniki);
    wspolczynniki = wspolczynniki / wspolczynnik_wzmocnienia;
end