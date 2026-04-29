# Architecture

The repository is a multi-project lab. Each folder should be evaluated independently, with shared documentation serving as a map across concepts.

## Component View

```mermaid
flowchart LR
  Actor["Developer learner"] --> Entry["Project folder"]
  Entry --> Service["Experiment-specific app or contract"]
  Service --> Data["Local chain or local files"]
  Service --> External["Solidity tooling and blockchain clients"]
```

## Key Components

- Solidity basics
- Auction and token experiments
- Chat and decentralized game examples
- HashItOut project folder

## Main Workflow

```mermaid
sequenceDiagram
  participant User
  participant Client
  participant App
  participant Store
  User->>Client: Selects a learning module
  Client->>App: Runs or reads project code
  App->>Store: Validate and persist state
  Store-->>App: Local result or contract state changes
  App-->>Client: Reviews behavior and lessons
  Client-->>User: Present updated result
```

## Design Considerations

- Keep each experiment independently understandable
- Document expected tool versions per folder
- Promote historical context over production claims


