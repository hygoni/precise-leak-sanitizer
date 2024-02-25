#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define NUM_THREADS 1

// Function executed by the thread
void *thread_function(void *arg) {
  printf("Thread is running\n");
  // Do some work...
  printf("Thread is done\n");
  pthread_exit(NULL);
}

int main() {
  pthread_t threads[NUM_THREADS];
  int thread_args[NUM_THREADS];
  int result_code;

  // Create threads
  for (int i = 0; i < NUM_THREADS; ++i) {
    thread_args[i] = i;
    result_code = pthread_create(&threads[i], NULL, thread_function,
                                 (void *)&thread_args[i]);
    if (result_code) {
      fprintf(stderr, "Error: pthread_create failed with code %d\n",
              result_code);
      exit(EXIT_FAILURE);
    }
  }

  sleep(0);
  // Wait for threads to finish
  for (int i = 0; i < NUM_THREADS; ++i) {
    result_code = pthread_join(threads[i], NULL);
    if (result_code) {
      fprintf(stderr, "Error: pthread_join failed with code %d\n", result_code);
      exit(EXIT_FAILURE);
    }
    printf("Thread %d has finished\n", i);
  }

  return 0;
}
