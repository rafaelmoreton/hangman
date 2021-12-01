# hangman
A game where the player is given a limited number of attempts to guess which secret word the computer has choosen

The computer chooses a secret word between 5 and 12 letters (case insensitive) from a wordlist using module HangmanDictionary. The choice to allocate the word selection method into a module was due to the possibility of later expansion of the module, implenenting other methods for different rules on word selection and accounting for differently formatted wordlists.

A blank space is displayed for each letter of the secret word and the player is asked for a letter input. For every letter the player inputs the program checks if it's a valid letter and adds it to a list of tried letters. Besides, if it's present in the secret word the corresponding blank spaces are substituted by the letter. Otherwise one chance is deducted.

If instead of a letter the player inputs one of the keywords 'save', 'load' or 'new' the corresponding action will take place. 'save' stores the Match object's current attributes into a hash, serialize it to YAML, save the file to the root directory and continues the game. 'load' and 'new' abort the current match and start a new one (parsing a string stored in a local YAML file into a data hash to have it's values setted as the corresponding new Match object attributes or generating fresh ones, respectively).

Credits: https://www.scrapmaker.com/view/twelve-dicts/5desk.txt for the wordlist.


# Conclusion
Making this project solidified the I/O, serialization and file manipulation concepts I've been studying. It also had the Module usefulness finnaly click to me in a pactical sense.

This is an educational project from theodinproject.com.


