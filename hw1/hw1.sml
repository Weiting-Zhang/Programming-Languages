fun is_older(date1 : int * int * int, date2 : int * int * int) =
    let
        val y1 = #1 date1
        val m1 = #2 date1
        val d1 = #3 date1
        val y2 = #1 date2
        val m2 = #2 date2
        val d2 = #3 date2
    in
        y1 < y2 orelse (y1 = y2 andalso m1 < m2) 
        orelse (y1 = y2 andalso m1 = m2 andalso d1 < d2)
    end


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
    then 1 + number_before_reaching_sum(sum - (hd(numbers)), tl(numbers))
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
    let    
        fun get_nth (lst : int list, n : int) =
        if n=1
        then hd lst
        else get_nth(tl lst, n-1)
        val year  = #1 date
        val month = #2 date
        val day   = #3 date
        val leap  = year mod 400 = 0 orelse (year mod 4 = 0 andalso year mod 100 <> 0)
        val feb_len = if leap then 29 else 28
        val lengths = [31,feb_len,31,30,31,30,31,31,30,31,30,31]
    in
        year > 0 andalso month >= 1 andalso month <= 12
        andalso day >= 1 andalso day <= get_nth(lengths,month)
    end