# LoremIpsum
PowerShell function to create Lorem Ipsum random paragraphs.

User inputs how many paragraphs or words they need they need, defaults to 5 paragraphs.
Then, foreach paragraph generates a number of sentences between 4 and 10.
And foreach sentence, generates a number of words that are 4 to 10 characters long.
Then foreach word, randomly generates the letters.
The first letter of the sentences are capitalized and the very first words are "Lorem Ipsum" 

You cannot request more than 100 paragraphs or 5000 words. This won't be an exact number
due to the randomness of the script, but it'll be sorta close.

# SideNote
I explained to someone that I had created this and they asked why? They couldn't believe that
I would waste the time writing this.
While I agree - there are plenty of areas that have this online, I wanted to see if I could.
