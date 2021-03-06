TESTS = 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15
OPTS = -Wall -Wno-unused-function -g -fPIC -Wno-deprecated-declarations

testall: libthreadsalive.so
	$(foreach var, $(TESTS), gcc -o test/test$(var).out test/test$(var).c -L. -lthreadsalive -g;)
	rm -rf test/*.dSYM

queue.o: queue.c queue.h ta_structs.h
	gcc -c queue.c ${OPTS}

sema_queue.o: sema_queue.c sema_queue.h ta_structs.h
	gcc -c sema_queue.c ${OPTS}

threadsalive.o: threadsalive.c threadsalive.h ta_structs.h
	gcc -c threadsalive.c ${OPTS}

libthreadsalive.so: threadsalive.o sema_queue.o queue.o
	gcc -o libthreadsalive.so threadsalive.o sema_queue.o queue.o -Wall -g -shared

clean:
	rm -f test_threads
	rm -f *~
	rm -f \#*
	rm -f *.o
	rm -f *.so
	rm -rf *.dSYM
	rm -rf test/*.dSYM
	rm -r test/*.out
