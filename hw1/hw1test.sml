val test1 = is_older((1998, 12, 13), (1998, 12, 14)) andalso not (is_older((1111, 1, 11), (1111, 1, 11)));

val test2 = number_in_month([(1888, 12, 31), (1999, 9, 25), (2099, 7, 15), (2008, 9, 25)], 9) = 2;

val test3 = number_in_months([(1888, 12, 31), (1999, 9, 25), (2099, 7, 15), (2008, 9, 25)], [7, 9]) = 3 andalso (number_in_months([(1,2,25),(3,5,26),(1,12,29),(3,2,28),(1,2,27),(1,2,25),(6,7,8)], []) = 0)

val test4 = dates_in_month([(21, 1, 1998), (22, 2, 1997), (23, 3, 1997), (25, 2, 1088)], 2) = [(22,2,1997), (25,2,1088)] andalso (null (dates_in_month([(21, 1, 1998), (22, 2, 1997), (23, 3, 1997), (25, 2, 1088)], 4)))

val test5 = dates_in_months([(21, 1, 1998), (22, 2, 1997), (23, 3, 1997), (25, 2, 1088)], [2, 3]) = [(22,2,1997), (25,2,1088), (23,3,1997)] andalso (null (dates_in_months([(21, 1, 1998), (22, 2, 1997), (23, 3, 1997), (25, 2, 1088)], [10, 11, 12]))) andalso (dates_in_months ([(1,2,25),(3,5,26),(1,12,29),(3,2,28),(1,2,27),(1,2,25),(6,7,8)], []) = [])

val test6 = get_nth(["AB","CD", "EF", "GH"], 3) = "EF";

val test7 = date_to_string(2018, 12, 31) = "December 31, 2018";

val test8 = number_before_reaching_sum(15, [1, 2, 3, 4, 5, 6]) = 4 andalso (number_before_reaching_sum(15, [1, 2, 3, 4, 4, 5, 6]) = 5);

val test9 = what_month(33) = 2;

val test10 = month_range(30, 33) = [1, 1, 2, 2];

val test11 = oldest([(2018, 10, 30), (2018, 10, 25), (2018, 10, 31), (1995, 11, 31)]) = SOME (1995,11,31) andalso (oldest [] = NONE);

val test12 = cumulative_sum([1, 2, 3, 4, 5]) = [1, 3, 6, 10, 15] andalso (cumulative_sum([12, 27, 13]) = [12, 39, 52]) andalso (cumulative_sum([2]) = [2]);

val test13 = number_in_months_challenge([(31, 12, 1888), (25, 9, 1999), (15, 7, 2099), (25, 9, 2008)], [7, 9, 8, 9]) = 3  andalso (number_in_months_challenge ([(1,2,25),(3,5,26),(1,12,29),(3,2,28),(1,2,27),(1,2,25),(6,7,8)], []) = 0) andalso (dates_in_months_challenge([(31, 12, 1888), (25, 9, 1999), (15, 7, 2099), (25, 9, 2008)], [7, 9, 8, 9]) = [(15,7,2099), (25,9,1999), (25,9,2008)]) andalso (dates_in_months_challenge([(1,2,25),(3,5,26),(1,12,29),(3,2,28),(1,2,27),(1,2,25),(6,7,8)], []) = []);

val test14 = not (reasonable_date(23, 12, 0)) andalso (reasonable_date(23, 12, 31)) andalso (reasonable_date(2008, 2, 29)) andalso not (reasonable_date(1900, 2, 29));
