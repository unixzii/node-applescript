#include <nan.h>
#include "osa.h"

using v8::String;
using v8::FunctionTemplate;
using Nan::Set;
using Nan::New;
using Nan::GetFunction;

NAN_MODULE_INIT(InitAll) {
  Set(target, New<String>("executeScript").ToLocalChecked(),
      GetFunction(New<FunctionTemplate>(OSAExecuteScript)).ToLocalChecked());
}

NODE_MODULE(applescript_2, InitAll)