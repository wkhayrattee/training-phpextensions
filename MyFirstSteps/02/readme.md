# About

- this repo is based on the tutorial of SaraMG who is currently my mentor for "how to create PHP Extension from Scratch"
- Her repo: https://github.com/sgolemon/2016-sfmeetup

## This Commit Layer

- Hash: f7a842b Add hello_world() function

### ZEND\_GET\_MODULE(hello)

This macro, a small piece of boilerplate included in every PHP extension, evaluates to roughly the following:

```
zend_module_entry *get_module() {
  return &hello_module_entry;
}
```

This gives the engine a predictable symbol name to look for in the shared library built by the process outlined in step 1.  The engine invokes this function to return a pointer to the `zend_module_entry` struct.

### zend\_module\_entry

The `zend_module_entry` named conformantly as `hello_module_entry` represents the front door (or "entry" point) to your extension.  Everything that PHP knows about your extension is contained in this one structure (and through its callback).

* `STANDARD_MODULE_HEADER`: This define covers several build identifiers including the `PHP_API_VERSION` and `ZEND_MODULE_API` constants you heard about last version.  By storing these values at build time, the runtime engine can verify that they match its expectations.  Mismatching numbers can indicate ABI incompatability, and the runtime will exit early asking you to rebuild your extenson for this PHP branch.  If we get into module dependencies, we may replace this with `STANDARD_MODULE_HEADER_EX` and some `MOD_DEP` macros, but not yet.
* `name`: The next field is a simple `const char*` where the official name of the extension lives.  This should match the name used with the `ZEND_GET_MODULE` macro, the name in `config.m4` and everywhere else.  This name will be presented in `php -m` output and corresponds to `extension_loaded()` and `ReflectionExtension` APIs.
* `function_list`: This member takes a pointer to a c-array of `zend_module_entry`s. See below...
* `MINIT`, `MSHUTDOWN`: The next two pointer slots are for the process startup and shutdown callbacks.  These are invoked once per process and are meant for performing persistent setup and teardown.  We'll implement some of this later.
* `RINIT`, `RSHUTDOWN`: These are the per-request versions of the two above callbacks.  These are invoked on *EVERY* request and act somewhat like `auto_prepend_file` and `auto_append_file`, but for C code.
* `MINFO`: The next callback pointer is invoked during calls to `phpinfo();` or `php -i` from the command line.  We probably won't cover this explicitly, but you can check out other extensions and look in [ext/standard/info.h](https://github.com/php/php-src/blob/master/ext/standard/info.h) for the available APIs to using an in MINFO callback.
* `NO_VERSION_YET`: This is another simple `const char*` parameter for putting a human readable version string to identify your extension.  This is purely for introspection using `ReflectionExtension`, and you can fill in any value you're like.
* `STANDARD_MODULE_PROPERTIES`: Like the HEADER variant, this fills in some boilerplate and you can largely ignore it.  When we start to look at module globals, this macro will be replaced with `STANDARD_MODULE_PROPERTIES_EX` and some GINIT/GSHUTDOWN and other pointers.

### hello\_functions[]

All global functions defined by your extension are exported by a c-array structure listing `zend_module_entry` values.  These struct values are, in turn, produced using macros such as `PHP_FE` (and many variations thereof).

For the `PHP_FE()` macro, the arguments are as follows:

1. Function name: This is both the script-exposed name of the function, and the name used for the implementation elsewhere in your file.
2. Argument Info: Internal functions have their own means of parsing arguments, so in order to present reflection info, we provide an (optional) pointer to an `arginfo` structure.  We'll look at this in later steps, for now we leave it as `NULL` to indicate that we're not providing reflection info.

### PHP\_FUNCTION(hello\_world)

This is the actual implementation of your userspace exported function.  The provided macro expands to a standard C function definition, in this case: 

```
void zif_hello_world(zend_execute_data *execute_data, zval *return_value)
```

`zif` stands for "Zend Internal Function" and the provided parameters will be quietly used by various macros in your function implementation.  It's not important for you to know the above expansion, but it turns out I'm quite verbose when I'm sitting in an airport terminal.

The function body we have in this simple example is as basic as they come.  The `php_printf` function is essentially the same as stdio's `printf`, with the exception that it routes output to the SAPI layer instead of the process stdout.  In the case of CLI these are the same, but in the case of a webserver, this may be a network socket.

## My Questions

1. With regards to `STANDARD_MODULE_HEADER`, what are the scenarios when a ***STANDARD_MODULE_HEADER*** can occur?
2. What's the meaning of **ABI**?
3. Where is the `PHP_FE` defined so I can see it's full definition?

## My Observations



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
