#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main() {
  int secret_number, guess, tries = 0;
  srand(time(NULL));
  secret_number = rand() % 100 + 1; // Generate a random number between 1 and 100
  printf("I'm thinking of a number between 1 and 100. Can you guess what it is?\n");

  do {
    printf("Enter your guess: ");
    scanf("%d", &guess);
    tries++;
    if (guess > secret_number) {
      printf("Too high! Try again.\n");
    } else if (guess < secret_number) {
      printf("Too low! Try again.\n");
    }
  } while (guess != secret_number);

  printf("Congratulations, you guessed the secret number %d in %d tries!\n", secret_number, tries);
  return 0;
}
