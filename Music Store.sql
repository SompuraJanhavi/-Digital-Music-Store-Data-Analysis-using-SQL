use janvi;

# import the files

select * from album;
select * from cust;
select * from employee e ;
select * from genre g ;
select * from invoicee ;
select * from invoice_line ;
select * from media_type mt ;
select * from playlist p ;
select * from playlist_track ;
select * from track t ;
select * from artist a ;
show tables;

# cheak datatypes

desc album;
desc cust;
desc employee ;
desc genre;
desc invoice ;
desc invoice_line ;
desc media_type ;
desc playlist ;
desc playlist_track ;
desc track;
desc artist ;

# here invoicee table has Date columns there datatype is "varchar" to convert in to "Date"
update invoice set invoice_date = str_to_date(invoice_date , "%Y-%m-%d");

alter table invoice modify invoice_date date;

                                    # Question Set 1 - Easy # 

# 1. Who is the senior most employee based on job title?

select title , max(levels),concat(first_name," ",last_name )Full_name from employee 
group by title , full_name order by max(levels)desc limit 1;

#2. Which countries have the most Invoices?

select billing_country , count(total)Total from invoice group by billing_country order by total desc limit 1   ;

#3. What are top 3 values of total invoice?

select * from invoice order by total desc limit 3 ;

#4. Which city has the best customers? We would like to throw a promotional Music 
     #Festival in the city we made the most money. Write a query that returns one city that 
     #has the highest sum of invoice totals. Return both the city name & sum of all invoice totals

select billing_city , sum(total)Total from invoice group by billing_city order by Total desc limit 1  ;

#5. Who is the best customer? The customer who has spent the most money will be 
    #declared the best customer. Write a query that returns the person who has spent the most money

select customer_id , sum(total) Total from invoice group by customer_id order by total desc limit 1 ;

select first_name from cust where customer_id =5;
                                         #OR
SELECT c.customer_id,  SUM(total) AS total_spending
FROM cust c
JOIN invoice ON c.customer_id = invoice.customer_id
GROUP BY c.customer_id
ORDER BY total_spending DESC
LIMIT 1;see

                                     #Question Set 2 – Moderate#

#1. Write query to return the email, first name, last name, & Genre of all Rock Music 
    #listeners. Return your list ordered alphabetically by email starting with A

select c.first_name , c.last_name , c.email , g.name from cust c 
join invoice i  on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id =il.invoice_id 
join track t on  il.track_id = t.track_id 
join genre g on g.genre_id = t.genre_id where g.name = "Rock" and c.email like "A%";

#2. Let's invite the artists who have written the most rock music in our dataset. Write a 
    #query that returns the Artist name and total track count of the top 10 rock bands

select a.artist_id , a.name , count(a.artist_id)Num_of_songs from artist a join album a2 
on a.artist_id =a2.album_id join track t 
on a2.album_id =t.album_id join genre g 
on t.genre_id = g.genre_id where g.name ="rock" group by a.artist_id ,a.name
order by num_of_songs desc limit 10;


#3. Return all the track names that have a song length longer than the average song length. 
    #Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first

select name, avg(milliseconds) from track
group by name order by avg(milliseconds) desc;

                                           #Question Set 3 – Advance#
#1. Find how much amount spent by each customer on artists? Write a query to return
    #customer name, artist name and total spent

select concat(c.first_name ,' ',c.last_name )Cust_name , a3.name Artist_name , 
sum(il.unit_price*il.quantity)Total_spent
from cust c join invoice i  on c.customer_id =i.customer_id  
join invoice_line il on i.invoice_id =il.invoice_id 
join track t on il.track_id =t.track_id 
join album a2 on a2.album_id =t.album_id 
join artist a3 on a3.artist_id = a2.artist_id 
group by Cust_name , Artist_name order by total_spent desc ;


#2. We want to find out the most popular music Genre for each country. We determine the 
    #most popular genre as the genre with the highest amount of purchases. Write a query 
    #that returns each country along with the top Genre. For countries where the maximum 
    #number of purchases is shared return all Genres

select c.country , count(il.quantity) , g.name , g.genre_id from cust c 
join invoice i on c.customer_id = i.customer_id 
join invoice_line il on i.invoice_id =il.invoice_line_id 
join track t on il.track_id = t.track_id 
join genre g on t.genre_id =t.genre_id 
group by c.country , g.name , g.genre_id;



#3. Write a query that determines the customer that has spent the most on music for each country. 
    #Write a query that returns the country along with the top customer and howmuch they spent.
    # For countries where the top amount spent is shared, provide all customers who spent this amount

select concat(c.first_name," ",c.last_name)full_name, c.country,sum(i.total)spent_of_money from cust c
join invoice i on c.customer_id =i.customer_id 
group by 1,2 order by spent_of_money desc;




