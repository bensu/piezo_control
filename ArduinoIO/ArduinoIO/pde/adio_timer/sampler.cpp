#include "sampler.h"

void Sampler::add_sample(int new_val) {
  samples[index] = new_val;
  index = (index+1)%N_SAMPLES;
}

int Sampler::take_sample(void) {
  // Loops circularly for all values
  long int sum = 0;
  for(int i=0; i < N_SAMPLES; i++) {
    sum += samples[i];
  }
  return sum/N_SAMPLES;
}

Sampler::Sampler(void) {
  // Initialices with all ceros
  for(int i=0; i < N_SAMPLES; i++) {
    samples[i] = 0;
  }
}