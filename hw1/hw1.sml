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


fun number_in_month(dates : (int * int * int) list, month : int) =
    if null dates
    then 0
    else if #2 (hd(dates)) = month
    then 
    number_in_month(tl(dates), month) + 1
    else number_in_month(tl(dates), month)


fun number_in_months (dates: (int * int * int) list, months: int list) =
    if null months
    then 0
    else if null(tl(months)) 
    then number_in_month(dates, hd(months))
    else number_in_month(dates, hd(months)) + number_in_months(dates, tl(months))


fun dates_in_month(dates: (int * int * int) list, month: int) =
    if null dates
    then []
    else if #2 (hd(dates)) = month
    then hd(dates)::(dates_in_month(tl(dates), month))
    else dates_in_month(tl(dates), month)


fun dates_in_months(dates: (int * int * int) list, months: int list) =
    if null months
    then []
    else if null(tl(months)) 
    then dates_in_month(dates, hd(months))
    else dates_in_month(dates, hd(months)) @ dates_in_months(dates, tl(months))


fun get_nth(string_list: string list, n: int) =
    if n = 1
    then hd(string_list)
    else get_nth(tl(string_list), n-1)


fun date_to_string(date: (int * int * int)) =
    get_nth([
        "January",
        "February",
        "March", 
        "April",
        "May", 
        "June", 
        "July", 
        "August", 
        "September", 
        "October", 
        "November", 
        "December"
        ], #2 (date))
    ^ " " 
    ^ Int.toString(#3(date)) 
    ^ ", " 
    ^ Int.toString(#1(date))


fun number_before_reaching_sum(sum: int, numbers: int list) =
    if hd(numbers) < sum
    then 1 + number_before_reaching_sum(sum + ~(hd(numbers)), tl(numbers))
    else 0


fun what_month(day: int) =
    let
        val days_in_months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    in
        number_before_reaching_sum(day, days_in_months) + 1
    end


fun month_range(day1: int, day2: int)=
    if day1 > day2
    then []
    else what_month(day1) :: month_range(day1 + 1, day2)


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

fun number_in_months_challenge(dates: (int * int * int) list, months: int list) =
    let
        val new_months = remove_duplicates(months)
    in
        number_in_months(dates, new_months)
    end

fun dates_in_months_challenge(dates: (int * int * int) list, months: int list) =
    let 
        val new_months = remove_duplicates(months)
    in
        dates_in_months(dates, new_months)
    end

fun reasonable_date(date: int * int * int) =
    if #1 date < 1
    then false
    else if (#2 date < 1) orelse (#2 date > 12)
    then false
    else if (#3 date < 1) orelse (#3 date > 31)
    then false
    else if (#3 date = 31)
    then not (#2 date = 2 orelse (#2 date = 4) orelse (#2 date = 6) orelse (#2 date = 9) orelse (#2 date = 11))
    else if (#3 date = 29) andalso (#2 date = 2)
    then
        if not(#1 date mod 4 = 0)
        then false
        else if #1 date mod 100 = 0
        then #1 date mod 400 = 0
        else true
    else true