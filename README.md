Please don't blindly run the flake if you don't know what you are doing.

It is a series of commands and tools that may or may not have baked in defaults by directly aliasing them into the command!

```bash
nix develop github:syntacticallyazure/shell

#dev command
nix develop --refresh github:syntacticallyazure/shell --command ff
```