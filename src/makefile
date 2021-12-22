mfile: population.o utils.o disease.o
	@gfortran -o mfile population.o utils.o disease.o

disease.o: disease.f90
	@gfortran -c disease.f90

population.o: population.f90
	@gfortran -c population.f90

utils.o: utils.f90
	@gfortran -c utils.f90

clean:
	@rm -rf *.o *.mod mfile

disease:
	@$(MAKE) mfile --no-print-directory
	@./mfile disease.o
	@$(MAKE) clean --no-print-directory
