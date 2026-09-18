load("@rules_cc//cc:defs.bzl", "cc_library")
load("@rules_python//python:defs.bzl", "py_runtime", "py_runtime_pair")

filegroup(
  name = "lsb-release",
  srcs = ["etc/os-release"],
)

cc_library(
  name = "expat",
  includes = ["usr/include"],
  srcs = [
    "usr/lib64/libexpat.so",
  ],
  hdrs = ["usr/include/expat.h"],
  strip_include_prefix = "usr/include",
  visibility = ["//visibility:public"],
)

cc_library(
  name = "zlib",
  includes = ["usr/include"],
  srcs = [
    "usr/lib64/libz.so",
  ],
  hdrs = ["usr/include/zconf.h", "usr/include/zlib.h"],
  strip_include_prefix = "usr/include",
  visibility = ["//visibility:public"],
)

cc_library(
  name = "python-dev",
  srcs = [
    "usr/lib64/libpython3.6m.so",
    "usr/lib64/libpython3.6m.so.1.0",
  ],
  hdrs = glob([
    "usr/include/python3.6m/*.h",
    "usr/include/python3.6m/**/*.h",
  ]),
  deps = [":zlib", "expat"],
  includes = ["usr/include/python3.6m"],
  visibility = ["//visibility:public"],
)

cc_library(
  name = "libllvm",
  srcs = [
    "usr/lib64/libLLVM.so",
    "usr/lib64/libLLVM.so.21.1",
  ],
  hdrs = glob(["usr/include/llvm-c/*.h"]),
  includes = ["usr/include"],
  visibility = ["//visibility:public"],
)

cc_library(
  name = "libclang",
  srcs = [
    "usr/lib64/libclang.so",
    "usr/lib64/libclang.so.21.1",
  ],
  deps = [":libllvm"],
  hdrs = glob(["usr/include/clang-c/*.h"]),
  includes = ["usr/include"],
  visibility = ["//visibility:public"],
)

py_runtime(
  name = "python-3.11",
  files = glob(["usr/lib/python3.11/*"]),
  interpreter = "usr/bin/python3.11",
  python_version = "PY3",
)

py_runtime_pair(
  name = "py_runtime",
  py3_runtime = ":python-3.11",
)
