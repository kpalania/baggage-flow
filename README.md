# Airport Baggage

NOTE: I can create an equivalent version of this in either Java or JavaScript (Node/Express) but I am doing some Ruby work currently and it was easier to write this in Ruby rather than switch environments to Eclipse, etc. Having said that, I am happy to solve one of the other 2 problems in either one of those languages :)

To run this solution, you just have to have Ruby installed.

`$ls`

```code
README.md input     lib       output    run.rb
```

`$ruby run.rb` 

```html
...(bunch of debug statements followed by the requested output)

OUTPUT
------
0001 Concourse_A_Ticketing A5 A1 : 11
0002 A5 A1 A2 A3 A4 : 9
0003 A2 A1 : 1
0004 A8 A9 A10 A5 : 6
0005 A7 A8 A9 A10 A5 BaggageClaim  : 12
```