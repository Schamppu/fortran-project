program disease
    use population
    use utils
    implicit none
    ! Luodaan muuttuja pop joka on person-tyyppi�
    type (person) :: pop
    ! Luodaan my�s array tyypeille
    type (person), allocatable :: popArray(:)
    ! Alustetaan taulu, mihin voidaan luoda person-tyyppej�
    ! type (person), allocatable :: populationArray(:)
    ! Alustetaan kokonaislukumuuttujat
    integer :: gridSize, timeMax, populationCount, idCounter, sickAmount, immuneAmount, i = 0, a = 0, time = 0
    integer :: healingPrc, illnessPrc, argumentCount
    logical :: fileExist
    ! Otetaan command line argumenttien m��r�
    argumentCount = command_argument_count()

    ! Asetetaan oletusmuuttujat ennen komentorivilt� muuttujien lataamista
    ! Parametri simulaation maailma koolle (N * N)
    gridSize = 100
    ! Ohjelman ajamisen pituus askelina, eli kuinka pitk��n simulaatiota suoritetaan
    timeMax = 100
    ! Populaation m��r�
    populationCount = 1000
    ! Alkuper�isten sairastuneitten m��r�
    sickAmount = 15
    ! Alkuper�isten immuunien m��r�
    immuneAmount = 0
    ! Parantumisen todenn�k�isyys (prosenttiyksikk��) jokaisen aika stepin tarkistuksessa
    healingPrc = 3
    ! Sairastumisen todenn�k�isyys (prosenttiyksikk��) jokaisen aika stepin tarkistuksessa
    illnessPrc = 90

    ! Tulostukset ohjelman k�ynnist�miselle
    print *, "Welcome to the Disease Simulator!"

    ! Jos argumenttien m��r� on oikea
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

    ! Alustetaan person-tyyppej� sis�lt�v� popArray
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

    ! K�yd��n silmukassa l�pi aikaa ja kirjoitetaan samalla output.csv tiedostoon
    do time = 1, timeMax
        print "(a7,i3)", "#Step: ", time
        call moveAllPops(populationCount, gridSize, healingPrc, illnessPrc)
        call printAllPops(populationCount, popArray)
        !print *, "----------"
    end do

    contains
        ! Arrayn alustusfunktio, mill� voidaan luoda array jossa on parametrin� saatu koko, kun fortissa ei pysty muuten muuttaa arrayn kokoa...
        function allocateNewPopArray(popSize) result (tempArray)
            implicit none
            ! Otetaan parametrin� saatu populaation m��r�
            integer, intent(in) :: popSize
            ! Alustetaan pop muuttuja
            type (person) :: pop
            ! Alustetaan uusi array jonka syvyys on populaation koko
            type (person), dimension(popSize) :: tempArray
            pop = person(-1,-1,-1,-1)
            tempArray = pop
        end function allocateNewPopArray

        ! Uuden ihmisen lis��minen
        type (person) function addNewPerson(id)
            implicit none
            ! Otetaan ID funktion parametrist�
            integer, intent(in) :: id
            ! X ja Y koordinaatit sek� health-alustus
            integer :: x, y, health
            ! Health toimii n�in:
            ! 0 = normaali
            ! 1 = sairas
            ! 2 = immuuni
            ! Arvotaan henkil�lle x- ja y-koordinaatit
            real :: random
            ! Random X ja Y, py�ristys nintill�
            call random_number(random)
            x = nint(gridSize * random)
            call random_number(random)
            y = nint(gridSize * random)
            ! Asetetaan aluksi terveydeksi normaali
            health = 0
            if (id < sickAmount+1) then
                ! Mik�li id on pienempi kuin sairaiden m��r�, muutetaan sairaaksi
                health = 1
            end if
            if (id > populationCount-immuneAmount) then
                ! Mik�li id on suurempi kuin pop count - immune amount, muutetaan immuuniksi
                health = 2
            end if
            ! Returniin uusi person
            addNewPerson = person(id, x, y, health)
        end function addNewPerson

        ! Subroutine, joka liikuttaa kaikkia ihmisi� satunnaiseen suuntaan
        subroutine moveAllPops(popSize, gridSize, healingPrc, illnessPrc)
            implicit none
            integer :: i = 0
            ! Otetaan parametrin� saatu populaation m��r�
            integer, intent(in) :: popSize, gridSize, healingPrc, illnessPrc
            ! Alustetaan t�nnekin array population sizell�, jotta toimii koska tyh�m ohjelmointikieli
            type (person) :: pop
            ! Menn��n l�pi loopissa kaikki ihmiset
            do i = 1, popSize
                ! print *, "Move..."
                ! Ladataan v�liaikaismuuttujaan tyyppi
                pop = popArray(i)
                ! Liikutetaan tyyppi�
                pop = movePerson(pop, gridSize)
                ! Sairastutetaan tyyppi�
                pop = spreadDisease(pop, popArray, illnessPrc, popSize)
                ! Parannetaan tyyppi�
                pop = healPerson(pop, healingPrc)
                ! Ladataan takaisin oikeaan arrayhin
                popArray(i) = pop
            end do
        end subroutine moveAllPops
end program disease
