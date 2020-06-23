liczba_iteracji = 64;
liczba_sampli = 4096;
staloprzecinkowa_precyzja = 8;
kwantyzacja_adc_ze_znakiem = 12;
f_probkowania = 86e6/64/32;

fir_odczepy = 8;
fir_wspolczynniki = wspolczynniki_fir(fir_odczepy, staloprzecinkowa_precyzja);

czestotliwosci = linspace(0, f_probkowania/2, liczba_sampli/2+1);

wyjscie_maksymalne = zeros(1, liczba_sampli/2+1)-1000;
wejscie_maksymalne = zeros(1, liczba_sampli/2+1)-1000;

for iteracja=1:liczba_iteracji
    iteracja
    disp('Generowanie danych danych wejsciowych...')
    sample = kwantyzuj(2*rand(1, liczba_sampli)-1, kwantyzacja_adc_ze_znakiem);

    wejscie_aktualne = oblicz_fft(sample);
    
    disp('Filtrowanie I i Q za pomoca FIR...')
    sample_filtrowane = filtr_fir(sample, fir_wspolczynniki);

    wyjscie_aktualne = oblicz_fft(sample_filtrowane);

    for n=1:liczba_sampli/2+1
        wejscie_maksymalne(n) = max([wejscie_maksymalne(n), wejscie_aktualne(n)]);
        wyjscie_maksymalne(n) = max([wyjscie_maksymalne(n), wyjscie_aktualne(n)]);
    end
end

disp('Obliczanie FFT...')
plot(czestotliwosci, wejscie_maksymalne, "b.-")
hold on
grid on
plot(czestotliwosci, wyjscie_maksymalne, "g.-")

title('FFT sygnalu wejsciowego i wyjsciowego')
xlabel('Czestotliwosc [Hz]')
ylabel('Amplituda [dB]')

disp('Wyznaczanie transmitancji...')
figure
plot(czestotliwosci, wyjscie_maksymalne-wejscie_maksymalne, "b.-")
hold on
grid on
plot(czestotliwosci, ones(1, numel(czestotliwosci))*0.5, "r--");
plot(czestotliwosci, ones(1, numel(czestotliwosci))*(-0.5), "r--");

title('Transmitancja filtru')
xlabel('Czestotliwosc [Hz]')
ylabel('Amplituda [dB]')