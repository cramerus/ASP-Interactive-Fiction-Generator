# About

<b>Interactive Fiction Generator</b> is a program written in <a href="https://github.com/potassco/telingo"><b>telingo</b></a>, a solver for temporal programs based off of <b>clingo</b>, a language under the umbrella of Answer Set Programming (ASP). ASP excels at solving combinatorial problems based off logic statements. <i>Interactive Fiction</i> (IF) is a subgenre of storytelling in which readers interact with a story to have input on how it turns out. The nature of a complete IF work, with a large number of branching storylines, seemed to us to be well-suited to the strengths of ASP.

# Play the stories yourself

The provided Python script does <i>not</i> generate stories. Stories are generated using the telingo encoding and instances. Playing with the generator requires installation of telingo, though this is certainly possible (sample run statements are included in each instance file). However, we have included sample output from our program, that can be run in the command line using our Python script.

To try out the resulting stories, download the <b>results</b> folder, and the file <b>play.py</b>. Make sure that the folder and the script are in the same directory (play.py should not be <i>in</i> the results folder). If you have Python 3 installed, simply running the script in your command line should be enough to get the stories going!

Note that due to github's limits on file size, the sample stories provided are quite small. This means that the number of choices that a story can comprise has a maximum. If you use your choices 'exploring' towards the beginning of the story and do not progress as much, you may get streamlined into finishing the story in the required number of steps, meaning that you may not have as many options or may just have 1 for the rest of the story.
