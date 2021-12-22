--- KÄÄNTÄMINEN: ---

Ohjelman kääntäminen ja suoritus onnistuu seuraavalla kolmella komentorivikomennoilla:

gfortran -c population.f90 utils.f90 disease.f90

gfortran population.o utils.o disease.o

Näiden jälkeen ohjelman saa käynnistettyä komennolla:

./a.exe

--- OMAT PARAMETRIT: ---

Ohjelmalle on myös mahdollista antaa komentorivikomentoja parametreiksi, jolloin ohjelma suoritetaan niiden perusteella kovakoodattujen
parametrien sijaan.

Tämä onnistuu kääntämisen jälkeen esimerkiksi seuraavalla tavalla:

./a.exe 20 100 3000 40 0 3 60

Ohjelma vaatii tasan seitsemän komentoriviparametriä syötteeksi, ja niiden merkitys on seuraava:

./a.exe (N x N maailman koko) (maksimi aika-askeleet) (populaation määrä) (sairaiden määrä) (immuunien määrä) (parantumisen %) (sairastumisen %)