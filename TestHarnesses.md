## Violation Witnesses as Declarative Test Harnesses

A test vector is a sequence of input values provided to a system in order to test that system.
A verification tool that detects a feasible concrete path through a system to a specification violation often can provide a test vector such that testing the system with these input values triggers the dected bug.
The exchange format for witnesses can be used to express test vectors in the form of declarative test harnesses.
A witness validator may transform such a declarative test harness into an imperative test harness in the input language, and then compile and link the original source code against it.
If running the resulting executable triggers the bug, the witness is valid.
This executable can then directly be inspected by the developers using a debugger to reproduce and understand the bug in their own system.

### Requirements

A violation witness must fulfill the following requirement to qualify as a test vector:
For each input into the system along the path to be tested, the witness must provide a concrete value.

### Example

The following example conforms to the format used in the [International Competition on Software Verification (SV-COMP)](https://sv-comp.sosy-lab.org/), where the function ``extern int __VERIFIER_nondet_int(void)`` is used to obtain nondeterministic input values and the specification ``CHECK( init(main()), LTL(G ! call(__VERIFIER_error())) )`` states that a correct program must never call the function ``extern int __VERIFIER_error(void)``.

Consider the following [C program](example.i) (``example.i``):

```C
extern void __VERIFIER_error(void);
extern int __VERIFIER_nondet_int(void);
int main() {
  unsigned int x = 1;
  while(__VERIFIER_nondet_int()) {
    x = x + 2;
  }
  if (x >= 1) __VERIFIER_error ();
}
```
Obviously, ``x`` is always greater than or equal to ``1``, and the shortest path to the violation of the specification skips the loop immediately if the first call to the input function ``extern int __VERIFIER_nondet_int(void)`` evaluates to ``0``.
The following [violation witness](example-witness.graphml) (``example-witness.graphml``) for this verification task qualifies as a declarative test harness by providing the test vector for the shortest error path:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<graphml xmlns="http://graphml.graphdrawing.org/xmlns" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <key attr.name="isEntryNode" attr.type="boolean" for="node" id="entry">
  <default>false</default>
 </key>
 <key attr.name="isViolationNode" attr.type="boolean" for="node" id="violation">
  <default>false</default>
 </key>
 <key attr.name="enterLoopHead" attr.type="boolean" for="edge" id="enterLoopHead">
  <default>false</default>
 </key>
 <key attr.name="witness-type" attr.type="string" for="graph" id="witness-type"/>
 <key attr.name="sourcecodelang" attr.type="string" for="graph" id="sourcecodelang"/>
 <key attr.name="producer" attr.type="string" for="graph" id="producer"/>
 <key attr.name="specification" attr.type="string" for="graph" id="specification"/>
 <key attr.name="programFile" attr.type="string" for="graph" id="programfile"/>
 <key attr.name="programHash" attr.type="string" for="graph" id="programhash"/>
 <key attr.name="memoryModel" attr.type="string" for="graph" id="memorymodel"/>
 <key attr.name="architecture" attr.type="string" for="graph" id="architecture"/>
 <key attr.name="startline" attr.type="int" for="edge" id="startline"/>
 <key attr.name="assumption" attr.type="string" for="edge" id="assumption"/>
 <key attr.name="assumption.scope" attr.type="string" for="edge" id="assumption.scope"/>
 <key attr.name="assumption.resultfunction" attr.type="string" for="edge" id="assumption.resultfunction"/>
<graph edgedefault="directed">
  <data key="witness-type">violation_witness</data>
  <data key="sourcecodelang">C</data>
  <data key="producer">CPAchecker 1.6.1-svn</data>
  <data key="specification">CHECK( init(main()), LTL(G ! call(__VERIFIER_error())) )</data>
  <data key="programfile">example.i</data>
  <data key="programhash">1776ed2413d170f227b69d8c79ba700d31db6f75</data>
  <data key="memorymodel">precise</data>
  <data key="architecture">32bit</data>
  <node id="entry">
   <data key="entry">true</data>
  </node>
  <node id="error">
   <data key="violation">true</data>
  </node>
  <edge source="entry" target="error">
   <data key="startline">5</data>
   <data key="assumption">\result == 0</data>
   <data key="assumption.scope">main</data>
   <data key="assumption.resultfunction">__VERIFIER_nondet_int</data>
  </edge>
 </graph>
</graphml>
```

A witness validator may now produce a [test harness](example-harness.c) (``example-harness.c``):

```C
#include <assert.h>
void __VERIFIER_error(void) {
  assert(0);
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
```

Now, an executable can be produced by running ``gcc example.i example-harness.c -o example``.
Running ``./example`` immediately shows the failing assertion:

``example: example-harness.c:3: __VERIFIER_error: Assertion `0' failed.``

If the validator is trusted, this indicates that even if the witness ``example-witness.graphml`` is valid even if was obtained from an untrusted source.
If the executable ``example`` or the imperative test harness ``example-harness.c`` were obtained directly from the untrusted source, no such guarantee about the validity would be possible without laborious manual inspection, because the executable may have been produced from altered source code, or imperative the test harness may itself violate the specification.
