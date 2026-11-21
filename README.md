This is a Nix OS shell with built in defaults, configurations and aliases.

Please don't blindly run this flake if you don't know what you are doing.

```bash
nix develop github:syntacticallyazure/shell

# enter shell
nix develop --refresh github:syntacticallyazure/shell

# hacky method of just testing a shell
nix develop --refresh github:syntacticallyazure/shell --command true

# clean up
nix-collect-garbage -d;
nix-store --gc;
```