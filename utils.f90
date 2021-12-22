! Yleishyödyllisiä funktioita sisältävä moduuli
module utils
    use population
    implicit none
    contains
        ! Subroutine, joka printtaa kaikki ihmiset ja niiden tilan ja lopuksi kokonaistilastot
        subroutine printAllPops(popSize, popArray)
            implicit none
            ! Alustetaan muuttujat parametreista
            integer, intent(in) :: popSize
            type (person), intent(in) :: popArray(popSize)
            type (person) :: pop
            integer :: normal, sick, immune, i
            real :: normalPrc, sickPrc, immunePrc
            normal = 0
            sick = 0
            immune = 0
            ! Loopataan ja tulostetaan ja lasketaan kokonaisarvoja
            do i = 1, popSize
                pop = popArray(i)
                if (pop%id > 0) then
                    ! print "(a4, i3, a2, i3, a2, i3, a10, i3)", "ID:", pop%id, ", X:", pop%x, ", Y:", pop%y, ", STATUS: ", pop%health
                    ! print "(i4, i4, i4, i4)", pop%id, pop%x, pop%y, pop%health
                    if (pop%health == 0) then
                        normal = normal+1
                    else if (pop%health == 1) then
                        sick = sick+1
                    else if (pop%health == 2) then
                        immune = immune+1
                    end if
                end if
            end do

            ! Lasketaan prosentit
            normalPrc = (normal * 1.0) / (popSize * 1.0)
            sickPrc = sick / popSize
            immunePrc = immune / popSize

            !print "(a8, i3, a8, i3, a8, i3)", "Normal: ", normal, ", Sick: ", sick, ", Immune: ", immune
            print "(i4, a1, i4, a1, i4)", normal, ",", sick, ",", immune
            write(1, "(i4, a1, i4, a1, i4)") normal, ",", sick, ",", immune
        end subroutine printAllPops

        ! Komentorivikomentojen hakemisen funktio vikasietoisuudella höystettynä
        integer function getArg(indexValue)
            implicit none
            character(len=10) :: argument
            integer :: numb
            integer, intent(in) :: indexValue
            ! Kutsu getteriä
            call get_command_argument(indexValue, argument)
            read(argument, *, iostat=numb) getArg
            if (numb == 0) then
                ! Lue argumentit
                read(argument,*) getArg
            end if
        end function getArg
end module utils
