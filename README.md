# EtherTransfer Smart Contract

A Solidity smart contract that enables users to send Ether to a specified recipient address through a single function call. Built with [Remix IDE](https://remix.ethereum.org/) using Solidity `0.8.34`.

## Contract Overview

**`EtherTransfer`** allows anyone to send Ether to a recipient by calling `transferEther` with a payable value. The contract validates the amount and recipient, forwards the Ether via a low-level `call`, and emits an event on success. It also includes a `receive` function to accept direct Ether transfers.

### Events

| Event | Description |
|---|---|
| `EtherTransferred(from, to, amount)` | Emitted when Ether is successfully transferred to a recipient |

### Custom Errors

| Error | Description |
|---|---|
| `EtherTransfer_NoEtherSent()` | Reverted when no Ether is sent with the transaction |
| `EtherTransfer__InvalidRecipient()` | Reverted when the recipient is the zero address |
| `EtherTransfer__TransferFailed()` | Reverted when the low-level Ether transfer fails |

### Functions

| Function | Visibility | Description |
|---|---|---|
| `transferEther(address payable _recipient)` | `payable` | Sends `msg.value` Ether to `_recipient`; reverts on invalid input or failed transfer |
| `receive()` | `payable` | Accepts direct Ether transfers to the contract with no data |

## Getting Started

### Prerequisites
- [Remix IDE](https://remix.ethereum.org/) (no local setup required) or a local toolchain like [Foundry](https://book.getfoundry.sh/) / [Hardhat](https://hardhat.org/)

### Compile
1. Open `contracts/EtherTransfer.sol` in Remix IDE.
2. In the **Solidity Compiler** plugin, select compiler version `0.8.34` (or compatible).
3. Click **Compile EtherTransfer.sol**.

### Deploy
1. Navigate to the **Deploy & Run Transactions** plugin.
2. Select your desired environment (Remix VM, Injected Provider for MetaMask, etc.).
3. Click **Deploy** — no constructor arguments are required.

### Interact
- **Transfer Ether**: Call `transferEther` with a payable `address` recipient and attach the desired amount of Ether in the value field.
- **Send Directly**: Send a plain Ether transfer to the contract address to trigger `receive`.

### ⚠️ Known Issue
On line 22, the success check is inverted — `if (success) revert` will revert on a **successful** transfer instead of a failed one. This should be `if (!success) revert EtherTransfer__TransferFailed();` to behave correctly.

## Project Structure

```
.
├── contracts/
│   └── EtherTransfer.sol          # Main EtherTransfer contract
├── artifacts/
│   ├── EtherTransfer.json          # Compilation artifact
│   └── EtherTransfer_metadata.json # Contract metadata
├── remix.config.json               # Remix IDE workspace configuration
└── README.md
```

## Security Considerations

- **Inverted success check**: As noted above, the current logic reverts on success and proceeds on failure. This must be fixed before production use.
- **Reentrancy**: The low-level `call` forwards all gas to the recipient. Ensure recipient contracts are trusted or implement reentrancy guards if extending this contract.
- **Unchecked return data**: The `call` return data is discarded; only the boolean success flag is checked.
- Consider adding access control or withdrawal patterns rather than immediate forwarding for more complex use cases.

## License

This project is licensed under the **MIT License** (SPDX-License-Identifier: MIT).

## Resources

- [Remix IDE Documentation](https://remix-ide.readthedocs.io/)
- [Solidity Language Documentation](https://docs.soliditylang.org/)
- [Solidity Best Practices — Sending and Receiving Ether](https://docs.soliditylang.org/en/latest/security-considerations.html#sending-and-receiving-ether)
