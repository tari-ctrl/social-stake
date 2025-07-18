;; SocialStake - Decentralized Social Media Protocol
;;
;; Summary:
;; Revolutionary blockchain-based social platform where content quality drives rewards.
;; Users stake tokens to publish, earn through peer validation, and build verifiable 
;; social reputation secured by Bitcoin's immutable ledger.
;;
;; Description:
;; SocialStake transforms social media economics through decentralized incentives and 
;; transparent reputation systems. Built on Stacks blockchain with Bitcoin security, 
;; the protocol rewards high-quality content creation and curation while preventing 
;; spam and manipulation. Users must stake tokens to participate, creating skin-in-the-game 
;; dynamics that naturally filter content quality. The peer-to-peer voting mechanism 
;; distributes rewards based on community consensus, while algorithmic reputation scoring 
;; ensures long-term platform integrity. Features include stake-weighted voting, 
;; follower networks, reward pooling, and administrative controls for platform governance.

;; CONSTANTS & ERROR CODES

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-exists (err u102))
(define-constant err-insufficient-funds (err u103))
(define-constant err-unauthorized (err u104))
(define-constant err-invalid-amount (err u105))
(define-constant err-self-interaction (err u106))
(define-constant err-already-voted (err u107))
(define-constant err-invalid-score (err u108))
(define-constant err-stake-required (err u109))
(define-constant err-cooldown-active (err u110))
(define-constant err-invalid-input (err u111))

;; DATA VARIABLES

(define-data-var contract-enabled bool true)
(define-data-var min-stake-amount uint u1000000) ;; 1 STX in microSTX
(define-data-var reputation-multiplier uint u100)
(define-data-var content-reward-pool uint u0)
(define-data-var platform-fee-rate uint u50) ;; 0.5% (50/10000)

;; DATA MAPS

(define-map users
  principal
  {
    reputation-score: uint,
    total-content: uint,
    total-earnings: uint,
    stake-amount: uint,
    last-action-block: uint,
    verified: bool,
    join-block: uint,
  }
)

(define-map content
  uint
  {
    creator: principal,
    content-hash: (string-ascii 64),
    title: (string-utf8 100),
    category: (string-ascii 20),
    timestamp: uint,
    total-votes: uint,
    positive-votes: uint,
    quality-score: uint,
    reward-claimed: bool,
    stake-backing: uint,
  }
)

(define-map votes
  {
    content-id: uint,
    voter: principal,
  }
  {
    vote-type: bool, ;; true for upvote, false for downvote
    stake-weight: uint,
    timestamp: uint,
  }
)

(define-map user-following
  {
    follower: principal,
    following: principal,
  }
  bool
)

(define-map reputation-history
  {
    user: principal,
    block: uint,
  }
  {
    old-score: uint,
    new-score: uint,
    reason: (string-ascii 50),
  }
)

;; SEQUENCE COUNTERS

(define-data-var content-id-nonce uint u0)

;; INPUT VALIDATION FUNCTIONS

(define-private (validate-content-hash (hash (string-ascii 64)))
  (let ((hash-len (len hash)))
    (and (>= hash-len u32) (<= hash-len u64))
  )
)

(define-private (validate-title (title (string-utf8 100)))
  (let ((title-len (len title)))
    (and (>= title-len u1) (<= title-len u100))
  )
)

(define-private (validate-category (category (string-ascii 20)))
  (let ((category-len (len category)))
    (and (>= category-len u1) (<= category-len u20))
  )
)

(define-private (validate-content-id (content-id uint))
  (and (> content-id u0) (<= content-id (var-get content-id-nonce)))
)

(define-private (validate-amount (amount uint))
  (and (> amount u0) (<= amount u1000000000000)) ;; Reasonable upper limit
)

(define-private (validate-user (user principal))
  (is-some (map-get? users user))
)

;; READ-ONLY FUNCTIONS

(define-read-only (get-contract-info)
  {
    enabled: (var-get contract-enabled),
    min-stake: (var-get min-stake-amount),
    reputation-multiplier: (var-get reputation-multiplier),
    reward-pool: (var-get content-reward-pool),
    platform-fee: (var-get platform-fee-rate),
  }
)

(define-read-only (get-user-profile (user principal))
  (map-get? users user)
)

(define-read-only (get-user-reputation (user principal))
  (default-to u0 (get reputation-score (map-get? users user)))
)

(define-read-only (get-content-details (content-id uint))
  (if (validate-content-id content-id)
    (map-get? content content-id)
    none
  )
)

(define-read-only (get-vote-details (content-id uint) (voter principal))
  (if (validate-content-id content-id)
    (map-get? votes {
      content-id: content-id,
      voter: voter,
    })
    none
  )
)

(define-read-only (is-following (follower principal) (following principal))
  (default-to false
    (map-get? user-following {
      follower: follower,
      following: following,
    })
  )
)

(define-read-only (calculate-content-quality (content-id uint))
  (let (
      (content-data (unwrap! (map-get? content content-id) u0))
      (total-votes (get total-votes content-data))
      (positive-votes (get positive-votes content-data))
    )
    (if (> total-votes u0)
      (/ (* positive-votes u1000) total-votes) ;; Quality score out of 1000
      u0
    )
  )
)

(define-read-only (calculate-trust-score (user principal))
  (let (
      (user-data (unwrap! (map-get? users user) u0))
      (reputation (get reputation-score user-data))
      (stake-amount (get stake-amount user-data))
      (content-count (get total-content user-data))
    )
    (+ 
      (/ reputation u10)              ;; Reputation component
      (/ stake-amount u100000)        ;; Stake component (STX to points)
      (* content-count u5)            ;; Content activity component
    )
  )
)