# Digital Rights Management and Royalty Distribution System

A comprehensive blockchain-based system for protecting intellectual property, managing digital rights, and automating royalty distributions to creators and collaborators.

## Overview

This system provides a decentralized solution for:
- **Digital Content Protection**: Secure registration and ownership tracking
- **Automated Royalty Distribution**: Smart contract-based revenue sharing
- **Rights Management**: Granular permission controls for content access
- **Direct Creator Support**: Fan-to-artist payment mechanisms
- **Transparent Revenue Sharing**: Immutable collaboration agreements

## Architecture

### Core Contracts

1. **Content Registry** (`content-registry.clar`)
    - Register digital content with metadata
    - Track ownership and creation timestamps
    - Manage content licensing terms

2. **Royalty Distribution** (`royalty-distribution.clar`)
    - Define revenue sharing agreements
    - Automate royalty calculations
    - Handle multi-party distributions

3. **Rights Management** (`rights-management.clar`)
    - Control access permissions
    - Manage licensing agreements
    - Track usage rights

4. **Payment Processor** (`payment-processor.clar`)
    - Process content purchases
    - Handle escrow for disputed transactions
    - Manage payment settlements

5. **Fan Support** (`fan-support.clar`)
    - Direct creator tipping
    - Subscription-based support
    - Community funding mechanisms

## Key Features

### For Creators
- **IP Protection**: Immutable proof of creation and ownership
- **Automated Payments**: Set-and-forget royalty distribution
- **Flexible Licensing**: Multiple monetization models
- **Direct Fan Connection**: Bypass traditional intermediaries

### For Collaborators
- **Transparent Splits**: Clear revenue sharing agreements
- **Automated Distribution**: No manual payment processing
- **Dispute Resolution**: Built-in arbitration mechanisms

### For Fans/Consumers
- **Direct Support**: Support creators directly
- **Transparent Pricing**: Clear understanding of where money goes
- **Access Control**: Secure content delivery
- **Community Features**: Engage with creator communities

## Getting Started

### Prerequisites
- Clarinet CLI installed
- Node.js and npm
- Basic understanding of Clarity smart contracts

### Installation

\`\`\`bash
# Clone the repository
git clone <repository-url>
cd drm-royalty-system

# Install dependencies
npm install

# Run tests
npm test

# Deploy contracts (testnet)
clarinet deploy --testnet
\`\`\`

### Usage Examples

#### Register Content
\`\`\`clarity
(contract-call? .content-registry register-content
"My Song Title"
"ipfs://QmHash..."
u1000000) ;; Price in microSTX
\`\`\`

#### Set Royalty Split
\`\`\`clarity
(contract-call? .royalty-distribution set-royalty-split
u1 ;; content-id
(list
{recipient: 'SP1..., percentage: u60}
{recipient: 'SP2..., percentage: u40}))
\`\`\`

#### Purchase Content
\`\`\`clarity
(contract-call? .payment-processor purchase-content u1 u1000000)
\`\`\`

## Testing

The system includes comprehensive tests covering:
- Content registration and ownership
- Royalty calculation accuracy
- Payment processing security
- Access control mechanisms
- Edge cases and error handling

Run tests with:
\`\`\`bash
npm test
\`\`\`

## Security Considerations

- All financial operations include overflow protection
- Access controls prevent unauthorized modifications
- Escrow mechanisms protect against payment disputes
- Input validation prevents malicious data injection

## License

MIT License - see LICENSE file for details

## Contributing

Please read CONTRIBUTING.md for contribution guidelines.
