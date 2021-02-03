USE publications;

#CHALLENGE 1
#STEP 1 

SELECT 
    ta.title_id,
    ta.au_id,
    (t.advance * ta.royaltyper / 100) AS advance_title_author,
    (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty
FROM
    titles t
        LEFT JOIN
    titleauthor ta ON ta.title_id = t.title_id
        LEFT JOIN
    sales s ON ta.title_id = s.title_id;

#STEP 2

Select title_id, au_id, advance_title_author, SUM(sales_royalty) as total_royalty from
(SELECT 
    ta.title_id,
    ta.au_id,
    (t.advance * ta.royaltyper / 100) AS advance_title_author,
    (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty
FROM
    titles t
        LEFT JOIN
    titleauthor ta ON ta.title_id = t.title_id
        LEFT JOIN
    sales s ON ta.title_id = s.title_id) step_1
    group by title_id, au_id;
    
#STEP 3

SELECT 
    au_id, (advance_title_author + total_royalty) AS Profit
FROM
    (SELECT 
        title_id,
            au_id,
            advance_title_author,
            SUM(sales_royalty) AS total_royalty
    FROM
        (SELECT 
        ta.title_id,
            ta.au_id,
            (t.advance * ta.royaltyper / 100) AS advance_title_author,
            (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty
    FROM
        titles t
    LEFT JOIN titleauthor ta ON ta.title_id = t.title_id
    LEFT JOIN sales s ON ta.title_id = s.title_id) step_1
    GROUP BY title_id , au_id) step_2
    order by Profit desc
    limit 3;
    
    #CHALLENGE 2
    #STEP 1
    CREATE TEMPORARY TABLE step_1
    SELECT 
    ta.title_id,
    ta.au_id,
    (t.advance * ta.royaltyper / 100) AS advance_title_author,
    (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty
FROM
    titles t
        LEFT JOIN
    titleauthor ta ON ta.title_id = t.title_id
        LEFT JOIN
    sales s ON ta.title_id = s.title_id;
    
    #STEP 2 
    CREATE TEMPORARY TABLE step_123
    Select title_id, au_id, advance_title_author, SUM(sales_royalty) as total_royalty from step_1
    group by title_id, au_id;
    
    #STEP 3
   SELECT au_id, (advance_title_author + total_royalty) AS Profit FROM
    step_12
ORDER BY Profit DESC
LIMIT 3;

	#CHALLENGE 3
    CREATE TABLE most_profiting_authors SELECT au_id, (advance_title_author + total_royalty) AS Profit FROM
    step_12
ORDER BY Profit DESC
LIMIT 3;
    
select * from most_profiting_authors