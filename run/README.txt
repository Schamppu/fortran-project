--- MAKEFILE: ---

Ohjelman voi suorittaa käyttämällä makefilea, joka toimii suorittamalla seuraavan komennon /src -kansiossa:

make disease

Ja ohjelman luomat tiedostot voi siivota kirjoittamalla:

make clean

--- MANUAALISET OHJEET: ---

Kansiosta löytyy output.csv, mikä esittää esimerkin ohjelman tuloksena saadusta tiedostosta.

Ohjelman voi suorittaa hakemiston /src-kansion README-ohjeiden mukaan, eli ensimmäisenä suorittamalla /src-kansiossa:

gfortran -c population.f90 utils.f90 disease.f90

gfortran population.o utils.o disease.o

Minkä jälkeen tuloksena saatu a.exe -tiedosto voidaan suorittaa seuraavalla komennolla:

./a.exe

--- KOMENTORIVIPARAMETRIT: ---

Ohjelmalle on myös mahdollista antaa komentorivikomentoja parametreiksi, jolloin ohjelma suoritetaan niiden perusteella kovakoodattujen
parametrien sijaan. Komennot tulee suorittaa /src kansiossa onnistuneen kääntämisen jälkeen, minkä voi tehdä edellämainituilla ohjeilla ja /src
kansion ohjeiden mukaan

Tämä onnistuu kääntämisen jälkeen esimerkiksi seuraavalla tavalla:

./a.exe 20 100 3000 40 0 3 60

Ohjelma vaatii tasan seitsemän komentoriviparametriä syötteeksi, ja niiden merkitys on seuraava:

./a.exe (N x N maailman koko) (maksimi aika-askeleet) (populaation määrä) (sairaiden määrä) (immuunien määrä) (parantumisen %) (sairastumisen %)