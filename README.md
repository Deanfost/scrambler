# Scrambler
## A simple little word scrambler built in the Intermediate Student Language. 
### The Algorithm 
- Take all vowels in the word and replace them with the next vowel in the list
(A, E, I, O, U, (Y)), with 'Y's only being counted as a Vowel if it is inside
the String, and is not to be used as a replacement
- Iff there is a 'Y' in the word, then replace it with 'A' (case-insensitive),
  with that new 'A' becoming the new candidate for insertion
- Insert the last vowel replacement 2 positions after itself
- If the last replacement is the last 1String in the list, then do nothing
extra
- Only perform insertions if the entire current String is alphabetical
- Unless the entire currnet String is upper-case, ensure the insertion is lower-case

#### Examples
- Kensington -> Kinsongtunu
- Sponge -> Spungi
- Empty -> Impta
- Plank -> Plenek
- About -> Ebuata
- Hello -> Hillu
- He, -> Hi,
- (Wow) -> (Wuw)
- HELL -> HILIL
- Hell -> Hilil

### Functions
To use the algorithm, call the function (scramble-main String).

### Note
This program assumes that you are passing in a proper English phrase or sentence (with the exception in acronyms or capitalized words). As a result, Strings with typos or seemingly misplaced capital letters would return a slightly unexpected result.

Ex. 
- WOW -> WUWU
- wOw -> wUwu
