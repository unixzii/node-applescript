#include <Foundation/Foundation.h>
#include <nan.h>
#include "osa.h"

using v8::Object;
using v8::Function;
using v8::Number;
using v8::Local;
using v8::Value;
using v8::String;
using v8::Exception;
using Nan::AsyncQueueWorker;
using Nan::AsyncWorker;
using Nan::Callback;
using Nan::HandleScope;
using Nan::Utf8String;
using Nan::New;
using Nan::Null;

#define RELEASE_IF_NONZERO(x) if ((x)) delete x
#define COPY_OBJC_STRING(x, y) do { \
  const char *tmp = [x cStringUsingEncoding:NSUTF8StringEncoding]; \
  y = std::string(tmp); \
} while (0)

class OSAWorker : public AsyncWorker {
  std::string _script;
  std::string _errorMessage;
  std::string _errorBriefMessage;
  short _errorNumber;
  std::string _resultString;

  public:
    OSAWorker(std::string script, Callback *callback)
      : AsyncWorker(callback), _script(script) {}
    ~OSAWorker() {}

    void Execute() {
      NSString *scriptNSString = [[[NSString alloc] initWithCString:_script.c_str() encoding:NSUTF8StringEncoding] autorelease];
      NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
      NSDictionary<NSString *, id> *error = 0;
      NSAppleEventDescriptor *aed = [[[NSAppleScript alloc] initWithSource:scriptNSString] executeAndReturnError:&error];

      if (error) {
        NSString *errorMessage = [error objectForKey:NSAppleScriptErrorMessage];
        NSString *errorBriefMessage = [error objectForKey:NSAppleScriptErrorBriefMessage];
        _errorNumber = [[error objectForKey:NSAppleScriptErrorNumber] shortValue];

        if (errorMessage)
          COPY_OBJC_STRING(errorMessage, _errorMessage);
        else
          _errorMessage = "Unknown internal error.";
        if (errorBriefMessage)
          COPY_OBJC_STRING(errorBriefMessage, _errorBriefMessage);

        SetErrorMessage(_errorMessage.c_str());
      } else {
        NSString *resultString = [aed stringValue];
        if (resultString)
          COPY_OBJC_STRING(resultString, _resultString);
      }

      [pool release];
    }

    void HandleOKCallback() {
      HandleScope scope;

      Local<Value> argv[] = {
        Null(),
        New<String>(_resultString.c_str()).ToLocalChecked()
      };

      callback->Call(2, argv);
    }

    void HandleErrorCallback() {
      HandleScope scope;

      Local<Object> errorObj = New<Object>();

      errorObj->Set(New<String>("errorMessage").ToLocalChecked(),
                    New<String>(_errorMessage.c_str()).ToLocalChecked());
      errorObj->Set(New<String>("errorBriefMessage").ToLocalChecked(),
                    New<String>(_errorBriefMessage.c_str()).ToLocalChecked());
      errorObj->Set(New<String>("errorNumber").ToLocalChecked(), New<Number>(_errorNumber));

      Local<Value> argv[] = {
        Exception::TypeError(New<String>(_errorMessage.c_str()).ToLocalChecked()),
        errorObj
      };

      callback->Call(2, argv);
    }
};

NAN_METHOD(OSAExecuteScript) {
  const char *script = *Utf8String(info[0].As<String>());

  Callback *callback = new Callback(info[1].As<Function>());
  AsyncQueueWorker(new OSAWorker(script, callback));
}