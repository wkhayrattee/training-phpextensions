# About

- this repo is based on the tutorial of SaraMG who is currently my mentor for "how to create PHP Extension from Scratch"
- Her repo: https://github.com/sgolemon/2016-sfmeetup

## Returning values

This commit only adds two small functions to the extension which return a `\0` null terminated C string and a zend\_long.

These macros populate the local `return_value` parameter mentioned in the last section as an output value.  Unwound, the `RETURN_LONG(x)` macro, specifically, looks a little like this (psuedo-code):

```
return_value->type = IS_LONG;
return_value->value.lval = x;
return;
```

That is, it gives the `zval`, which is a variant value holder, a PHP related data type and an associated value.  The `RETURN_STRING` macro is slightly more complicated, due to the need to allocate extra memory, but it and all other `RETURN_*` macros are essentially the same.

## zvals

The core data storage unit of PHP is known as a `zval`, or Zend Value.  In PHP 7 this structure holds two salient properties, an integer type mapping to PHP datatypes, and a union of C type members to hold the `type` dependent value.  In reality there are additional fields inside the `zval`, however they are never accessed directly by extension code, and can be safely ignored.

The table below shows the list of `zval` data types, their related C types, and a brief note on their use.

type | value | Notes
-- | -- | --
 `IS_UNDEF` | N/A | An engine-only type to indicate that a variable has not yet been initialized.  This can be thought of as similar to `IS_NULL`, however extensions should _NEVER_ return `IS_UNDEF` values back to scripts.
 `IS_NULL` | N/A | `null`
 `IS_TRUE` | N/A | `true` Note that, despite how thing may appear from script code, `true` and `false` are distinct types within PHP 7.
 `IS_FALSE` | N/A | `false`
 `IS_LONG` | `zend_long` | 32 or 64bit signed integer. System dependent.
 `IS_DOUBLE` | `double` | IEE double-precision floating point number.
 `IS_STRING` | `zend_string*` | Binary safe string.
 `IS_ARRAY` | `zend_array*` | Array type. Also referred to as a `HashTable*`. These types are aliases for each other.
 `IS_OBJECT` | `zend_object*` | Object type. The object instance itself contains references to its class definition and vtable.
 `IS_RESOURCE` | `zend_resource*` | Legacy resource type. Discouraged.
 `IS_REFERENCE` | `zend_reference*` | User-space concept of a reference. This is... an advanced topic for later.

You've already seen the `RETURN_LONG` and `RETURN_STRING` macros for those types, unsurprisingly there are similar macros for other types.

type | macro
-- | --
`IS_UNDEF` | No macro, never return undef values.
`IS_NULL` | `RETURN_NULL()`
`IS_TRUE` | `RETURN_TRUE` or `RETURN_BOOL(1)`
`IS_FALSE` | `RETURN_FALSE` or `RETURN_BOOL(0)`
`IS_LONG` | `RETURN_LONG(lval)`
`IS_DOUBLE` | `RETURN_DOUBLE(dval)`
`IS_STRING` | `RETURN_STRING(nullTerminatedStr)` or `RETURN_STRINGL(str, len)`

Notice the lack of macros for Arrays, Resources, and Objects?  These are just too complex to encapsulate in simple macros.  For these types, we'll access the `return_value` variable directly. We'll go into how to do that in later sections.

Side note: Strings also have a `RETURN_STR` macro which, instead of taking a `const char*` (and `size_t` length), accept a pre-allocated `zend_string*`.  This is often useful when returning values which don't correspond to literals or return values form POSIX functions.  We'll show an example of this later.

In addition to the `RETURN_*()` family of macros, there are matching `RETVAL_*()` macros for when you want to store the return value before actually leaving the function body.  Typically this is used to clean up some temporary value.  Think of it as the `RETURN_*()` version, without the `return;`

Because PHP loves macros, there's a THIRD variant of these called prefixed by `ZVAL`.  Here, you supply the `zval*` pointer to store the data into, rather than using the fixed `return_value` output parameter.  So for example, the following three invocations are identical.

```
RETURN_LONG(42);

RETVAL_LONG(42); return;

ZVAL_LONG(return_value, 42); return;
```

These macros are all implemented in [Zend/zend\_API.h](https://github.com/php/php-src/blob/master/Zend/zend_API.h).

## This Commit Layer

- Hash: 9ed889a Return some values

## My Questions

- Trivial question probably, why is it that in observation #4 below, the output is `42#` with a hash after the 42?

## My Observations

1. OUTPUT when I executed `$ php -d extension=$PWD/modules/hello.so --re hello`
    > Extension [ <persistent> extension #70 hello version <no_version> ] {
       - Functions {
         Function [ <internal:hello> function hello_world ] {
         }
         Function [ <internal:hello> function hello_return ] {
         }
         Function [ <internal:hello> function hello_number ] {
         }
       }
     }
    
2. OUTPUT when I executed `$ php -d extension=$PWD/modules/hello.so -r 'hello_world();'`
    > Hello World!

3. OUTPUT when I executed `$ php -d extension=$PWD/modules/hello.so -r 'echo hello_return();'`
    > Hello World!
    
4. OUTPUT when I executed `$ php -d extension=$PWD/modules/hello.so -r 'echo hello_number();'`
    > 42#

# Total Repo Objectives

```
* ae91dd4 (HEAD, origin/master, origin/HEAD, master) Teach Hello\Curl to do something useful
* bb1c920 Give Hello\Curl some custom storage
* 965f28c Add Hello\Curl class skeleton
* 4b0bcb4 Declare HELLO_CURL constnat
* 75d9042 Detect libcurl and link if available
* fcd7760 Add a function returning an array
* de1578f Take multiple args, iterate an array
* 5ff9cd7 Accept a string
* 9ed889a Return some values
* f7a842b Add hello_world() function
* 6a4bd97 Bare Minimum
```
