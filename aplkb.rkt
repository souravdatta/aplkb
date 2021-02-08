#lang racket

(require "syms.rkt")
(require racket/gui)
(require racket/draw)

(define alpha '(a b c d e f g h i j k l m n
                  o p q r s t u v w x y z))

(define symbol-list (for/list ([u unicode-symbols]
                               [a (for*/list ([a1 alpha]
                                              [a2 alpha])
                                    (format ".~a~a" a1 a2))])
                      (cons a u)))

(define (replace-text-with-symbols text)
  (for/fold ([s text])
            ([x symbol-list])
    (string-replace s (car x) (cdr x))))

(define (make-bitmap-sym sym)
  (let* ([bitmap (make-bitmap 80 40)]
         [dc (new bitmap-dc% [bitmap bitmap])])
    (send dc set-font (make-font #:size 18 #:weight 'bold))
    (send dc draw-text (format "~a" (cdr sym)) 16 4)
    (send dc set-font (make-font #:size 12))
    (send dc draw-text (format "~a" (car sym)) 56 20)
    bitmap))

(define (make-button parent s callback)
  (new button%
       [parent parent]
       [label (make-bitmap-sym s)]
       [min-width 80]
       [min-height 40]
       [callback callback]))

(define (create-paned-buttons parent syms cols callback-fn)
  (let ([vpane (new vertical-pane% [parent parent])])
    (let looper ([symbols syms]
                 [buttons '()]
                 [hpanes '()])
      (cond
        ((= (length symbols) 0) (values buttons vpane hpanes))
        ((< (length symbols) cols)
         (let* ([hpane (new horizontal-pane%
                            [parent vpane])]
                [btns (map (λ (s)
                             (make-button hpane s (callback-fn s))) symbols)])
           (values (append buttons btns)
                   vpane
                   (append hpanes (list hpane)))))
        (else (let* ([hpane (new horizontal-pane%
                                 [parent vpane])]
                     [btns (map (λ (s)
                                  (make-button hpane s (callback-fn s))) (take symbols cols))])
                (looper (drop symbols cols)
                        (append buttons btns)
                        (append hpanes (list hpane)))))))))


(define (gui)
  (define frm (new frame%
                   [label "APL"]
                   [stretchable-width #f]
                   [stretchable-height #f]))
  (define main-pane (new horizontal-pane%
                         [parent frm]))
  (define editor-pane (new vertical-pane%
                           [parent main-pane]))
  (define input-pane (new horizontal-pane%
                          [parent editor-pane]))
  (define input-box (new text-field%
                         [parent input-pane]
                         [label ""]
                         [style '(multiple hscroll)]
                         [min-height 120]
                         [callback (λ (txtf c-evt)
                                     (let ([text (send txtf get-value)])
                                       (send txtf
                                             set-value
                                             (replace-text-with-symbols text))))]
                         [font (make-font #:size 16)]))
  (define do-button (new button%
                         [label "Copy"]
                         [parent input-pane]
                         [callback (λ (b e)
                                     (send the-clipboard set-clipboard-string
                                           (send input-box get-value)
                                           (send e get-time-stamp))
                                     ;(send input-box set-value "")
                                     (send input-box focus))]))
  (define-values (buttons vpane hpanes)
    (create-paned-buttons editor-pane
                          symbol-list
                          10
                          (λ (s)
                            (λ (b e)
                              (send (send input-box get-editor) insert (cdr s))
                              (send input-box focus)))))
  (send input-box focus)
  (send frm show #t))


(gui)
