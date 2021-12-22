module person
    implicit none
    type :: person
        integer :: id, x, y, health
    end type person
    type (person) :: pop
    type (person), allocatable :: popArray(:)

    contains

   ! Ihmisen sairastuttaminen satunnaisesti
    type (person) function spreadDisease(pop, illProc, popSize)
        implicit none
        type (person), intent(in) :: pop
        type (person) :: checkPop ! Populaatiota tarkastaessa k�ytett�v� v�liaikaismuuttuja
        integer, intent(in) :: illProc, popSize
        ! Arvotaan henkil�lle x- ja y-koordinaatit
        real :: random
        integer :: prc, i = 0, isThereAnyoneSick = 0 ! isThereAnyoneSick asetetaan 1 jos l�ydet��n joku sairas samasta koordinaatista
        ! Arvotaan random lukua
        call random_number(random)
        ! Arvotaan jotain 0-100 v�lilt�
        prc = nint(100 * random)

        ! Alustetaan lokaalit muuttujat jotta siirtyy seuraavalle tyypille
        spreadDisease%id = pop%id
        spreadDisease%x = pop%x
        spreadDisease%y = pop%y
        spreadDisease%health = pop%health

        ! Loopataan l�pi kaikki ihmiset, mutta vain jos voidaan tarttua (eli health = 0)
        if (spreadDisease%health == 0) then
            do i = 1, popSize
                checkPop = popArray(i)
                ! Jos meill� on samassa koordinaatissa tyyppi jonka health on 1 (eli sairas), voidaan sairastua
                if (checkPop%x == spreadDisease%x .and. checkPop%y == spreadDisease%y &
                .and. checkPop%health == 1 ) then
                    isThereAnyoneSick = 1
                end if
            end do
        end if

        ! Jos voidaan sairastua, katsotaan miten aikaisemmin arvottu arpa meni
        if (isThereAnyoneSick == 1) then
            ! Arvottiinko alle raja-arvon, ja jos kyll�, sairastutaan
            if (prc < illProc) then
                spreadDisease%health = 1
            end if
        end if
    end function spreadDisease

    ! Ihmisen parantaminen satunnaisesti
    type (person) function healPerson(pop, healProc)
        implicit none
        type (person), intent(in) :: pop
        integer, intent(in) :: healProc
        ! Arvotaan henkil�lle x- ja y-koordinaatit
        real :: random
        integer :: prc

        ! Alustetaan lokaalit muuttujat jotta siirtyy seuraavalle tyypille
        healPerson%id = pop%id
        healPerson%x = pop%x
        healPerson%y = pop%y
        healPerson%health = pop%health

        ! Arvotaan random lukua
        call random_number(random)
        ! Arvotaan jotain 0-100 v�lilt�
        prc = nint(100 * random)
        ! Jos arvottu prosentti on pienempi kuin raja-arvo ja ihminen on sairas
        if (prc < healProc .and. healPerson%health == 1) then
            ! Parannetaan
            healPerson%health = 2
        end if
    end function healPerson

    ! Ihmisen liikuttaminen satunnaiseen suuntaan
    type (person) function movePerson(pop, gSize)
        implicit none
        integer :: move
        ! Otetaan ID funktion parametrist�
        type (person), intent(in) :: pop
        ! Ja gridin koko
        integer, intent(in) :: gSize
        real :: random
        ! ! ! ! ! integer :: x, y
        ! Alustetaan lokaalit muuttujat jotta siirtyy seuraavalle tyypille
        movePerson%id = pop%id
        movePerson%x = pop%x
        movePerson%y = pop%y
        movePerson%health = pop%health
        ! Random X ja Y, py�ristys nintill�
        call random_number(random)
        ! Arvotaan liikkumisen suunta
        move = nint(3 * random)
        ! Liikkuminen
        if (move == 0) then
            movePerson%x = movePerson%x+1 ! Liiku oikealle
        else if (move == 1) then
            movePerson%y = movePerson%y+1 ! Liiku alas
        else if (move == 2) then
            movePerson%x = movePerson%x-1 ! Liiku vasemmalle
        else if (move == 3) then
            movePerson%y = movePerson%y-1 ! Liiku yl�s
        end if

        ! Tarkista liikkumisen j�lkeen ollaanko liikuttu gridin yli, jos ollaan, flippaa
        if (movePerson%x < 0) then
            movePerson%x = gSize
        else if (movePerson%y < 0) then
            movePerson%y = gSize
        else if (movePerson%x > gSize) then
            movePerson%x = 0
        else if (movePerson%y > gSize) then
            movePerson%y = 0
        end if
    end function movePerson
end module person
