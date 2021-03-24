outerjoin5
outerjoin4를 바탕으로 고객 이름 컬럼 추가하기

SELECT product.*, :cid, NVL(cycle.day, 0), NVL(cycle.cnt, 0) cnt, customer.cnm
FROM product, cycle, customer
WHERE product.pid = cycle.pid (+)
    AND cycle.cid(+) =:cid
    AND :cid = customer.cid;