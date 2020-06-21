%samples = importdata("samples");
fp = 86000000;
fc = 21500000;
staloprzecinkowa_precyzja = 24;
kwantyzacja_ze_znakiem = 13;
fir_odczepy = 128;
%samples = samples(1:4096*256);
liczba_sampli = 4096*256;
dane_do_wyslania = randi([0, 1], [1,256]);
predkosc_transmisji = 9600;

zmodulowane_bpsk = moduluj_bpsk(dane_do_wyslania, predkosc_transmisji, 4096*256, fc, fp, kwantyzacja_ze_znakiem-1);

figure
plot(zmodulowane_bpsk, ".-")
samples = zmodulowane_bpsk;

disp('Wyznaczanie wspolczynnikow FIR...')
fir_wspolczynniki = zeros(1, fir_odczepy);
fir_gaus_alpha = 3;
for n = 1:fir_odczepy
    fir_wspolczynniki(n) = exp(-0.5*((fir_gaus_alpha*n)/(fir_odczepy/2))^2);
end
%fir_wspolczynniki = double(fi(fir_wspolczynniki, 1, staloprzecinkowa_precyzja));

%plot(fir_wspolczynniki)
figure

czestotliwosci = linspace(0, 21.5e6*2, liczba_sampli/2+1);
samples_fixed = samples;

disp('Obliczanie FFT 1...')
plot(czestotliwosci-21500000, oblicz_fft(samples), ".-")
hold on

disp('Modulowanie kwadraturowe...')
[i, q] = moduluj_kwadraturowo(samples, staloprzecinkowa_precyzja, fc, fp);

%disp('Obliczanie FFT 2...')
%plot(czestotliwosci, oblicz_fft(i), "r.-")

disp('Filtrowanie I i Q za pomoca FIR...')
i = filtr_fir(i, fir_wspolczynniki);
q = filtr_fir(q, fir_wspolczynniki);

%disp('Obliczanie FFT 3...')
%plot(czestotliwosci, oblicz_fft(i), "g.-")

rzeczywisty = iq_do_rzeczywistego(i, q);
disp('Obliczanie FFT 3...')
plot(czestotliwosci, oblicz_fft(rzeczywisty), "y.-")

title('Single-Sided Amplitude Spectrum of S(t)')
xlabel('Czestotliwosc [Hz]')
ylabel('Amplituda [dB]')


%figure
%plot(i)
%hold on
%plot(q, "r")
