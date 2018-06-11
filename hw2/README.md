- [HomeWork Questions(2018.6)](https://d3c33hcgiwev3.cloudfront.net/_bb712e620e1c46bbc8ce7ebb7a7cac05_hw2.pdf?Expires=1528070400&Signature=ERvcZGNdOzhTAd5pOM2Ypg260aMjPAHGhTSfvtSIseu4TD8-z8QcTxwfsHedkOMBY0CganNccfSw8G5beI5y-X334jA4owJwHYLSOyz9cg-T7x0X2TDPqTLQ3YWLJ9Atbxq0BELyoO-xCViDc~m7e48jvTSwYQKzEfbIy8G0r34_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A)
- [HomeWork Source Code](./hw2.sml)
- [Test for this HomeWork](./hw2test.sml)

### Problem 1a

Solution:
``` sml
fun all_except_option (str, xs) =
    case xs of
        [] => NONE
        | x :: xs' => 
            if same_string(str, x)
            then SOME xs'
            else case all_except_option(str, xs') of
                NONE => NONE
              | SOME ls => SOME (x :: ls)
```

It's a bit like remove dulicates' algorithm. Since the problem assume the string is in the list at most once, we can just return SOME `tail` if the `head` is same with the given string, and recursive call `all_except_option` function if the `head` is not the same as the given string.


### Problem 1b

This problem is very simple with part(a) already solved.

``` sml
fun get_substitutions1(xs, s) =
    case xs of
       [] => []
     | x :: xs' => case all_except_option(s, x) of
        NONE => get_substitutions1(xs', s)
      | SOME ls => ls @ get_substitutions1(xs', s)
```

### Problem 1c*

**Tail recursion** : use accumulators as a technique to make some functions tail recursive.

``` sml
fun get_substitutions2(xs, s) =
    let
        fun aux(xs, s, acc) =
            case xs of
               [] => acc
             | x :: xs' => case all_except_option(s, x) of
                NONE => aux(xs', s, acc)
              | SOME ls => aux(xs', s, ls @ acc)
    in
        aux(xs, s, [])
    end
```

The base case in the non-accumulator style(Partb) becomes the initial accumulator and the base case in the accumulator style(Partc) just returns the accumulator.

Why might get_substitutions2 be preferred when it is clearly more complicated? 

We need to understand a little bit about how function calls are implemented. Conceptually, there is a call stack, which is a stack (the data structure with push and pop operations) with one element for each function call that has been started but has not yet completed. Each element stores things like the value of local variables and what part of the function has not been evaluated yet. When the evaluation of one function body calls another function, a new element is pushed on the call stack and it is popped off when the called function completes.

So for get_substitutions1, there will be one call-stack element (sometimes just called a “stack frame”) for each recursive call to get_substitutions1, i.e., the stack will be as big as the list. This is necessary because after each stack frame is popped off the caller has to, “do the rest of the body” — namely add y to the recursive result and return.

Given the description so far, get_substitutions2 is no better: get_substitutions2 makes a call to f which then makes one recursive call for each list element. However, when f makes a recursive call to f, **there is nothing more for the caller to do after the callee returns except return the callee’s result. This situation is called a tail call** (let’s not try to figure out why it’s called this) and functional languages like ML typically promise an essential optimization: When a call is a tail call, the caller’s stack-frame is popped **before** the call — the callee’s stack-frame just **replaces** the caller’s. This makes sense: the caller was just going to return the callee’s result anyway. Therefore, calls to get_substitutions2 never use more than 1 stack frame.

Why do implementations of functional languages include this optimization? By doing so, **recursion can sometimes be as efficient as a while-loop**, which also does not make the call-stack bigger. The “sometimes” is exactly when calls are tail calls, something you the programmer can reason about since you can look at the code and identify which calls are tail calls.

Tail calls do not need to be to the same function (f can call g), so they are more flexible than while-loops that always have to “call” the same loop. **Using an accumulator is a common way to turn a recursive function into a “tail-recursive function”**(one where all recursive calls are tail calls), but not always. For example, functions that process trees (instead of lists) typically have call stacks that grow as big as the depth of a tree, but that’s true in any language: while-loops are not very useful for processing trees.

### Problem 1d

Nothing but records and pattern matching.

``` sml
fun similar_names (substitutions,name) =
    let 
        val {first=f, middle=m, last=l} = name
	      fun make_names xs =
	         case xs of
		           [] => []
	           | x::xs' => {first=x, middle=m, last=l}::(make_names(xs'))
    in
	      name::make_names(get_substitutions2(substitutions,f))
    end
```

officiate_challenge: Your function returns an incorrect result when the game should end due to the sum of cards in the player's hand exceeding the goal. [incorrect answer]

officiate_challenge: Your function returns an incorrect result when an ace is in the players hand. [incorrect answer]

officiate_challenge: Your function returns an incorrect result when the game should end due to an empty move list with low score. [incorrect answer]


### Problem 2a

``` sml
fun card_color(the_suit, the_rank) =
    case the_suit of
       Clubs => Black
     | Spades => Black
     | Diamonds => Red
     | Hearts => Red
```

where we can also **use the wildcard pattern** make it like this:
```sml
fun card_color card =
    case card of
        (Clubs,_)    => Black
      | (Diamonds,_) => Red
      | (Hearts,_)   => Red
      | (Spades,_)   => Black
```

### Problem 2b

``` sml
fun card_value card =
    case card of
	      (_,Jack) => 10
      | (_,Queen) => 10
      | (_,King) => 10
      | (_,Ace) => 11 
      | (_,Num n) => n
```

### Problem 2c

Very simple recurision.

``` sml
fun remove_card(cs, c, e) =
    case cs of
       [] => raise IllegalMove
     | head::tail => 
        if head = c
        then tail
        else head :: remove_card(tail, c, e)
```

### Problem 2d

My version:

``` sml
fun all_same_color cards =
    case cards of
       [] => true
     | c::cs => case cs of
        [] => true
      | c'::cs' => card_color c = card_color c' andalso all_same_color cs
```

Even more concise: use wildcard to match lists only has one element:

``` sml
fun all_same_color cs = 
    case cs of
        [] => true
      | [_] => true
      | head::neck::tail => card_color head = card_color neck 
			    andalso all_same_color(neck::tail)
```


careful_player: Your function returns an incorrect result when given a hand of [(Spades,Num 7),(Hearts,King),(Clubs,Ace),(Diamonds,Num 2)] and a goal of 18 [incorrect answer]

careful_player: Your function returns an incorrect result when given a hand of [(Diamonds,Num 2),(Clubs,Ace)] and a goal of 11 [incorrect answer]
Used '#' 1 times.

Because the auto-grader gave a score above 80, here is the link to a message from a very cute dog: https://drive.google.com/file/d/0B5sUgbs6aDNpN2ppTUpyVDlQX0U/view?pref=2&pli=1