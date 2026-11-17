# Code and configuration comments

For comments in shell startup files, installers, configuration, workflows,
Dockerfiles, and C# integration tests.

- Explain non-obvious quoting, interpreter differences, platform guards,
  permissions, ordering, and repeat-install behavior.
- For link policy, explain why an existing file may be replaced or preserved.
  State which user or system path an elevated command affects.
- For shell startup code, explain necessary side effects such as SSH-agent
  persistence. Keep secrets and actual credential values out of examples.
- For YAML and TOML, place a reason above the affected key. Keep executable
  commands and version pins in their configuration files rather than copying
  them into prose.
- For Forgejo workflows, explain runner or container-engine constraints rather
  than narrating checkout, build, and test steps.
- For Dockerfiles and tests, explain setup requirements and external
  dependencies. Let descriptive test names and assertions express expected
  behavior; reserve comments for constraints those names cannot convey.
- For PowerShell, explain Windows-specific executable discovery or quoting
  where it differs from the Bash entry point.

Remove narration and obsolete history in the code you are changing. Preserve
useful configuration examples and vendor-provided guidance unless replacing
them is part of the task. Keep upstream submodule documentation upstream.
