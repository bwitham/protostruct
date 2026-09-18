def get_lsb_release(ctx):
  """Read and parse /etc/lsb-release, returning the content as a dictionary."""
  result = {}
  res = ctx.execute(["cat", "/etc/lsb-release"])
  if res.return_code != 0:
    return {
        "DISTRIB_ID": "Rocky",
        "DISTRIB_RELEASE": "8",
        "DISTRIB_CODENAME": "rocky",
        "DISTRIB_DESCRIPTION": "\"Rocky Linux 8\"",
    }
  for line in res.stdout.split("\n"):
    line = line.strip()
    if "=" not in line:
      continue
    key, value = line.split("=")
    result[key] = value
  return result

def _suite_repository_impl(ctx):
  """Defines a repository which contains just one file defs.bzl. This file
     defines variables containing the content of /etc/lsb-release of the
     host system."""
  lsb_release = get_lsb_release(ctx)
  lines = []
  for key, value in sorted(lsb_release.items()):
    value = value.strip('"')
    lines.append('{} = "{}"'.format(key, value))
  content = "\n".join(lines) + "\n"
  ctx.file("BUILD", 'package(default_visibility="//visibility:public")\n')
  ctx.file("defs.bzl", content)

suite_repository = repository_rule(
  implementation = _suite_repository_impl,
  configure = True,
)

