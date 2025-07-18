# SocialStake - Decentralized Social Media Protocol

## Overview

SocialStake is a revolutionary blockchain-based social media protocol that transforms social media economics through decentralized incentives and transparent reputation systems. Built on the Stacks blockchain with Bitcoin security, the protocol rewards high-quality content creation and curation while preventing spam and manipulation through innovative stake-to-participate mechanics.

## 🌟 Key Features

- **Stake-to-Participate**: Users must stake STX tokens to create content and participate in the platform
- **Quality-Driven Rewards**: Content rewards are distributed based on community consensus and quality scores
- **Reputation System**: Algorithmic reputation scoring ensures long-term platform integrity
- **Decentralized Voting**: Stake-weighted peer-to-peer voting mechanism for content curation
- **Social Networks**: Follow/unfollow functionality to build verifiable social connections
- **Bitcoin Security**: Leverages Bitcoin's immutable ledger through Stacks blockchain
- **Administrative Controls**: Platform governance through owner-controlled parameters

## 🏗️ Architecture

### Core Components

```text
┌─────────────────────────────────────────────────────────────┐
│                    SocialStake Protocol                     │
├─────────────────────────────────────────────────────────────┤
│  User Management    │  Content System    │  Voting Engine   │
│  ┌──────────────┐   │  ┌──────────────┐  │  ┌─────────────┐ │
│  │ Registration │   │  │ Content      │  │  │ Stake-      │ │
│  │ Staking      │   │  │ Creation     │  │  │ Weighted    │ │
│  │ Reputation   │   │  │ Validation   │  │  │ Voting      │ │
│  │ Following    │   │  │ Rewards      │  │  │ Quality     │ │
│  └──────────────┘   │  └──────────────┘  │  │ Scoring     │ │
│                     │                    │  └─────────────┘ │
├─────────────────────┼────────────────────┼─────────────────┤
│            Bitcoin Security (Stacks Blockchain)             │
└─────────────────────────────────────────────────────────────┘
```

## Data Models

### User Structure

```clarity
{
  reputation-score: uint,     ;; User's reputation score
  total-content: uint,        ;; Number of content pieces created
  total-earnings: uint,       ;; Total STX earned from rewards
  stake-amount: uint,         ;; Current staked amount
  last-action-block: uint,    ;; Last activity block height
  verified: bool,             ;; Verification status
  join-block: uint           ;; Registration block height
}
```

### Content Structure

```clarity
{
  creator: principal,         ;; Content creator's address
  content-hash: string-ascii, ;; IPFS/content hash
  title: string-utf8,         ;; Content title
  category: string-ascii,     ;; Content category
  timestamp: uint,            ;; Creation timestamp
  total-votes: uint,          ;; Total voting weight received
  positive-votes: uint,       ;; Positive voting weight
  quality-score: uint,        ;; Calculated quality score (0-1000)
  reward-claimed: bool,       ;; Reward claim status
  stake-backing: uint         ;; STX staked for this content
}
```

### Vote Structure

```clarity
{
  vote-type: bool,           ;; true = upvote, false = downvote
  stake-weight: uint,        ;; Voting power based on stake + reputation
  timestamp: uint            ;; Vote timestamp
}
```

## 🚀 Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) v2.0+
- [Node.js](https://nodejs.org/) v18+
- [Stacks CLI](https://docs.stacks.co/stacks-cli)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-org/social-stake.git
   cd social-stake
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Run tests**

   ```bash
   npm test
   ```

4. **Check contracts**

   ```bash
   clarinet check
   ```

### Quick Start

1. **Deploy the contract** (testnet)

   ```bash
   clarinet deployments apply --network testnet
   ```

2. **Register as a user**

   ```clarity
   (contract-call? .social-stake register-user)
   ```

3. **Stake tokens**

   ```clarity
   (contract-call? .social-stake stake-tokens u1000000) ;; 1 STX
   ```

4. **Create content**

   ```clarity
   (contract-call? .social-stake create-content 
     "QmHashOfYourContent..."
     u"My First Post"
     "general"
     u500000) ;; 0.5 STX backing
   ```

## 📖 API Reference

### Public Functions

#### User Management

- `register-user()` - Register a new user account
- `stake-tokens(amount: uint)` - Stake STX tokens to participate
- `unstake-tokens(amount: uint)` - Withdraw staked tokens
- `follow-user(user: principal)` - Follow another user
- `unfollow-user(user: principal)` - Unfollow a user

#### Content Operations

- `create-content(hash, title, category, stake)` - Create new content
- `vote-content(content-id: uint, positive: bool)` - Vote on content
- `claim-content-rewards(content-id: uint)` - Claim content rewards

#### Utility Functions

- `add-to-reward-pool(amount: uint)` - Add funds to reward pool

### Read-Only Functions

- `get-contract-info()` - Get contract configuration
- `get-user-profile(user: principal)` - Get user data
- `get-user-reputation(user: principal)` - Get user reputation score
- `get-content-details(content-id: uint)` - Get content information
- `calculate-content-quality(content-id: uint)` - Calculate content quality score
- `calculate-trust-score(user: principal)` - Calculate user trust score
- `is-following(follower, following: principal)` - Check follow status

### Administrative Functions

- `set-contract-enabled(enabled: bool)` - Enable/disable contract
- `set-min-stake-amount(amount: uint)` - Set minimum stake requirement
- `verify-user(user: principal)` - Verify a user (reputation boost)
- `emergency-withdraw(amount: uint)` - Emergency fund withdrawal

## 🔧 Configuration

### Environment Variables

```bash
# Network configuration
STACKS_NETWORK=testnet
STACKS_NODE_URL=https://api.testnet.hiro.so

# Contract parameters
MIN_STAKE_AMOUNT=1000000      # 1 STX in microSTX
PLATFORM_FEE_RATE=50          # 0.5% (50/10000)
REPUTATION_MULTIPLIER=100
```

### Contract Parameters

- **Minimum Stake**: 1 STX (adjustable by admin)
- **Platform Fee**: 0.5% of transactions
- **Starting Reputation**: 100 points for new users
- **Voting Weight**: Base (1) + Reputation/100 + Stake/1M STX

## 🧪 Testing

### Running Tests

```bash
# Run all tests
npm test

# Run tests with coverage
npm run test:report

# Watch mode for development
npm run test:watch

# Check contract syntax
clarinet check
```

### Test Structure

```text
tests/
├── social-stake.test.ts     # Main contract tests
├── integration/             # Integration tests
└── helpers/                 # Test utilities
```

## 🔒 Security Considerations

### Implemented Security Features

1. **Ownership Controls**: Critical functions restricted to contract owner
2. **Input Validation**: Comprehensive validation for all user inputs
3. **Reentrancy Protection**: Safe token transfer patterns
4. **Integer Overflow Protection**: Built-in Clarity protections
5. **Access Controls**: Role-based function access

### Security Best Practices

- Always validate user inputs
- Use `try!` for safe error handling
- Implement proper access controls
- Test edge cases thoroughly
- Regular security audits recommended

## 🌐 Network Deployment

### Testnet Deployment

```bash
clarinet deployments apply --network testnet
```

### Mainnet Deployment

```bash
clarinet deployments apply --network mainnet
```

### Deployment Configuration

See `settings/` directory for network-specific configurations:

- `Devnet.toml` - Local development
- `Testnet.toml` - Stacks testnet
- `Mainnet.toml` - Stacks mainnet

## 📊 Economics Model

### Staking Mechanism

- **Minimum Stake**: 1 STX required to participate
- **Content Backing**: Users stake additional STX for content creation
- **Voting Power**: Proportional to stake amount + reputation

### Reward Distribution

```text
Quality Score = (Positive Votes / Total Votes) × 1000
Reward Amount = (Quality Score × Reward Pool) / 10000
```

### Reputation System

- **Registration**: +100 points
- **Content Creation**: +10 points
- **Positive Vote Received**: +voting weight
- **Negative Vote Received**: -voting weight
- **New Follower**: +5 points
- **Verification**: +100 points

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Clarity best practices
- Write comprehensive tests
- Update documentation
- Ensure all tests pass
- Follow semantic versioning

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🗺️ Roadmap

- [ ] **Phase 1**: Core protocol implementation ✅
- [ ] **Phase 2**: Frontend application development
- [ ] **Phase 3**: Mobile application
- [ ] **Phase 4**: Advanced reputation algorithms
- [ ] **Phase 5**: Cross-chain integration
- [ ] **Phase 6**: DAO governance implementation

## 📈 Metrics & Analytics

Track protocol metrics:

- Total users registered
- Content pieces created
- Total value staked
- Voting participation rates
- Reward distribution efficiency
