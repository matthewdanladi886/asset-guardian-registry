;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Contract: Asset Guardian Registry
;; Purpose : Register and manage guardianship for digital assets
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Stores asset guardianship:
;; key = asset-id (uint)
;; value = { owner: principal, guardian: principal }
(define-map guardianship
  uint
  { owner: principal, guardian: principal }
)

;; Auto-incrementing asset identifier
(define-data-var next-id uint u1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PUBLIC FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Register a new asset and assign a guardian
(define-public (register-asset (guardian principal))
  (let ((id (var-get next-id)))
    (map-set guardianship id {
      owner: tx-sender,
      guardian: guardian
    })
    (var-set next-id (+ id u1))
    (ok { asset-id: id, guardian: guardian })
  )
)

;; Update guardian for an existing asset
(define-public (update-guardian (asset-id uint) (new-guardian principal))
  (let ((record (map-get? guardianship asset-id)))
    (asserts! (is-some record) (err u100)) ;; asset not found

    (let ((data (unwrap! record (err u100))))
      (asserts! (is-eq (get owner data) tx-sender) (err u101)) ;; permission error

      (map-set guardianship asset-id {
        owner: (get owner data),
        guardian: new-guardian
      })

      (ok { updated: asset-id, guardian: new-guardian })
    )
  )
)

;; Remove guardian assignment (revoke)
(define-public (revoke-guardian (asset-id uint))
  (let ((record (map-get? guardianship asset-id)))
    (asserts! (is-some record) (err u100))

    (let ((data (unwrap! record (err u100))))
      (asserts! (is-eq (get owner data) tx-sender) (err u101))

      (map-delete guardianship asset-id)
      (ok { removed: asset-id })
    )
  )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; READ-ONLY FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Get guardian info for an asset
(define-read-only (get-guardian (asset-id uint))
  (map-get? guardianship asset-id)
)

;; Check if a principal is guardian for an asset
(define-read-only (is-guardian (asset-id uint) (user principal))
  (match (map-get? guardianship asset-id)
    record (is-eq (get guardian record) user)
    false
  )
)

