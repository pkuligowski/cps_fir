%% Zmiana probkowania przez decymacje

function probki_wyjsciowe = obniz_probkowanie(probki, wspolczynnik_podzialu)
    liczba_probek = numel(probki);
    
    probki_wyjsciowe = zeros(1, round(liczba_probek/wspolczynnik_podzialu));
    k = 1;
    for i=1:wspolczynnik_podzialu:liczba_probek
        probki_wyjsciowe(k) = probki(i);
        k = k + 1;
    end
end