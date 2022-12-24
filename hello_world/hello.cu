#include <stdio.h>
#include <cuda_runtime.h>

__global__ void kernel(int *a, int N) {
  for (int i=0; i<N; i++) {
    *a += i;
  }
}

void device_code(int *a, int N) {
  for (int i=0; i<N; i++) {
    *a += i;
  }
}

int main() {
  int *a, *d_a, N;
  N = 1000000000;
  a = (int*)malloc(sizeof(int));
  *a = 2;

  cudaMalloc((void **)&d_a, sizeof(int));
  cudaMemcpy(d_a, a, sizeof(int), cudaMemcpyHostToDevice);
  kernel<<<1, 1>>>(d_a, N);
  //device_code(a, N);

  cudaMemcpy(a, d_a, sizeof(int), cudaMemcpyDeviceToHost);
  printf("the number is: %d\n", *a);

  cudaFree(d_a);
  free(a);
  return 0;
}
