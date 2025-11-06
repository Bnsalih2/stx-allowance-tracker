# STX Allowance Tracker

A Clarity smart contract for managing and tracking weekly STX allowances on the Stacks blockchain.

## Overview

This contract implements a simple allowance system where:
- Users can be assigned a weekly STX allowance
- Claims can only be made once per week (1008 blocks)
- Automatic tracking of last claim timestamp using block height
- Built-in safety checks to prevent duplicate claims

## Features

-  Weekly claiming periods
-  Secure STX transfers
-  Claim history tracking
-  Efficient block-based timing
-  Built-in error handling

## Contract Functions

### Set Allowance
```clarity
(define-public (set-allowance (user principal) (amount uint))
```
Sets or updates the allowance amount for a specific user.

### Claim Allowance
```clarity
(define-public (claim-allowance)
```
Allows users to claim their weekly allowance if available.

## Error Codes

- `ERR-TOO-SOON`: Attempted to claim before the weekly period has passed
- `ERR-NO-ALLOWANCE`: User has no allowance set

## Development

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet)
- [Stacks CLI](https://docs.stacks.co/references/stacks-cli)

### Testing

```bash
clarinet test
```

### Deployment

To deploy to testnet:
```bash
clarinet deploy --testnet
```

## Security

- Weekly time-locks prevent excessive claims
- Principal-based access control
- Response type handling for all operations

## License

MIT License

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to your branch
5. Open a Pull Request
