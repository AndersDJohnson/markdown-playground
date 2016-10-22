#include <assert.h>
void __VERIFIER_error(void) {
  assert(0);
}
unsigned int __VERIFIER_nondet_int_counter = 0;
int __VERIFIER_nondet_int(void) {
  switch (__VERIFIER_nondet_int_counter) {
    case 0: return 0;
  }
  ++__VERIFIER_nondet_int_counter;
  return 0;
}
