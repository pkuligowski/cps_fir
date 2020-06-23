%% Kwantyzacja danych wejœciowych i ponowna zamiana na double,
% poniewaz implementacja obliczen na liczbach staloprzecinkowych
% w srodowisku Matlab jest kilkadziesiat razy wolniejsza od operacji
% na liczbach zmiennoprzecikowych o podwojnej precyzji.

function sample_skwantyzowane = kwantyzuj(sample, staloprzecinkowa_precyzja)
    sample_skwantyzowane = double(fi(sample, 1, staloprzecinkowa_precyzja-1));
end