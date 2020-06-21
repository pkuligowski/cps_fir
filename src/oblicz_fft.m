%% Funkcja odpowiada za generowanie okienkowanie, FFT i przeliczanie na dB
% Funkcja na poczatku poddaje probki okienkowaniu za pomoca
% funkcji okna Hamminga. Nastepnie poddaje zokienkowane probki
% wbudowanej funkcji FFT w Matlab. Z otrzymanych wynikow
% zespolonych wyciaga czesc rzeczywista i zwraca amplitude
% pzeliczona na dB.

function amplituda_fft_w_dB = oblicz_fft(probki)
    liczba_sampli = numel(probki);
    
    % Zdecydowano siê na zastosowanie okna Hamminga 
    % aby ograniczyc wycieki widma.
    a0 = 0.53836;
    for n = 1:liczba_sampli
        window = a0 - (1 - a0) * cos(2 * pi * n /liczba_sampli);
        probki(n) = probki(n) * window;
    end
    
    transformata = fft(probki); % <- skorzystano z wbudowanej funkcji FFT
    %P2 = abs(transformata/liczba_sampli);
    %P1 = P2(1:liczba_sampli/2+1);
    %P1(2:end-1) = 2*P1(2:end-1);
    n = 2^nextpow2(liczba_sampli);
    P2 = abs(transformata/liczba_sampli);
    P1 = P2(1:n/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    amplituda_fft_w_dB = 20*log(P1);
end