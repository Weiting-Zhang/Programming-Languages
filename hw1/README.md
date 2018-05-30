- [HomeWork Questions(2018.5)](https://d3c33hcgiwev3.cloudfront.net/_7a72e1fca5f6a0373860ae1c8eeddbd0_hw1.pdf?Expires=1527811200&Signature=Da3I1lyIvuDL3SxoARrt45RpDv3kpL2cDLfi91RlSOxDQ6KdlXO6E7IyO14BRP9Yfw51NCn2BJMwFKDyh2fOe9HhcJ17RF1bgEY7ReYw3hpXgkd8voMMlBmZlaTPAwJECoY3vXnDU9d4jjYefotUdDINBUaIBYSJzxfghkSX-18_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A)
- [HomeWork Source Code](./hw1.sml)
- [Test for this HomeWork](./hw1test.sml)

Here is some notes while review my homework and my classmates'.

### Problem 1

My initial version:
``` sml
fun is_older(date1 : int * int * int, date2 : int * int * int) =
    if (#1 date1) < (#1 date2) 
    then true
    else if(#1 date1) > (#1 date2)
    then false
    else
        if (#2 date1) < (#2 date2)
        then true
        else if(#2 date1) > (#2 date2)
        then false
        else
            if(#3 date1) < (#3 date2)
            then true
            else false
```

Here is a sample solution on coursera:
``` sml
fun is_older (date1 : int * int * int, date2 : int * int * int) =
    let 
        val y1 = #1 date1
        val m1 = #2 date1
        val d1 = #3 date1
        val y2 = #1 date2
        val m2 = #2 date2
        val d2 = #3 date2
    in
        y1 < y2 orelse (y1=y2 andalso m1 < m2)
                orelse (y1=y2 andalso m1=m2 andalso d1 < d2)
    end
```

Notes:

- use let expression binding values to make the program more clear and readable.
- try to use functional programming paradigm to evaluate the result instead of using imperative programming paradigm to list all the logic and steps.

### Problem 2

``` sml
fun number_in_month(dates : (int * int * int) list, month : int) =
    if null dates
    then 0
    else if #2 (hd dates) = month
    then number_in_month(tl dates, month) + 1
    else number_in_month(tl dates, month)
```

Make sure the solution has clear recursive calls and clearly evaluates to `0` if `dates` is `null`.

### Problem 3

My version:
``` sml
fun number_in_months (dates: (int * int * int) list, months: int list) =
    if null months
    then 0
    else if null(tl(months)) 
    then number_in_month(dates, hd(months))
    else number_in_month(dates, hd(months)) + number_in_months(dates, tl(months))
```

Sample solution:
``` sml
fun number_in_months(dates : (int * int * int) list, months : int list) =
    if null months
    then 0
    else number_in_month(dates, hd months) + number_in_months(dates, tl months)
```

- Since the list `months` results `0` if has no tail, the last two condition can merge.
- Remember to concern about when the list is null.

### Problem 4

``` sml
fun dates_in_month (dates : (int * int * int) list, month : int) =
    if null dates
    then []
    else if #2 (hd dates) = month
    then (hd dates)::dates_in_month(tl dates, month)
    else dates_in_month(tl dates, month)
```

### Problem 5

The same problem in problem 3:

``` sml
fun dates_in_months(dates: (int * int * int) list, months: int list) =
    if null months
    then []
    else if null(tl(months)) 
    then dates_in_month(dates, hd(months))
    else dates_in_month(dates, hd(months)) @ dates_in_months(dates, tl(months))
```

Sample solution:

``` sml
fun dates_in_months(dates : (int * int * int) list, months : int list) =
    if null months
    then []
    else dates_in_month(dates, hd months) @ dates_in_months(dates, tl months)
```

### Problem 6*

``` sml
fun get_nth(string_list: string list, n: int) =
    if n = 1
    then hd(string_list)
    else get_nth(tl(string_list), n-1)
```

This problem is not so easy as it looks...The thoughts for this `get_nth` algorithm is not to select the right one, but wait until the right one come, since you only know how to "select" the head(first one) of a list in ML. 

### Problem 7

``` sml
fun date_to_string (date : int * int * int) =
    let 
        val names = ["January", "February", "March", "April", "May", "June",
		                 "July", "August", "September", "October", "November", "December"]
    in
	    get_nth(names,#2 date) ^ " " ^ Int.toString(#3 date) 
	    ^ ", " ^ Int.toString(#1 date)
    end
```

### Problem 8*

``` sml
fun number_before_reaching_sum(sum: int, numbers: int list) =
    if hd(numbers) < sum
    then 1 + number_before_reaching_sum(sum - (hd(numbers)), tl(numbers))
    else 0
```

What you want to find is `the number before reaching sum`, the thoughts is similar to problem 6: if the first one of the list(head) is already `reaching`(larger than) the `sum`, then you can "find" the position is `0`; if after adding the second it reaches the sum, then the number is `1`. And you can think like this: it is because the second one of the given list is larger than the (`sum - hd numbers`)...and so on. Such the algorithm is: if current number is not reaching the sum, then the target position is `1 + the next number reaching sum - current number`.

### Problem 9

``` sml
fun what_month(day: int) =
    let
        val days_in_months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    in
        number_before_reaching_sum(day, days_in_months) + 1
    end
```

### Problem 10*

``` sml
fun month_range(day1: int, day2: int)=
    if day1 > day2
    then []
    else what_month(day1) :: month_range(day1 + 1, day2)
```
The algorithm is a simple recurison. You want to know how to count the month from day1 to day2, and list all of them by myself is impossible. But if I know how to count the month from `day1 + 1` to `day2`, I only need to add the month of `day1` to the head, and so on. Such we can reduce the problem until day1 greater than or equal to day2.


### Problem 11*

``` sml
fun oldest(dates: (int * int * int) list) =
    if null dates
    then NONE
    else
        let 
            val tl_oldest = oldest(tl(dates))
        in
            if isSome tl_oldest andalso is_older(valOf tl_oldest, hd dates)
            then tl_oldest
            else SOME(hd dates)
        end
```

Always save recurisive results to local if it will use in `if`s.

###  Problem 12-0*

This problem is in an earlier version of the course, and I have spent much time finishing it, so I keep it here. The problem can be find in [16-spring-hw1](https://courses.cs.washington.edu/courses/cse341/16sp/hw1.pdf).

``` sml
fun cumulative_sum(numbers: int list) =
    if null (tl numbers)
    then hd numbers :: []
    else
        let
            fun sum_helper (sum, res_number: int list) = 
                if null (tl res_number)
                then sum :: [(sum + hd res_number)]
                else  sum :: sum_helper(sum + hd res_number, tl res_number)
        in
            sum_helper (hd numbers, tl numbers)
        end
```

TODO:

### Problem 12*

My initial version:

``` sml
fun is_unique(a_month: int, months: int list) =
    if null(tl months)
    then not (a_month = hd months)
    else not (a_month = hd months) andalso is_unique(a_month, tl(months))

fun remove_duplicates(months: int list) =
    if null months
    then months
    else if null(tl months)
    then months
    else if(is_unique(hd months, tl months))
    then hd(months) :: remove_duplicates(tl months)
    else remove_duplicates(tl months)
```

The sample solution:

``` sml
(* quadratic algorithm rather than sorting which is nlog n *)
fun mem(x : int, xs : int list) =
    not (null xs) andalso (x = hd xs orelse mem(x, tl xs))
fun remove_duplicates(xs : int list) =
    if null xs
    then []
    else
        let 
            val tl_ans = remove_duplicates (tl xs)
        in
            if mem(hd xs, tl_ans)
            then tl_ans
            else (hd xs)::tl_ans
        end
```

