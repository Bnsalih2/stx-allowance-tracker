;; ============================================================
;;  ALLOWANCE TRACKER CONTRACT
;;  Version: 1.0
;;  Description: Admin sets a weekly STX allowance for users.
;;               Users can only claim once per 7 days.
;; ============================================================

(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-NO-ALLOWANCE (err u101))
(define-constant ERR-TOO-SOON (err u102))

;; ----------------------------
;; Data Variables
;; ----------------------------

(define-data-var admin principal tx-sender)
(define-map user-allowance { user: principal } { amount: uint })
(define-map last-claim { user: principal } { block: uint })

;; ----------------------------
;; Helpers
;; ----------------------------

(define-private (is-admin (who principal))
  (is-eq who (var-get admin))
)

;; ----------------------------
;; Public Functions
;; ----------------------------

;; Admin sets the weekly allowance for a user
(define-public (set-allowance (user principal) (amount uint))
  (begin
    (if (not (is-admin tx-sender))
        ERR-NOT-AUTHORIZED
        (begin
          (map-set user-allowance { user: user } { amount: amount })
          (ok (print { set-for: user, amount: amount }))
        )
    )
  )
)

;; User claims their weekly allowance
(define-public (claim-allowance)
  (let
    (
      (info (map-get? user-allowance { user: tx-sender }))
      (last (default-to { block: u0 } (map-get? last-claim { user: tx-sender })))
    )
    (match info user-data
      (let
        (
          (amount (get amount user-data))
          (current-block u0)
        )
        (if (< (- current-block (get block last)) u1008) ;; ~1008 blocks = 7 days (10-min blocks)
            ERR-TOO-SOON
            (match (stx-transfer? amount tx-sender tx-sender) ;; simulate deposit to user
              success (begin
                (map-set last-claim { user: tx-sender } { block: current-block })
                (ok (print { claimed: amount, at-block: current-block })))
              error (err error))))
      ERR-NO-ALLOWANCE)
    )
  )

;; View: check user allowance
(define-read-only (get-allowance (user principal))
  (default-to u0 (get amount (map-get? user-allowance { user: user })))
)

;; View: check when user last claimed
(define-read-only (get-last-claim (user principal))
  (default-to u0 (get block (map-get? last-claim { user: user })))
)

;; View: admin address
(define-read-only (get-admin) (var-get admin))
