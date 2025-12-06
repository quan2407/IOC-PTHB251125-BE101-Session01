set search_path to sales;


-- Yêu cầu 1: Viết truy vấn con (Subquery) để tìm sản phẩm có doanh thu cao nhất (Hiển thị product_name, total_revenue)
SELECT
    product_name,
    SUM(total_price) AS total_revenue
FROM
    products p
        JOIN
    orders o ON p.product_id = o.product_id
GROUP BY
    p.product_id, product_name
HAVING
    SUM(total_price) = (
        SELECT MAX(sub.total_revenue_per_product)
        FROM (
                 SELECT SUM(o.total_price) AS total_revenue_per_product
                 FROM orders o
                 GROUP BY o.product_id
             ) sub
    );

-- Yêu cầu 2: Viết truy vấn hiển thị tổng doanh thu theo từng nhóm category (dùng JOIN + GROUP BY)
SELECT
    category,
    SUM(total_price) AS total_revenue
FROM
    products p
        JOIN
    orders o ON p.product_id = o.product_id
GROUP BY
    category;


-- Yêu cầu 3: Dùng INTERSECT để tìm ra nhóm category có sản phẩm bán chạy nhất (ở câu 1) cùng nằm trong danh sách nhóm có tổng doanh thu lớn hơn 3000

-- Phần 1: Category chứa sản phẩm bán chạy nhất
(
    SELECT
        category
    FROM
        products p
            JOIN
        orders o ON p.product_id = o.product_id
    GROUP BY
        p.product_id, category
    HAVING
        SUM(total_price) = (
            SELECT MAX(sub.total_revenue_per_product)
            FROM (
                     SELECT SUM(total_price) AS total_revenue_per_product
                     FROM orders
                     GROUP BY product_id
                 ) sub
        )
)
INTERSECT
-- Phần 2: Category có tổng doanh thu lớn hơn 3000
(
    SELECT
        category
    FROM
        products p
            JOIN
        orders o ON p.product_id = o.product_id
    GROUP BY
        category
    HAVING
        SUM(total_price) > 3000
);


