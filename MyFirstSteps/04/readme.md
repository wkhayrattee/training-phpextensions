# About

- this repo is based on the tutorial of SaraMG who is currently my mentor for "how to create PHP Extension from Scratch"
- Her repo: https://github.com/sgolemon/2016-sfmeetup

## This Commit Layer

- Hash: 5ff9cd7 Accept a string

## My Questions

1. **In `size_t name_len;` why do we use `size_t` instead of `int`?**
    > As per [my reading][link size_t stackoverflow], `size_t` can hold any array index, is used when the variable cannot represent any negative values and when the variable can be any of __unsigned \[Char|Short|int|long\]__..etc - not sure if that is the reason
2. Why use `size_t` with PHP 7 and not PHP 5 and vice-versa

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

[link size_t stackoverflow]: https://stackoverflow.com/questions/2550774/what-is-size-t-in-c
