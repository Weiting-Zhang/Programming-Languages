fun same_string(s1 : string, s2 : string) =
    s1 = s2

fun all_except_option (str, xs) =
    case xs of
        [] => NONE
        | x :: xs' => 
            if same_string(str, x)
            then SOME xs'
            else case all_except_option(str, xs') of
                NONE => NONE
              | SOME ls => SOME (x :: ls)

fun get_substitutions1(xs, s) =
    case xs of
       [] => []
     | x :: xs' => case all_except_option(s, x) of
        NONE => get_substitutions1(xs', s)
      | SOME ls => ls @ get_substitutions1(xs', s)


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

fun similar_names (substitutions,name) =
    let 
        val {first=x1, middle=x2, last=x3} = name
	      fun get_names xs =
	         case xs of
		           [] => []
	           | x::xs' => {first=x, middle=x2, last=x3}::(get_names(xs'))
    in
	      name::get_names(get_substitutions1(substitutions, x1))
    end


datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

fun card_color(the_suit, the_rank) =
    case the_suit of
       Clubs => Black
     | Spades => Black
     | Diamonds => Red
     | Hearts => Red

fun card_value(the_suit, the_rank) =
    case the_rank of
       Ace => 11
     | Num n => n
     | _ => 10

fun remove_card(cs, c, e) =
    case cs of
       [] => raise IllegalMove
     | head::tail => 
        if head = c
        then tail
        else head :: remove_card(tail, c, e)

fun all_same_color cards =
    case cards of
       [] => true
     | c::cs => case cs of
        [] => true
      | c'::cs' => card_color c = card_color c' andalso all_same_color cs

fun sum_cards cards =
    let
        fun aux(cards, acc) =
            case cards of
               [] => acc
             | c::cs => aux(cs, card_value c + acc)
    in
        aux(cards, 0)
    end

fun score (held_cards, goal) =
    let
        val sum = sum_cards held_cards
        fun pre_score(sum, goal) =
            if sum > goal
            then 3 * (sum - goal)
            else goal - sum
    in
        if all_same_color held_cards
        then pre_score(sum, goal) div 2
        else pre_score(sum, goal)
    end

fun officiate (card_list, moves, goal) =
    let
        fun play(card_list, current_helds, remain_moves) =
            case remain_moves of
               [] => current_helds
             | head::tail => case head of
                Discard c => play(card_list, remove_card(current_helds, c, IllegalMove), tail)
              | Draw => case card_list of
                 [] => current_helds
               | c::cs => 
                    if sum_cards (c::current_helds) > goal
                    then c::current_helds
                    else play(cs, c::current_helds, tail)
    in
        score (play(card_list,[], moves), goal)
    end

fun score_challenge (held_cards, goal) =
    let
        val sum = sum_cards held_cards
        fun better_score(held_cards, sum) =
            case held_cards of
               [] => 3 * (sum - goal)
             | (the_suit, the_rank)::cs => 
                case the_rank of
                   Ace => 
                    if sum - 10 > goal
                    then better_score(cs, sum - 10)
                    else Int.min(goal - (sum - 10), 3 * (sum - goal))
                 | _ => better_score(cs, sum)
        fun pre_score(sum, goal) =
            if sum > goal
            then better_score(held_cards, sum)
            else goal - sum
    in
        if all_same_color held_cards
        then pre_score(sum, goal) div 2
        else pre_score(sum, goal)
    end


fun card_value_min (the_suit, the_rank)=
    case the_rank of
       Ace => 1
     | Num n => n
     | _ => 10

fun sum_cards_min cards =
    let  
        fun aux(cards, acc) =
            case cards of
               [] => acc
             | c::cs => aux(cs, card_value_min c + acc)
    in
        aux(cards, 0)
    end

fun officiate_challenge (card_list, moves, goal) =
    let
        fun play(card_list, current_helds, remain_moves) =
            case remain_moves of
               [] => current_helds
             | head::tail => case head of
                Discard c => play(card_list, remove_card(current_helds, c, IllegalMove), tail)
              | Draw => case card_list of
                 [] => current_helds
               | c::cs => 
                    if sum_cards_min (c::current_helds) > goal
                    then c::current_helds
                    else play(cs, c::current_helds, tail)
    in
        score_challenge (play(card_list,[], moves), goal)
    end

fun careful_player (card_list, goal) =
    let
        fun careful_moves(card_list, helds, moves) =
            let 
                fun remove_reach_zero (cards, goal) =
                    case cards of
                        [] => NONE
                      | c::cs => if sum_cards(remove_card (cards, c, IllegalMove)) = goal then SOME c
                                 else remove_reach_zero (cs, goal - card_value c)
            in
                case card_list of
                    [] => moves
                  | c::cs =>
                        if goal - sum_cards helds > 10
                        then careful_moves (cs, c::helds, moves @ [Draw])
                        else if goal = sum_cards helds
                        then moves
                        else case remove_reach_zero (c::helds, goal) of
                            NONE => if sum_cards (c::helds) > goal then moves
                                    else careful_moves(cs, c::helds, moves @ [Draw])
                          | SOME cd => moves @ [Discard cd, Draw]
            end
    in
        careful_moves(card_list, [], [])
    end