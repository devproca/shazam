# shazam
Microservice Logging, with a Java client.

## How to run
Make sure you have `dune` installed. Run via:
```
dune exec shazam
```
or compile to binary with:
```
dune build
```

You can then post to `localhost:3000/api/v1/logs` to add logs.

You can view the realtime logging frontend via `http://localhost:3000`.
