#include "wtf/RunLoop.h"
#include "wtf/Vector.h"
#include <wtf/Threading.h>

int main() {

  WTF::initializeThreading();
  RunLoop::initializeMainRunLoop();

  RunLoop::main().dispatch([] {
    auto vec = Vector<int>::from(1, 2, 3, 4);
    printf("size from a runloop: %lu", vec.size());
  });

  return 0;
}
