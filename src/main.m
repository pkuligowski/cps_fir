liczba_iteracji = 8;
f_probkowania = 86e6;
f_nosna = 21.5e6;
staloprzecinkowa_precyzja = 32;
kwantyzacja_adc_ze_znakiem = 13;
fir_iq_odczepy = 300;
liczba_sampli = 4096*32;
predkosc_transmisji = 9600;

pierwsza_decymacja = 64;
druga_decymacja = 64;
fir_decymacja1_odczepy = 16;
fir_decymacja1_wspolczynniki = wspolczynniki_fir(fir_decymacja1_odczepy, staloprzecinkowa_precyzja);


plot(fir_decymacja1_wspolczynniki, "r.-")
figure

czestotliwosci = linspace(0, f_probkowania/2, liczba_sampli/2+1);
czestotliwosci_obnizone = linspace(0, f_probkowania/pierwsza_decymacja/2/druga_decymacja, liczba_sampli/pierwsza_decymacja/2/druga_decymacja+1);

wyjscie_maksymalne = zeros(1, liczba_sampli/2+1)-1000;
rzeczywiste_maksymalne = zeros(1, round(liczba_sampli/pierwsza_decymacja/2/druga_decymacja+1))-1000;
wejscie_maksymalne = zeros(1, liczba_sampli/2+1)-1000;
for iteracja=1:liczba_iteracji
    iteracja
    disp('Generowanie danych danych wejsciowych...')
    dane_do_wyslania = randi([0, 1], [1,256]);
    sample = moduluj_bpsk(dane_do_wyslania, predkosc_transmisji, liczba_sampli, f_nosna, f_probkowania, kwantyzacja_adc_ze_znakiem-1);

    disp('Wyznaczanie wspolczynnikow FIR...')
    fir_iq_wspolczynniki = wspolczynniki_fir(fir_iq_odczepy, staloprzecinkowa_precyzja);

    disp('Modulowanie kwadraturowe...')
    [i, q] = moduluj_kwadraturowo(sample, staloprzecinkowa_precyzja, f_nosna, f_probkowania);

    disp('Filtrowanie I i Q za pomoca FIR...')
    i = filtr_fir(i, fir_iq_wspolczynniki);
    q = filtr_fir(q, fir_iq_wspolczynniki);
    
    disp('Pierwsza decymacja i drugi FIR...')
    obnizone1_i = obniz_probkowanie(i, pierwsza_decymacja);
    obnizone1_q = obniz_probkowanie(q, pierwsza_decymacja);
    obnizone1_i = filtr_fir(obnizone1_i, fir_decymacja1_wspolczynniki);
    obnizone1_q = filtr_fir(obnizone1_q, fir_decymacja1_wspolczynniki);
    
    disp('Druga decymacja...')
    obnizone2_i = obniz_probkowanie(obnizone1_i, pierwsza_decymacja);
    obnizone2_q = obniz_probkowanie(obnizone1_q, pierwsza_decymacja);

    rzeczywiste = iq_do_rzeczywistego(obnizone2_i, obnizone2_q);
    
    rzeczywiste_aktualne = oblicz_fft(rzeczywiste);
    wejscie_aktualne = oblicz_fft(sample);

    for n=1:liczba_sampli/2+1
        wejscie_maksymalne(n) = max([wejscie_maksymalne(n), wejscie_aktualne(n)]);
    end
    
    for n=1:numel(rzeczywiste_aktualne)
        rzeczywiste_maksymalne(n) = max([rzeczywiste_maksymalne(n), rzeczywiste_aktualne(n)]);
    end
end

disp('Obliczanie FFT...')
plot(czestotliwosci-f_nosna, wejscie_maksymalne, "b.-")
hold on
grid on
%plot(czestotliwosci, wyjscie_maksymalne, "y.-")
numel(czestotliwosci_obnizone)
numel(rzeczywiste_maksymalne)
plot(czestotliwosci_obnizone, rzeczywiste_maksymalne, "m.-")

title('FFT sygnalu wejsciowego i wyjsciowego')
xlabel('Czestotliwosc [Hz]')
ylabel('Amplituda [dB]')

fft_diff = zeros(1, numel(rzeczywiste_maksymalne));
for n=1:numel(rzeczywiste_maksymalne)
    fft_diff(n) = rzeczywiste_maksymalne(n) - wejscie_maksymalne(1-n+round(numel(wejscie_maksymalne)/2));
end
    
figure
plot(czestotliwosci_obnizone, fft_diff, "b.-");
hold on
grid on
plot(czestotliwosci_obnizone, ones(1, numel(fft_diff))*0.5, "r--");
plot(czestotliwosci_obnizone, ones(1, numel(fft_diff))*(-0.5), "r--");
