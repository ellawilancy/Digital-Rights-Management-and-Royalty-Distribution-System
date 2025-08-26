;; Content Registry Contract
;; Manages registration and ownership of digital content

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-CONTENT-NOT-FOUND (err u101))
(define-constant ERR-ALREADY-EXISTS (err u102))
(define-constant ERR-INVALID-INPUT (err u103))

;; Data Variables
(define-data-var next-content-id uint u1)

;; Data Maps
(define-map content-registry
  uint
  {
    title: (string-ascii 100),
    creator: principal,
    metadata-uri: (string-ascii 200),
    price: uint,
    created-at: uint,
    is-active: bool
  }
)

(define-map creator-content
  principal
  (list 100 uint)
)

;; Read-only functions
(define-read-only (get-content (content-id uint))
  (map-get? content-registry content-id)
)

(define-read-only (get-creator-content (creator principal))
  (default-to (list) (map-get? creator-content creator))
)

(define-read-only (get-next-content-id)
  (var-get next-content-id)
)

(define-read-only (is-content-owner (content-id uint) (user principal))
  (match (map-get? content-registry content-id)
    content-data (is-eq (get creator content-data) user)
    false
  )
)

;; Public functions
(define-public (register-content (title (string-ascii 100)) (metadata-uri (string-ascii 200)) (price uint))
  (let
    (
      (content-id (var-get next-content-id))
      (creator tx-sender)
    )
    (asserts! (> (len title) u0) ERR-INVALID-INPUT)
    (asserts! (> (len metadata-uri) u0) ERR-INVALID-INPUT)

    ;; Store content data
    (map-set content-registry content-id
      {
        title: title,
        creator: creator,
        metadata-uri: metadata-uri,
        price: price,
        created-at: block-height,
        is-active: true
      }
    )

    ;; Update creator's content list
    (let
      (
        (current-list (get-creator-content creator))
        (updated-list (unwrap! (as-max-len? (append current-list content-id) u100) ERR-INVALID-INPUT))
      )
      (map-set creator-content creator updated-list)
    )

    ;; Increment next content ID
    (var-set next-content-id (+ content-id u1))

    (ok content-id)
  )
)

(define-public (update-content-price (content-id uint) (new-price uint))
  (let
    (
      (content-data (unwrap! (map-get? content-registry content-id) ERR-CONTENT-NOT-FOUND))
    )
    (asserts! (is-eq (get creator content-data) tx-sender) ERR-NOT-AUTHORIZED)

    (map-set content-registry content-id
      (merge content-data { price: new-price })
    )

    (ok true)
  )
)

(define-public (deactivate-content (content-id uint))
  (let
    (
      (content-data (unwrap! (map-get? content-registry content-id) ERR-CONTENT-NOT-FOUND))
    )
    (asserts! (is-eq (get creator content-data) tx-sender) ERR-NOT-AUTHORIZED)

    (map-set content-registry content-id
      (merge content-data { is-active: false })
    )

    (ok true)
  )
)

(define-public (transfer-ownership (content-id uint) (new-owner principal))
  (let
    (
      (content-data (unwrap! (map-get? content-registry content-id) ERR-CONTENT-NOT-FOUND))
      (current-owner (get creator content-data))
    )
    (asserts! (is-eq current-owner tx-sender) ERR-NOT-AUTHORIZED)

    ;; Update content ownership
    (map-set content-registry content-id
      (merge content-data { creator: new-owner })
    )

    ;; Remove from old owner's list
    (let
      (
        (old-list (get-creator-content current-owner))
        (filtered-list (filter is-not-content-id old-list))
      )
      (map-set creator-content current-owner filtered-list)
    )

    ;; Add to new owner's list
    (let
      (
        (new-list (get-creator-content new-owner))
        (updated-list (unwrap! (as-max-len? (append new-list content-id) u100) ERR-INVALID-INPUT))
      )
      (map-set creator-content new-owner updated-list)
    )

    (ok true)
  )
)

;; Private functions
(define-private (is-not-content-id (id uint))
  (not (is-eq id (var-get next-content-id)))
)
