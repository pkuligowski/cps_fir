
f_probkowania = 86e6;
f_nosna = 21.5e6;
staloprzecinkowa_precyzja = 24;
kwantyzacja_adc_ze_znakiem = 13;
fir_iq_odczepy = 512;
liczba_sampli = 4096*64;
predkosc_transmisji = 9600;

pierwsza_decymacja = 70;
druga_decymacja = 70;

czestotliwosci = linspace(0, f_probkowania/2, liczba_sampli/2+1);
czestotliwosci_obnizone = linspace(0, f_probkowania/pierwsza_decymacja/2, liczba_sampli/pierwsza_decymacja/2+1);

liczba_iteracji = 2;
wyjscie_maksymalne = zeros(1, liczba_sampli/2+1)-1000;
obnizone_maksymalne = zeros(1, round(liczba_sampli/pierwsza_decymacja/2+1))-1000;
wejscie_maksymalne = zeros(1, liczba_sampli/2+1)-1000;
for iteracja=1:liczba_iteracji
    iteracja
    disp('Generowanie danych danych wejsciowych...')
    dane_do_wyslania = randi([0, 1], [1,256]);
    sample = moduluj_bpsk(dane_do_wyslania, predkosc_transmisji, liczba_sampli, f_nosna, f_probkowania, kwantyzacja_adc_ze_znakiem-1);

    disp('Wyznaczanie wspolczynnikow FIR...')
    fir_iq_wspolczynniki = wspolczynniki_fir(fir_iq_odczepy);
    fir_iq_wspolczynniki = double(fi(fir_iq_wspolczynniki, 1, staloprzecinkowa_precyzja));

    disp('Modulowanie kwadraturowe...')
    [i, q] = moduluj_kwadraturowo(sample, staloprzecinkowa_precyzja, f_nosna, f_probkowania);

    disp('Filtrowanie I i Q za pomoca FIR...')
    i = filtr_fir(i, fir_iq_wspolczynniki);
    q = filtr_fir(q, fir_iq_wspolczynniki);
    
    rzeczywiste = iq_do_rzeczywistego(i, q);
    obnizone = obniz_probkowanie(rzeczywiste, pierwsza_decymacja);
    
    wyjscie_aktualne = oblicz_fft(rzeczywiste)-58.48;
    wejscie_aktualne = oblicz_fft(sample)+34.86;
    obnizone_aktualne = oblicz_fft(obnizone)-58.48;
    
    for n=1:liczba_sampli/2+1
        wyjscie_maksymalne(n) = max([wyjscie_maksymalne(n), wyjscie_aktualne(n)]);
        wejscie_maksymalne(n) = max([wejscie_maksymalne(n), wejscie_aktualne(n)]);
    end
    
    for n=1:liczba_sampli/pierwsza_decymacja/2+1
        obnizone_maksymalne(n) = max([obnizone_maksymalne(n), obnizone_aktualne(n)]);
    end
end

disp('Obliczanie FFT...')
plot(czestotliwosci-f_nosna, wejscie_maksymalne, "b.-")
hold on
grid on
plot(czestotliwosci, wyjscie_maksymalne, "y.-")
numel(czestotliwosci_obnizone)
numel(obnizone_maksymalne)
plot(czestotliwosci_obnizone, obnizone_maksymalne, "m.-")
numel(obnizone)

title('FFT sygnalu wejsciowego i wyjsciowego')
xlabel('Czestotliwosc [Hz]')
ylabel('Amplituda [dB]')
