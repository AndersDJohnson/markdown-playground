
extern void __assert_fail (const char *__assertion, const char *__file,
      unsigned int __line, const char *__function)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));
extern void __assert_perror_fail (int __errnum, const char *__file,
      unsigned int __line, const char *__function)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));
extern void __assert (const char *__assertion, const char *__file, int __line)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));

void __VERIFIER_error(void) {
  ((0) ? (void) (0) : __assert_fail ("0", "example-harness.c", 3, __PRETTY_FUNCTION__));
}
unsigned int __VERIFIER_nondet_int_counter = 0;
int __VERIFIER_nondet_int(void) {
  int ret;
  switch (__VERIFIER_nondet_int_counter) {
    case 0: ret = 0; break;
  }
  ++__VERIFIER_nondet_int_counter;
  return ret;
}
