#ifndef _SAMPLER_

#define _SAMPLER_ 1
#define N_SAMPLES 100

class Sampler {
public:
  Sampler(void);
  void add_sample(int new_val);
  int take_sample(void);
private:
  int samples[N_SAMPLES];
  int index;
};

#endif