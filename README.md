# Threads Alive

Basic non-preemptable threads package implementation

Patrick Andrews and George Gallo

---

## Installing
Simply run the following on OS X 9+ or Ubuntu 12.04+:
```
make
```
This generates test executables in `test/` and creates the
necessary shared object for the threads package. Run test files from the parent directory, e.g. `$ ./test/test01.out`

## API
## `ta_structs.h`
Contains lock, semaphore, conditional variable, and utility structures.

#### `tasem_t`
A semaphore. Contains the semaphore value, and a queue of threads
waiting on the semaphore.

#### `talock_t`
A lock. Implemented using only a `tasem_t`

#### `tacond_t`
A conditional variable.

## `threadsalive.h`
Contains methods for utilizing semaphores, locks, and conditional variables.

### Semaphore

#### `void ta_sem_init(tasem_t *sema, int value)`
Initialize the semaphore `sema` with the number of available
resources set to `value`.

#### `void ta_sem_destroy(tasem_t *sema)`
Destroy the semaphore `sema`, freeing it's thread queue and
setting a flag if there are threads left on the queue.

#### `void ta_sem_signal(tasem_t *sema)`
Free one `sema` resource, and, if there were no free resources
before freeing, put one thread on the ready queue.

#### `void ta_sem_wait(tasem_t *sema)`
Consume one `sema` resource, then block the current execution context if all resources are now consumed.

### Lock

#### `void ta_lock_init(talock_t *lock)`
Initialize `lock`, which is an abstraction for a binary
semaphore.

#### `void ta_lock_destroy(talock_t *lock)`
Destroy `lock`. Should only be used once threads are done
using the resource in question.

#### `void ta_lock(talock_t *lock)`
Obtain `lock`. Like a semaphore `P()` method, the executing
thread blocks if another thread holds the lock.

#### `void ta_unlock(talock_t *lock)`
Release `lock`. Like a semaphore `V()` method, the executing
thread unblocks to allow any waiting threads an opportunity to
use the resource.

### Conditional variable

#### `void ta_cond_init(tacond_t *cond)`
Initialize the conditional variable `cond` with a new
queue.

#### `void ta_cond_destroy(tacond_t *cond)`
Destroy `cond` by freeing its queue and all threads
therein.

#### `void ta_wait(tacond_t *cond, talock_t *lock)`
Release `lock`, then immediately block the current
thread and have it wait on `cond`. As best practice,
the current thread should be holding `lock`. This
method will release it for you.

#### `void ta_signal(tacond_t *cond)`
Signal the next thread waiting on `cond`, if any.

### Thread

#### `void ta_create(void (*func)(void*), void* arg)`
Create a new thread context, which will run `func` with
argument `arg` when prompted.

#### `void ta_yield()`
Yield to the next thread in the queue.

#### `void ta_waitall()`
Sequentially run all threads created by `ta_create`.
