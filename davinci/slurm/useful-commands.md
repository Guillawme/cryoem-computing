# Some useful commands to inspect slurm jobs

Get an interactive shell on a node:

```bash
srun --mem=10 --nodelist=a009 --partition=debug --pty bash -i
```

From there, one can run `top` or `nvidia-smi` to check if the resource usage
matches the resources requested in the slurm script.

