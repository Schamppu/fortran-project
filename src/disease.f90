program disease
    use population
    use utils
    implicit none
    ! Luodaan muuttuja pop joka on person-tyyppiä
    type (person) :: pop
    ! Luodaan myös array tyypeille
    type (person), allocatable :: popArray(:)
    ! Alustetaan taulu, mihin voidaan luoda person-tyyppejä
    ! type (person), allocatable :: populationArray(:)
    ! Alustetaan kokonaislukumuuttujat
    integer :: gridSize, timeMax, populationCount, idCounter, sickAmount, immuneAmount, i = 0, a = 0, time = 0
    integer :: healingPrc, illnessPrc, argumentCount
    logical :: fileExist
    ! Otetaan command line argumenttien määrä
    argumentCount = command_argument_count()

    ! Asetetaan oletusmuuttujat ennen komentoriviltä muuttujien lataamista
    ! Parametri simulaation maailma koolle (N * N)
    gridSize = 100
    ! Ohjelman ajamisen pituus askelina, eli kuinka pitkään simulaatiota suoritetaan
    timeMax = 100
    ! Populaation määrä
    populationCount = 1000
    ! Alkuperäisten sairastuneitten määrä
    sickAmount = 15
    ! Alkuperäisten immuunien määrä
    immuneAmount = 0
    ! Parantumisen todennäköisyys (prosenttiyksikköä) jokaisen aika stepin tarkistuksessa
    healingPrc = 3
    ! Sairastumisen todennäköisyys (prosenttiyksikköä) jokaisen aika stepin tarkistuksessa
    illnessPrc = 90

    ! Tulostukset ohjelman käynnistämiselle
    print *, "Welcome to the Disease Simulator!"

    ! Jos argumenttien määrä on oikea
    if (argumentCount == 7) then
        print *, "Seven command line arguments given! Using them as program parameters."
        gridSize = getArg(1)
        timeMax = getArg(2)
        populationCount = getArg(3)
        sickAmount = getArg(4)
        immuneAmount = getArg(5)
        healingPrc = getArg(6)
        illnessPrc = getArg(7)
    else
        print *, "TIP: You can use command line arguments to run the program. Give integers in the following order: &
        Grid Size, Maximum Time, Population Count, Initial Sick Amount, Initial Immune Amount, Healing Chance, Illness Chance"
    end if

    print "(a12, i4, a28, i4, a20, i4, a25, i4, a25, i4)", "Grid Size: ", gridSize, ", Simulation time (steps): ", timeMax, &
    ", Population count: ", populationCount, ", Initial sick amount: ", sickAmount, ", Initial immune amount:", immuneAmount
    print *, "Press Enter to begin the simulation."
    read(*,*)
    print *, "Simulation begins!"
    print *, "----------"

    ! Alustetaan person-tyyppejä sisältävä popArray
    popArray = allocateNewPopArray(populationCount)

    ! Luodaan ihmiset tauluun loopissa
    do i = 1, populationCount
        ! print *, "Add pop..."
        pop = addNewPerson(i)
        popArray(i) = pop
    end do

    inquire(file="output.csv", exist=fileExist)
    if (fileExist) then
        open(1, file = "output.csv", status = "old")
        write (1, *) "Normal, Sick, Immune"
    else
        open(1, file = "output.csv", status = "new")
        write (1, *) "Normal, Sick, Immune"
        do time = 1, timeMax
            call moveAllPops(populationCount, gridSize, healingPrc, illnessPrc)
            call printAllPops(populationCount, popArray)
            !print *, "----------"
        end do
        close(1)
    end if

    ! Käydään silmukassa läpi aikaa ja kirjoitetaan samalla output.csv tiedostoon
    do time = 1, timeMax
        print "(a7,i3)", "#Step: ", time
        call moveAllPops(populationCount, gridSize, healingPrc, illnessPrc)
        call printAllPops(populationCount, popArray)
        !print *, "----------"
    end do

    contains
        ! Arrayn alustusfunktio, millä voidaan luoda array jossa on parametrinä saatu koko, kun fortissa ei pysty muuten muuttaa arrayn kokoa...
        function allocateNewPopArray(popSize) result (tempArray)
            implicit none
            ! Otetaan parametrinä saatu populaation määrä
            integer, intent(in) :: popSize
            ! Alustetaan pop muuttuja
            type (person) :: pop
            ! Alustetaan uusi array jonka syvyys on populaation koko
            type (person), dimension(popSize) :: tempArray
            pop = person(-1,-1,-1,-1)
            tempArray = pop
        end function allocateNewPopArray

        ! Uuden ihmisen lisääminen
        type (person) function addNewPerson(id)
            implicit none
            ! Otetaan ID funktion parametristä
            integer, intent(in) :: id
            ! X ja Y koordinaatit sekä health-alustus
            integer :: x, y, health
            ! Health toimii näin:
            ! 0 = normaali
            ! 1 = sairas
            ! 2 = immuuni
            ! Arvotaan henkilölle x- ja y-koordinaatit
            real :: random
            ! Random X ja Y, pyöristys nintillä
            call random_number(random)
            x = nint(gridSize * random)
            call random_number(random)
            y = nint(gridSize * random)
            ! Asetetaan aluksi terveydeksi normaali
            health = 0
            if (id < sickAmount+1) then
                ! Mikäli id on pienempi kuin sairaiden määrä, muutetaan sairaaksi
                health = 1
            end if
            if (id > populationCount-immuneAmount) then
                ! Mikäli id on suurempi kuin pop count - immune amount, muutetaan immuuniksi
                health = 2
            end if
            ! Returniin uusi person
            addNewPerson = person(id, x, y, health)
        end function addNewPerson

        ! Subroutine, joka liikuttaa kaikkia ihmisiä satunnaiseen suuntaan
        subroutine moveAllPops(popSize, gridSize, healingPrc, illnessPrc)
            implicit none
            integer :: i = 0
            ! Otetaan parametrinä saatu populaation määrä
            integer, intent(in) :: popSize, gridSize, healingPrc, illnessPrc
            ! Alustetaan tännekin array population sizellä, jotta toimii koska tyhäm ohjelmointikieli
            type (person) :: pop
            ! Mennään läpi loopissa kaikki ihmiset
            do i = 1, popSize
                ! print *, "Move..."
                ! Ladataan väliaikaismuuttujaan tyyppi
                pop = popArray(i)
                ! Liikutetaan tyyppiä
                pop = movePerson(pop, gridSize)
                ! Sairastutetaan tyyppiä
                pop = spreadDisease(pop, popArray, illnessPrc, popSize)
                ! Parannetaan tyyppiä
                pop = healPerson(pop, healingPrc)
                ! Ladataan takaisin oikeaan arrayhin
                popArray(i) = pop
            end do
        end subroutine moveAllPops
end program disease
