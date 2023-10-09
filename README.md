# Chord_Encoder_VHDL
The following code implements Chord Encoder in VHDL

I have designed a musical chord encoder. It converts individual notes of either a three note or a four note chord into its chord name. The circuit receives a fresh byte every posisitve transition of an external clock cycle. Every note is either one or two bytes represented by its name in ascii (for example G is 01000111 as ASCII for G is 71) followed by either a sharp (ascii 31 for #) or a flat (we'll use the ascii for the small letter, for example A flat is "a" which is 01100001).

For reference, this is the order of notes

C, C# = d, D, D# = e, E = f, E# = F, F# = g, G, G# = a, A, A# = b, B = c, B# = C and follow cyclically.
In essence, the sharp of a note is the flat of the next one with the exception of E and B and similarly a flat is the sharp of a predecessor with the exception of f and c. So we will be using these interchangably.

We'll encode 4 types chords: majors, minors and suspended triads as well as 7th chords
The rules of the chords are as follows
Major triads (M) are formed by a key, followed by the 4th note after it, followed by the third one after that. For example, C M is formed by C, E and G. F# M is formed by F#, A# and C#.
Minor triads (m) are formed by a key, followed by the third note after it, followed by the fourth note after that. For example C m is formed by C, e, G. b m is formed by b, C# and F.
Suspended triads (s) are formed by a key, followed by the 5th note after it, followed by the 2nd note after that. For example, C s is formed by C, F and G. g s is formed by g, B and C#.
7ths, also called dominant 7ths (7) are formed by a major triad plus the third note after the last note of the major. For example, C 7 is formed by C, E, G and A#. e 7 is formed by e, G, b and d.
The circuit will read an input file and output to an output file. The reading and writing has been done in the testbench given.
The input file will have the following constraints:
Each line will be an 8 bit binary number representing a note or a part of it as mentioned above.
The file will not have more than 32 bytes (i.e, 32 characters)
The output must be as follows:
The testbench will read the output from your circuit and print it to an output file. It will print only one character (8 bits) per line.
Notice that since the output of your circuit is only 1 byte wide, it cannot output 2 or 3 bytes at once. Only 1 byte is output per clock cycle and whenever a byte is being output, the Data Valid output line must go from low to high.
The rules for printing a chord are as follows:
Major chords are to be printed with the note name followed by a capital M on the next line. For example C# major is to be printed as
01000011
00011111
01001101
or
01100100
01001101
Because C# is d. Note that 01001101 is M which stands for major.
Similarly for minor chords print a small m after the note
For suspended chords print a small s after the note
For dominant 7ths print the ASCII value of 7 after the note (which is 55)
Need for a buffer : Fresh data is inputted at every rising edge of the clock. You will need to wait to see what the chord is for atleast 2 clock cycles before coming to a conclusion on the chord name. Since the output data rate may be less than or equal to or greater than the input data rate over short periods, provision must be made for buffering the input data and providing a data valid output line which becomes 1 in a clock cycle in which valid data is being output. Decide on a safe buffer size based on the constraints of the input file size mentioned above (Another approach is that you can choose whatever buffer size you want but then there should be a mechanism in your circuit for handling the situation when the buffer gets full).

Note

There may be notes which do not form chords. In such cases just print those notes as they are in the input
Although obvious, preference is to be given from the left. For example, if the input is C, E, G, B, D, there could be 2 chord combinations:
(C, E, G) forming C M, followed by (B and D) forming no triad chord.
(C and E) forming no triad, followed by (G, B, D) forming G M.
In such cases, the first one is correct because the leftmost chord should be completed first.
Preference is to be given to dominant 7th chords. For example, if the input is C, E, G, A#, D, F; 2 possible chord combinations could be :
(C, E, G) forming C M followed by (A#, D, F) forming A# M and
(C, E, G, A#) forming C 7 followed by (D and F) forming no triad chord.
In such cases, the second one is correct because you are to complete a dominant 7th if it exists.
Use the following entity definition:

entity CHORDEncoder is
    	port(clk, rst: in std_logic;
    	a: in std_logic_vector(7 downto 0);
    	data_valid: out std_logic;
    	z: out std_logic_vector(7 downto 0));
end entity;
Place the input and output files in the same directory as the vhdl files. Read input from the file: test.txt and write output to the file: out.txt (that is, do not change the input and output file names and positions)

If you are using ghdl, you will need to add the -fsynopsys option while compiling. We will verify your output using the command diff -Bw true_output.txt out.txt

Further, for Q3, note that the input may get processed completely whilst your output has not been completed yet. In that case you need to pump extra clock ticks to get the complete output. We will run the simulation for 1000 ns.
