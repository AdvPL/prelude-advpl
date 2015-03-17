/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 Marcelo Camargo <marcelocamargo@linuxmail.org>
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/**
 * Abstaction for ranges.
 * range ::= @{ <expr> [, <expr> ] .. <expr> } ;
 */
#xtranslate @{ <nStart> .. <nEnd> } => Z_Range( <nStart>, <nEnd> )
#xtranslate @{ <nStart>, <nNext> .. <nEnd> } => ;
	Z_Range( <nStart>, <nEnd>, <nNext> )
/**
 * Prelude functions are prefixed by Z_ to preserve the whole system and avoid
 * ambiguity.
 * prelude-func ::= Prelude Function <ident> ;
 */
#xtranslate Prelude Function <cName> => Function Z_<cName>
/**
 * Prelude functions can receive from 1 to 3 arguments and we create a special
 * syntactic abstraction to handle this.
 * prelude-call ::= @<ident> { <expr> [, <expr> [, <expr> ] ] }
 */
#xtranslate @<cName> { <arg1> } => Z_<cName>( <arg1> )
#xtranslate @<cName> { <arg1>, <arg2> } => Z_<cName>( <arg1>, <arg2> )
#xtranslate @<cName> { <arg1>, <arg2>, <arg3> } => ;
	Z_<cName>( <arg1>, <arg2>, <arg3> )
/**
 * Block application.
 * block-app ::= @<ident> <expr> ::= <expr>
 */
#xtranslate @<cName> <aList> ::= <bBlock> => Z_<cName>( <bBlock>, <aList> )
/**
 * Of operator - almost the same that ::=, but with reversed operands.
 * of-op ::= @<ident> <expr> Of <expr>
 */
#xtranslate @<cName> <expr> Of <aList> => Z_<cName>( <expr>, <aList> )
/**
 * Inverse function composition with application
 * \f -> \g -> \x -> g f x
 * func-comp ::= <ident> >>= <ident> In <expr>
 */
#xtranslate <cF> >>= <cG> In <expr> => <cF>( <cG>( <expr> ) )
/**
 * Array appending abstraction
 * array-append ::= <ident>[] := <expr>
 */
#xtranslate <cVar>\[\] := <expr> => aAdd( <cVar>, <expr> )
/**
 * Use DRY methodology by avoiding code to be repeated
 */
#xtranslate @BUILD ACCUMULATOR <cAcc> => Local <cAcc> := { }, nI
#xtranslate @BUILD FIXED ACCUMULATOR <cAcc>\< <nSize> \> => ;
	Local <cAcc> := Array( <nSize> ), nI