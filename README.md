# Scrambler
## A simple little word scrambler built in the Intermediate Student Language. 
### The Algorithm 
- Take all vowels in the word and replace them with the next vowel in the list
(A, E, I, O, U, (Y)), with 'Y's only being counted as a Vowel if it is inside
the String, and is not to be used as a replacement
- Insert the last vowel replacement 2 positions after it
- If the last replacement is the last 1String in the list, then do nothing
extra
- Iff there is a 'Y' in the word, then replace it with 'A' (case-insensitive)
- To account for special characters (., !, ?, etc.): if the last 1String
is, and the Vowel insertion would either replace or go after the character,
then abstain

#### Examples:
- Kensington -> Kinsongtunu
- Sponge -> Spungi
- Empty -> Impta
- Plank -> Plenek
- About -> Ebuata
- Hello -> Hillu
- He, -> Hi,
### Functions
To scramble every other word in the input string, call (scramble-main). To scramble the entire string, call the function (scramble-string).
