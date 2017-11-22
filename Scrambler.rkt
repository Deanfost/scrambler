;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname Scrambler) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Author : Dean Foster
; Purpose : A word scrambler

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Algorithm

; - Take all vowels in the word and replace them with the next vowel in the list
; (A, E, I, O, U, (Y)), with 'Y's only being counted as a Vowel if it is inside
; the String, and is not to be used as a replacement
; - Insert the last vowel replacement 2 positions after it
; - If the last replacement is the last 1String in the list, then do nothing
; extra
; - Iff there is a 'Y' in the word, then replace it with 'A' (case-insensitive)
; - To account for special characters (., !, ?, etc.): if the last 1String
; is, and the Vowel insertion would either replace or go after the character,
; then don't do it

; Examples:
; - Kensington -> Kinsongtunu
; - About -> Ebuata
; - Prince -> Pronci

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; A Vowel is a String, and is one of:
; - 'A'
; - 'E'
; - 'I'
; - 'O'
; - 'U'
; - ""
; and is case-insensitive

; A Letter is a 1String

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Constants

; Lists containing Vowels, both uppercase and lowercase, with an extra 'A' to
; handle 'U' substitutions
(define V-LIST (list "A" "E" "I" "O" "U" "A"))
(define V-LIST-L (list "a" "e" "i" "o" "u" "a"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Main

; scramble-main : String -> String
; Given a String, scramble every other word in the String
(check-expect (scramble-main "") "")
(check-expect (scramble-main "Hello there") "Hillu there")
(check-expect (scramble-main "Hello there friend") "Hillu there froinid")
(define (scramble-main s)
  (combine (scramble/2 (string->words s))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helpers

; combine : [Listof String] -> String
; Given a [Listof String], put together all of the Strings with a ' ' in between
(check-expect (combine '()) "")
(check-expect (combine (list "Hello" "there")) "Hello there")
(define (combine l)
  (cond [(empty? l) ""]
        [(cons? l)
         (cond [(empty? (rest l))
                (string-append (first l) (combine (rest l)))]
               [else
                (string-append (first l) " " (combine (rest l)))])]))

; scramble/2 : [Listof String] -> [Listof String]
; Given a {Listof String], apply the algorithm to every other word
(check-expect (scramble/2 '()) '())
(check-expect (scramble/2 (list "Hello")) (list "Hillu"))
(check-expect (scramble/2 (list "Hello" "there"))
              (list "Hillu" "there"))
(check-expect (scramble/2 (list "Hello" "there" "friend"))
              (list "Hillu" "there" "froinid"))
(define (scramble/2 l)
  (scramble/2/a l 0))

; scramble/2/a : [Listof String] Natural -> [Listof String]
; Given a [Listof String] and an iteration count, apply the
; algorithm to every other word
(check-expect (scramble/2/a '() 0) '())
(check-expect (scramble/2/a (list "Hello") 0) (list "Hillu"))
(check-expect (scramble/2/a (list "How" "are") 0) (list "Huwu" "are"))
(check-expect (scramble/2/a (list "How" "are" "you") 0) (list "Huwu" "are" "aua"))
(check-expect (scramble/2/a (list "How" "are" "you" "friend") 0)
              (list "Huwu" "are" "aua" "friend"))
(define (scramble/2/a l i)
  (cond [(empty? l) '()]
        [(cons? l)
         (cond [(= (remainder i 2) 0)
                (cons (scramble-string (first l))
                      (scramble/2/a (rest l) (add1 i)))]
               [else
                (cons (first l)
                      (scramble/2/a (rest l) (add1 i)))])]))

; string->words : String -> [Listof String]
; Given a String, parse the string into it's different words, delimted by ' '
(check-expect (string->words "") (list ""))
(check-expect (string->words "Hello") (list "Hello"))
(check-expect (string->words "Hello there friend")
              (list "Hello" "there" "friend"))
(define (string->words s)
  (string->words/a s "" '()))

; string->words/a : String String [Listof String] -> [Listof String]
; Given a String, an accumulated String, and the list so far, parse it
; into different words, delimited by ' '
(check-expect (string->words/a "" "" '()) (list ""))
(check-expect (string->words/a "Hello there" "" '()) (list "Hello" "there"))
(define (string->words/a s a l)
  (cond [(= (string-length s) 0)
         (append l (list (string-append a s)))]
        [(string=? (string-ith s 0) " ")
         (string->words/a (substring s 1) "" (append l (list a)))]
        [else
         (string->words/a (substring s 1)
                          (string-append a (string-ith s 0)) l)]))
                    
; scramble-string : String -> String
; Given a String, scramble it
(check-expect (scramble-string "Plank") "Plenek")
(check-expect (scramble-string "Kensington") "Kinsongtunu")
(check-expect (scramble-string "Sponge") "Spungi")
(define (scramble-string s)
  (scramble-letters (explode s) "" 0 '()))

; scramble-letters : [Listof Letter] Vowel Natural [Listof Letter] -> String
; Given a [Listof Letter], a Vowel, an index, and the processed Letters
; so far, scramble the String by replacing each Vowel
; with the next, then place an extra Vowel in the right spot 
(check-expect (scramble-letters '() "" 0 '()) "")
(check-expect (scramble-letters (list "P" "l" "a" "n" "k") "" 0 '())
              "Plenek")
(check-expect (scramble-letters (list "S" "p" "o" "n" "g" "e") "" 0 '())
              "Spungi")
(check-expect (scramble-letters (list "O" "u" "r") "" 0 '()) "Uara")
(define (scramble-letters l v i a)
  (cond [(empty? l) (insert-vowel a v i)]
        [(cons? l)
         (cond [(vowel? (first l))
                (scramble-letters
                 (rest l) (scramble-letter (first l)) (length a)
                 (append a (list (scramble-letter (first l)))))]
               [else
                (scramble-letters (rest l) v i
                                  (append
                                   a (list (first l))))])]))

; scramble-letter : Letter -> Letter
; Given a Letter, determine if it is a Vowel, then scramble it, returning
; the proper case as well
(check-expect (scramble-letter "k") "k")
(check-expect (scramble-letter "K") "K")
(check-expect (scramble-letter "a") "e")
(check-expect (scramble-letter "E") "I")
(check-expect (scramble-letter "y") "a")
(check-expect (scramble-letter "Y") "A")
(define (scramble-letter l)
  (cond [(string-ci=? l "y")
         (cond [(string-lower-case? l) "a"]
               [(string-upper-case? l) "A"])]
        [(vowel? l)
         (cond [(string-lower-case? l)
                (list-ref V-LIST-L (add1 (find-index l)))]
               [(string-upper-case? l)
                (list-ref V-LIST (add1 (find-index l)))])]
        [else l]))

; find-index : Vowel -> Natural
; Given a Vowel, return the index of that Vowel in V-LIST
(check-expect (find-index "a") 0)
(check-expect (find-index "A") 0)
(check-expect (find-index "e") 1)
(check-expect (find-index "u") 4)
(check-expect (find-index "i") 2)
(check-expect (find-index "o") 3)
(define (find-index v)
  (cond [(string-ci=? v "a") 0]
        [(string-ci=? v "e") 1]
        [(string-ci=? v "i") 2]
        [(string-ci=? v "o") 3]
        [(string-ci=? v "u") 4]))

; insert-vowel : [Listof Letter] Vowel Natural -> String
; Given a [Listof Letter], Vowel, and index of that Vowel, return a String with
; the Vowel inserted 2 positions after the last Vowel replacement
; Note - if the last replacement is at the end, then do nothing
(check-expect (insert-vowel '() "e" 1) "") 
(check-expect (insert-vowel (explode "Ebuat") "a" 4) "Ebuat")
(check-expect (insert-vowel (explode "Ebuat") "a" 3) "Ebuata")
(check-expect (insert-vowel (explode "Uar") "a" 1) "Uara")
(check-expect (insert-vowel (explode "Innnt") "I" 0) "InInnt")
(check-expect (insert-vowel (explode "Hillu") "u" 4) "Hillu")
(check-expect (insert-vowel (explode "Hill") "i" 1) "Hilil")
(check-expect (insert-vowel (explode "He,") "e" 1) "He,")
(define (insert-vowel l v i)
  (cond [(empty? l) ""]
        [(< i (- (length l) 2))
         (string-append (substring (implode l) 0 (+ 2 i)) v
                        (substring (implode l) (+ 2 i)))]
        [(= (- (length l) 2) i)
         (cond [(string-alphabetic? (string-ith (implode l) (sub1 (length l))))
                (string-append (implode l) v)]
               [else
                (implode l)])]
        [else (implode l)]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Predicates

; vowel? : Letter -> Boolean
; Given a Letter, determine if it is a Vowel, regardless of case
(check-expect (vowel? "") #f)
(check-expect (vowel? "a") #t)
(check-expect (vowel? "e") #t)
(check-expect (vowel? "i") #t)
(check-expect (vowel? "o") #t)
(check-expect (vowel? "u") #t)
(check-expect (vowel? "y") #t)
(check-expect (vowel? "k") #f)
(check-expect (vowel? "O") #t)
(define (vowel? l)
  (cond [(string-ci=? l "a") #t]
        [(string-ci=? l "e") #t]
        [(string-ci=? l "i") #t]
        [(string-ci=? l "o") #t]
        [(string-ci=? l "u") #t]
        [(string-ci=? l "y") #t]
        [else #f]))
