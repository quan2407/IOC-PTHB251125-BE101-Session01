set search_path to customersales;
-- Yêu cầu 1: Viết truy vấn hiển thị tổng doanh thu và tổng số đơn hàng của mỗi khách hàng
SELECT customer_name, sum(total_amount) total_revenue, count(order_id) order_count
FROM customers c
JOIN customersales.orders o on c.customer_id = o.customer_id
GROUP BY o.customer_id,c.customer_name;
-- Yêu cầu 2: Viết truy vấn con (Subquery) để tìm doanh thu trung bình
-- 2a. Hiển thị những khách hàng có doanh thu lớn hơn mức trung bình đó
SELECT customer_name,avg(total_amount)
FROM customers c
JOIN customersales.orders o on c.customer_id = o.customer_id
GROUP BY o.customer_id,c.customer_name
HAVING avg(total_amount) >
(SELECT AVG(total_amount)
FROM orders);
-- Yêu cầu 3: Dùng HAVING + GROUP BY để lọc ra thành phố có tổng doanh thu cao nhất
SELECT c.city, SUM(o.total_amount) as total_revenue
FROM customers c
         JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city
HAVING SUM(o.total_amount) = (
    SELECT SUM(o2.total_amount)
    FROM customers c2
             JOIN orders o2 ON c2.customer_id = o2.customer_id
    GROUP BY c2.city
    ORDER BY SUM(o2.total_amount) DESC
    LIMIT 1
);
-- Yêu cầu 4: Dùng INNER JOIN giữa customers, orders, order_items để hiển thị chi tiết
-- 4a. Tên khách hàng, tên thành phố, tổng sản phẩm đã mua, tổng chi tiêu
SELECT
    c.customer_name,
    c.city,
    SUM(oi.quantity) AS total_products_count,
    SUM(oi.quantity * oi.price) AS total_spent
FROM
    customers c
        INNER JOIN
    orders o ON c.customer_id = o.customer_id
        INNER JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY
    c.customer_id, c.customer_name, c.city;

