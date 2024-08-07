----------------------------------------호텔이름으로 검색----------------------------------------------------------
select * from hotel where hotel_name like '%${hotelName}%'; --mybatis용
select * from hotel where hotel_name like '%호텔%';

select * from hotel where hotel_name like '%호텔%';

select * from hotel join hotel_room using(hotel_code);



----검색 시 최저가 하나만 나타나도록
select hotel_code, hotel_name, hotel_eng, hotel_address, to_char(hotel_price, '999,999,999') as hotel_price, room_discount, hotel_pic, hotel_score, hotel_review_num, rownum rn
from V_hotel_list 
where SUBSTR(hotel_code, 1, 3) = '2OS' and room_cap >= 3;

SELECT hotel_code, hotel_name, hotel_eng, hotel_address, 
       TO_CHAR(hotel_price, '999,999,999') AS hotel_price, 
       room_discount, hotel_pic, hotel_score, hotel_review_num, rn
FROM (
    SELECT hotel_code, hotel_name, hotel_eng, hotel_address, 
           hotel_price, room_discount, hotel_pic, hotel_score, hotel_review_num,
           ROW_NUMBER() OVER (PARTITION BY hotel_code ORDER BY hotel_price) AS rn
    FROM V_hotel_list
    WHERE SUBSTR(hotel_code, 1, 3) = '2OS'
    AND room_cap >= 2
)
WHERE rn = 1;

select * from hotel_room where room_cap >= 3 order by hotel_code, hotel_price;

----------------------------------------객실 정보랑 호텔 상세정보랑 합친 table----------------------------------------
select hotel_name, hotel_eng, hotel_address, hotel_call, hotel_check_in, hotel_check_out, hotel_policy, hotel_intro, room_cat, hotel_price, room_att 
from hotel 
    join hotel_room using(hotel_code);


--사진 정보까지 합치기

select hotel_name, hotel_eng, hotel_address, hotel_call, hotel_check_in, hotel_check_out, hotel_policy, hotel_intro, room_cat, hotel_price, room_att 
from hotel 
    join hotel_room using(hotel_code);
	
select * 
from hotel
    join hotel_pic using(hotel_code)
    join hotel_room using(hotel_code)
where hotel_code='2OS001';

desc hotel_room;


------------펀의시설-------------
select * from hotel_facility where hotel_code='2OS001';

select * from hotel_facility;

select * from hotel_room where hotel_code='2OS001';

desc hotel_room;

insert into hotel_room values (
    '2', '3', '3', '2OS001', '171259', 0,  5
);


--------------------------------------------편의시설에 번호 메기기-------------------------------------------
update hotel_facility
set hotel_fac_cat ='1'
where hotel_fac_cat ='주차';
-- 0:무선인터넷 1:주차 2:레스토랑 3:수영장 4:피트니스센터 5:에어컨 6:바 7:카지노
-- 무선인터넷은 냉장고를 바꾼 것
--크롤링했을때 위에 자료들 들고 들어와지면 그때 밑에 구문 사용해서 번호 메기면 됨


------------------------------------- 리뷰 ----------------------------------------
----dto 에 추가할 때 reviewDate, rateAvg 로 필드명 추가
select user_id, tripper_cat, review_title, review_comment, SUBSTR(hotel_reserve_code, 1, 4) || '년 ' || SUBSTR(hotel_reserve_code, 5, 2) || '월 ' || SUBSTR(hotel_reserve_code, 7, 2) || '일' as review_date, 
hotel_facility, hotel_clean, hotel_conven, hotel_kind, (hotel_facility + hotel_clean + hotel_conven + hotel_kind)/4 as rate_avg
from hotel_review 
join hotel_reserve hr using (hotel_reserve_code)
    where hr.hotel_code = '2OS001';


--페이징처리 위한 sql --> 한페이지에 몇개 띄울건지.. startRonum이랑 endRounum 사이
select s2.* 
from
    (select s1.*, rownum rn 
    from
        (select user_id, tripper_cat, review_title, review_comment, SUBSTR(hotel_reserve_code, 1, 4) || '년 ' || SUBSTR(hotel_reserve_code, 5, 2) || '월 ' || SUBSTR(hotel_reserve_code, 7, 2) || '일' as review_date, 
                hotel_facility, hotel_clean, hotel_conven, hotel_kind, (hotel_facility + hotel_clean + hotel_conven + hotel_kind)/4 as rate_avg
        from hotel_review 
            join hotel_reserve hr using (hotel_reserve_code)
        where hr.hotel_code = '2OS001'
            order by review_date desc) 
    s1)
s2;
--WHERE RN BETWEEN #{startRounum} AND #{endRounum}    ;  


--- 리뷰 페이지 수 (호텔마다 페이지 수 달라짐)   
select count(*) from hotel_review
where hotel_code = '2OS001';

    
    

------리뷰 전체 평균 구하기
--각 평점 항목 평균 먼저 구하기 -> chart js 용 
select count(*), avg(hotel_facility), avg(hotel_clean), avg(hotel_conven), avg(hotel_kind) from hotel_review
    join hotel_reserve hr using (hotel_reserve_code)
where hr.hotel_code = '2OS001';


--각 평점 항목 평균 가지고 전체 평균 구하기 + 전체 리뷰 갯수 불러오기 --> chart js 왼쪽에 표시될 내용 
select (avg(hotel_facility) + avg(hotel_clean) + avg(hotel_conven) + avg(hotel_kind))/4 as all_rate_avg from hotel_review
    join hotel_reserve hr using (hotel_reserve_code)
where hr.hotel_code = '2OS001';


---------위에 두개 합치기
select count(*) as review_count, ROUND(avg(hotel_facility), 1) as avg_hotel_facility, ROUND(avg(hotel_clean), 1) as avg_hotel_clean, ROUND(avg(hotel_conven),1) as avg_hotel_conven, ROUND(avg(hotel_kind),1) as avg_hotel_kind, 
        ROUND((avg(hotel_facility) + avg(hotel_clean) + avg(hotel_conven) + avg(hotel_kind))/4, 1) as avg_all_rate
from hotel_review
    join hotel_reserve hr using (hotel_reserve_code)
where hr.hotel_code = '2OS001';      


--- 다 같이 합치기
SELECT hr.user_id, hr.tripper_cat, hr.review_title, hr.review_comment, SUBSTR(hr.hotel_reserve_code, 1, 4) || '년 ' || SUBSTR(hr.hotel_reserve_code, 5, 2) || '월 ' || SUBSTR(hr.hotel_reserve_code, 7, 2) || '일' as review_date, 
    hr.hotel_facility, hr.hotel_clean, hr.hotel_conven,  hr.hotel_kind, (hr.hotel_facility + hr.hotel_clean + hr.hotel_conven + hr.hotel_kind)/4 as rate_avg,
    stats.reply_count, stats.avg_hotel_facility, stats.avg_hotel_clean, stats.avg_hotel_conven, stats.avg_hotel_kind, stats.avg_all_rate
FROM 
    (SELECT hotel_reserve_code, user_id, tripper_cat, review_title, review_comment, hotel_facility, hotel_clean, hotel_conven, hotel_kind
    FROM hotel_review 
        JOIN hotel_reserve hr USING (hotel_reserve_code)
    WHERE hr.hotel_code = '2OS001'
    ) hr,
        (SELECT count(*) as reply_count, avg(hotel_facility) as avg_hotel_facility, avg(hotel_clean) as avg_hotel_clean, avg(hotel_conven) as avg_hotel_conven, avg(hotel_kind) as avg_hotel_kind, 
        (avg(hotel_facility) + avg(hotel_clean) + avg(hotel_conven) + avg(hotel_kind))/4 as avg_all_rate
        FROM hotel_review
          JOIN hotel_reserve hr USING (hotel_reserve_code)
        WHERE hr.hotel_code = '2OS001'
        ) stats;

----> 합친거 사용 못함.... 이거 사용하게 되면 반복문 돌렸을 때 전체 댓글이 2번 출력되서 해당 칸이 2개 생겨버림..... 난 하나만 필요해서....

---view 테이블 만들기
SELECT ROOM_CAT 
FROM HOTEL_ROOM;

DESC HOTEL_ROOM;

SELECT * FROM HOTEL_ROOM
WHERE hotel_code='2OS001';

SELECT ROOM_CAT_DESC, ROOM_CAP, ROOM_ATT, HOTEL_CODE FROM HOTEL_ROOM_CAT
JOIN HOTEL_ROOM USING(ROOM_CAT)
WHERE hotel_code='2OS001';

SELECT * FROM HOTEL_ROOM_ATT
JOIN HOTEL_ROOM USING(ROOM_ATT)
WHERE hotel_code='2OS001';


--내부적으로 데이터 처리를 위해 hotel_code 넣어야함
SELECT hotel_code, to_char(HOTEL_PRICE, '999,999'), ROOM_CAP, HOTEL_DISCOUNT, ROOM_COUNT, ROOM_ATT_DESC as room_att, ROOM_CAT_DESC as room_cat FROM HOTEL_ROOM
JOIN HOTEL_ROOM_ATT USING(ROOM_ATT)
JOIN HOTEL_ROOM_CAT USING(ROOM_CAT)
WHERE hotel_code='2OS001';


SELECT * FROM HOTEL_ROOM
JOIN HOTEL_ROOM_ATT USING(ROOM_ATT)
JOIN HOTEL_ROOM_CAT USING(ROOM_CAT)
WHERE hotel_code='2OS001';

select * from hotel_room;


CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SHOONG". "V_ROOM_LIST" (
    hotel_code, HOTEL_PRICE, ROOM_CAP, HOTEL_DISCOUNT, ROOM_COUNT, room_att, ROOM_ATT_DESC, room_cat, ROOM_CAT_DESC
) AS 
SELECT hotel_code, HOTEL_PRICE, ROOM_CAP, HOTEL_DISCOUNT, ROOM_COUNT, ROOM_ATT, ROOM_ATT_DESC, ROOM_CAT, ROOM_CAT_DESC FROM HOTEL_ROOM
JOIN HOTEL_ROOM_ATT USING(ROOM_ATT)
JOIN HOTEL_ROOM_CAT USING(ROOM_CAT)
where room_count > 0;


--WHERE hotel_code='2OS001' 이거는 create 할때 붙이면 X --> 그러면 where 한 데이터만 조회됨(모두를 위한 view)

select * from v_room_list;

drop view v_room_list;

desc hotel_room_cat;


commit;

		select * from hotel
		    join hotel_pic using(hotel_code)
		    join v_room_list using(hotel_code)
		where hotel_code = '2OS001';

--------------------- 2024.06.20 리뷰 수정
select user_id, tripper_cat, review_title, review_comment, SUBSTR(hotel_reserve_code, 1, 4) || '년 ' || SUBSTR(hotel_reserve_code, 5, 2) || '월 ' || SUBSTR(hotel_reserve_code, 7, 2) || '일' as review_date, 
        ROUND((hotel_facility + hotel_clean + hotel_conven + hotel_kind)/4, 1) as rate_avg
        from hotel_review 
            join hotel_reserve using (hotel_reserve_code)
        where hotel_code = '2OS001'
            order by review_date desc;



select count(*) as review_count, NVL(ROUND(avg(hotel_facility), 1), 0) as avg_hotel_facility, NVL(ROUND(avg(hotel_clean), 1),0) as avg_hotel_clean, NVL(ROUND(avg(hotel_conven),1),0) as avg_hotel_conven, NVL(ROUND(avg(hotel_kind),1), 0) as avg_hotel_kind, 
        NVL(ROUND((avg(hotel_facility) + avg(hotel_clean) + avg(hotel_conven) + avg(hotel_kind))/4, 1),0) as avg_all_rate
from hotel_review
    join hotel_reserve hr using (hotel_reserve_code)
where hotel_code = '2OS004';



select count(*) c from hotel_review
    join hotel_reserve using(hotel_reserve_code)
where hotel_code = '2OS001';





-----------------------------------------------리뷰 등록하기-----------------------------------------

desc hotel_review;

insert into hotel_review values (
    #{approveNo}, #{hotelReserveCode}, #{reviewTitle}, #{reviewComment}, #{hotelFacility}, #{hotelClean} ,#{hotelConven},
    #{hotelKind}, #{tripperCat}
);

select * from hotel_reserve
where hotel_code = '2OS001';


-----호텔페이지 들어올 때 예약번호 통해서 user_Id, hotel_reserve_code 정보 들고 들어오기

select * 
from (select hotel_reserve_code, approve_no, substr(hotel_reserve_code, 9, 6) as hotel_code, to_date(SUBSTR(hotel_reserve_code, 1, 8)) as check_in
from hotel_reserve
    join pay using(hotel_reserve_code)
where user_id = 'ex1') t1
where sysdate > check_in and hotel_code = '2OS001';

---결제해서 호텔에 실제로 체크인한 사람만 리뷰쓰기...
-- sysdate보다 전에 묶었던 날이어야 review달 수 있음 
-- hotel_view페이지 들어올 때 들고 들어오는 호텔코드를 hidden 으로 처리해서 위에 있는 hotel_code 와 비교를 해야함
-- 데이터가 null 이면 review button 안보이게 하고 있으면 보이게 함



pay 테이블에 레코드가 추가될 때 review_available 테이블에 레코드에 변화를 주는데, 
레코드가 없다면 하나 추가하고 이때 review_available테이블의 review_count값은 1로 하고, 
거기서 또 트리거가 발동하면 횟수만큼 review_count가 늘어났다가,
다른 조건으로 review_count가 0이되면 해당 레코드를 삭제하는 코드를 짜줄래



--리뷰 등록전에 결제 승인번호를 통해 리뷰 쓸 수 있는 가능 여부와 리뷰 쓸 수 있는 count 파악하고 리뷰 다 쓰면 이 테이블에서 record 지워주기
--  => 같은 호텔에서 두번 묵게 되면 리뷰를 2개를 쓸 수 있어서 리뷰 몇개 쓸 수있는지 알아야함
CREATE OR REPLACE TRIGGER trg_after_approve_no
AFTER INSERT ON pay 
FOR EACH ROW 
DECLARE 
    review_count NUMBER;
BEGIN 
    -- review_available 테이블에서 해당 레코드를 찾습니다. 
    SELECT COUNT(*) INTO review_count FROM review_available WHERE review_count = :NEW.review_count; 
    
    IF v_count = 0 THEN 
        -- 레코드가 없으면 새로운 레코드를 추가하고 review_count 값을 1로 설정합니다. 
        INSERT INTO B (column1, count) VALUES (:NEW.column1, 1); 
    ELSE 
        -- 레코드가 이미 존재하면 count 값을 증가시킵니다. 
        UPDATE review_available 
        SET review_count = review_count + 1 
        WHERE review_count = :NEW.review_count; 
    END IF; 
    
        -- count 값이 0이 된 레코드를 삭제합니다. 
        DELETE 
        FROM review_available 
        WHERE review_count = :NEW.review_count = 0; 
END;
/

select * from review_available;

select * from hotel;

--리뷰 달 수 있는 총 갯수에 대한 column 추가
alter table review_available
add (review_count number(5));

-- review_count 컬럼 not null 제약조건 추가
alter table review_available
modify review_count not null;



select s2.* from (select s1.*, rownum rn from (select user_id, tripper_cat, review_title, review_comment, 
SUBSTR(hotel_reserve_code, 1, 4) || '년 ' || SUBSTR(hotel_reserve_code, 5, 2) || '월 ' || SUBSTR(hotel_reserve_code, 
7, 2) || '일' as review_date, ROUND((hotel_facility + hotel_clean + hotel_conven + hotel_kind)/4, 
1) as rate_avg from hotel_review join hotel_reserve using (hotel_reserve_code) where hotel_code 
= '2OS001' order by review_date desc) s1) s2 WHERE RN BETWEEN 1 AND 3;


select user_id, tripper_cat, review_title, review_comment
from hotel_review hrv join hotel_reserve hrs using (hotel_reserve_code) where hotel_code 
= '2OS001';


INSERT INTO hotel_reserve 
VALUES ('202406262OS001S01', 3, '2OS001', 4, 2, 'ex1@gmail.com', '한국이름', '영어이름', 'M', '고층', '20240616', '20240618', 'ex1', '01012345678');

INSERT INTO PAY 
VALUES (776, 2, 06290629, 15004080, DEFAULT, 0, '202406262OS001S01', NULL);

INSERT INTO HOTEL_REVIEW VALUES (776, '202406262OS001S01', '저런', '저런저런', 4, 3, 5, 2, 2, 'ex1');

commit;

select * from hotel_reserve;
desc hotel_review;
-------------------------------------결제 관련 sql

select * from pay;

insert into hotel_reserve values(
    #{hotelReserveCode}, #{roomCat}, #{hotelCode}, #{roomCap}, #{roomAtt}, #{residenceEmail}, #{residenceNameKo}, #{residenceNameEng},
    #{residenceGender}, #{hotelReserveCode}, #{residenceCheckIn}, #{residenceCheckOut}, #{userId}, #{residencePhone}, #{residenceBirth}
);

insert into pay values(
    #{approveNo}, #{reserveCorper}, #{cardNum}, #{payPrice}, #{currency}, #{payStatus}, #{hotelReserveCode}, {airlineReserveCode}
);


desc pay;

alter table pay
modify airline_reserve_code varchar2(20);

ALTER TABLE PAY
DROP COLUMN APPROVE_NO;

select * from pay;


COMMIT;

INSERT INTO PAY VALUES ('01907d46-d70f-e9b8-6729-86d02c13239c', '카카오머니', '****', '100', 'KRW', 
'YET', NULL, NULL
    
);

select * from PAY;

Update pay
set pay_status = 'paid', hotel_reserve_code = '20240704132OS0022'
where approve_no = '01907d46-d70f-e9b8-6729-86d02c13';
    
    
desc hotel_room_att;

select * from hotel_room_cat;




-- 일일 초기화용 PL/SQL 프로시저와 스케줄링 한꺼번에 작성
BEGIN
    -- 일일 초기화용 PL/SQL 프로시저 생성
    EXECUTE IMMEDIATE '
    CREATE OR REPLACE PROCEDURE reset_sequence_daily IS
        l_sequence_value NUMBER;
    BEGIN
        l_sequence_value := 1; -- 원하는 시작 값으로 설정
        EXECUTE IMMEDIATE ''ALTER SEQUENCE SHOONG.SEQ_APPROVE_NO RESTART WITH '' || l_sequence_value;
        COMMIT;
    END reset_sequence_daily;';

    -- DBMS_SCHEDULER를 이용한 스케줄링
    DBMS_SCHEDULER.create_job (
        job_name        => '',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN reset_sequence_daily; END;',
        start_date      => TRUNC(SYSDATE) + 1,
        repeat_interval => 'FREQ=DAILY; BYHOUR=0; BYMINUTE=0; BYSECOND=0',
        enabled         => TRUE
    );
END;
/



CREATE OR REPLACE TRIGGER trg_room_count
AFTER INSERT ON hotel_reserve
FOR EACH ROW
DECLARE
    v_room_count NUMBER;
BEGIN
    -- hotel_reserve 테이블에 새로운 예약이 추가될 때마다 실행됩니다.

    -- 방 번호를 부여하기 위해 hotel_room 테이블에서 사용 가능한 가장 큰 방 번호를 가져옵니다.
    SELECT MAX(room_number)
    INTO v_room_count
    FROM hotel_room
    WHERE room_count > 0
    AND NOT EXISTS (
        SELECT 1
        FROM hotel_reserve
        WHERE hotel_room.room_number = hotel_reserve.room_number
        AND hotel_reserve.hotel_reserve_code = :NEW.hotel_reserve_code
    );

    -- 가져온 방 번호를 hotel_reserve 테이블에 업데이트합니다.
    UPDATE hotel_reserve
    SET room_count = v_room_count
    WHERE hotel_reserve_code = :NEW.hotel_reserve_code;

    -- hotel_room 테이블에서 해당 방의 개수를 하나 줄입니다.
    UPDATE hotel_room
    SET room_count = room_count - 1
    WHERE room_count = v_room_count;
    
    -- 예약 테이블에서 예약된 방의 개수를 체크하여 해당하는 방의 개수를 감소합니다.
END;
/

CREATE OR REPLACE TRIGGER trg_room_number_and_count
BEFORE INSERT ON hotel_reserve
FOR EACH ROW
DECLARE
    v_hotel_reserve_code VARCHAR2(20);
BEGIN
    -- 호텔 예약 코드와 방 번호를 결합하여 호텔 예약 코드 업데이트
    SELECT :NEW.hotel_reserve_code || TO_CHAR(MAX(ROOM_CAT) + 1)
    INTO v_hotel_reserve_code
    FROM hotel_reserve
    WHERE ROOM_CAT IS NOT NULL
      AND ROOM_CAT > 0
      AND HOTEL_CODE = :NEW.HOTEL_CODE
      AND ROOM_CAT = :NEW.ROOM_CAT;

    :NEW.hotel_reserve_code := v_hotel_reserve_code;

    -- hotel_room 테이블에서 해당 방 번호의 room_count를 감소시킵니다.
    UPDATE hotel_room
    SET room_count = room_count - 1
    WHERE ROOM_CAT = :NEW.ROOM_CAT
      AND HOTEL_CODE = :NEW.HOTEL_CODE
      AND room_count > 0;

END;
/

CREATE OR REPLACE TRIGGER trg_room_reservation
AFTER INSERT ON hotel_reserve
REFERENCING NEW AS NEW
FOR EACH ROW
DECLARE
    v_room_number NUMBER;
BEGIN
    -- 호텔 예약 코드 뒤에 붙일 방 번호를 찾습니다.
    SELECT COALESCE(MAX(TO_NUMBER(SUBSTR(hotel_reserve_code, LENGTH(:NEW.hotel_reserve_code) + 1))), 0) + 1
    INTO v_room_number
    FROM hotel_reserve
    WHERE HOTEL_CODE = :NEW.HOTEL_CODE
      AND ROOM_CAT = :NEW.ROOM_CAT
      AND ROOM_ATT = :NEW.ROOM_ATT;

    -- hotel_reserve_code 뒤에 방 번호를 붙여 업데이트
--    :NEW.hotel_reserve_code := :NEW.hotel_reserve_code || v_room_number;
    UPDATE HOTEL_RESERVE SET HOTEL_RESERVE_CODE = :NEW.HOTEL_RESERVE_CODE || V_ROOM_NUMBER WHERE HOTEL_CODE = :NEW.HOTEL_CODE
      AND ROOM_CAT = :NEW.ROOM_CAT
      AND ROOM_ATT = :NEW.ROOM_ATT;

    -- hotel_room 테이블에서 해당 방 번호의 room_count를 감소시킵니다.
--    UPDATE hotel_room
--    SET room_count = room_count - 1
--    WHERE ROOM_CAT = :OLD.ROOM_CAT
--      AND ROOM_ATT = :OLD.ROOM_ATT
--      AND HOTEL_CODE = :OLD.HOTEL_CODE
--      AND room_count > 0;
END;
/
DROP TRIGGER trg_room_reservation;

commit;

select '56' || 5 from  dual;
CREATE SEQUENCE  "SHOONG"."SEQ_HOTEL_RESERVE"  MINVALUE 1 MAXVALUE 999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  CYCLE  NOKEEP  NOSCALE  GLOBAL ;

select * from hotel_reserve;

select * from hotel_room where hotel_code = '2OS001';

select * from hotel_reserve;

select * from pay;
where hotel_reserve_code = '20240708292KT002005';

select * from hotel_room
where hotel_code = '2KT003';
-------------------------------마이페이지 호텔 예약 관련


delete from hotel_review
where hotel_reserve_code = '20240705562OS0012';

delete from hotel_reserve
where hotel_reserve_code = '20240708182KT00311';

delete from pay
where hotel_reserve_code = '20240708182KT00311';

commit;

delete from pay
where approve_no = '01909218-029b-dcce-ead9-0442f447815a';

alter table hotel_reserve
modify RESIDENCE_BIRTH varchar2(20);

UPDATE hotel_reserve
SET reserve_check_out = '2024년7월8일'
WHERE HOTEL_RESERVE_CODE = '20240709262KT0040122';


select * from hotel_review;

ALTER TABLE hotel_reserve
ADD (RESIDENCE_BIRTH varchar2(10));

commit;

select * from pay;



select *
from
(select * from hotel_reserve
    join reserve_request using(hotel_reserve_code))
    right join hotel_request using(request);
    
    select hotel_reserve_code, hotel_name, reserve_check_in, reserve_check_out, room_att_desc, room_cat_desc, residence_num, hotel_price 
    from hotel_reserve
        join hotel using(hotel_code)
        join hotel_room_att using(room_att)
        join hotel_room_cat using(room_cat)
        join hotel_room using(room_cap)
    ;
    
    select * from hotel_reserve;
    
    desc hotel_reserve;
    
select hotel_reserve_code, hotel_name, reserve_check_in, reserve_check_out, room_att_desc, room_cat_desc, residence_num, hotel_price
from hotel_reserve 
    join hotel using(hotel_code) 
    join hotel_room_att using(room_att) 
    join hotel_room_cat using(room_cat) 
    join hotel_room using (hotel_code)
where user_id = 'customer' and hotel_reserve_code = '20240703552OS0020';
    
update hotel_reserve
set user_id = 'customer'
where hotel_reserve_code = '20240703552OS0020';


--예약 내역 하나만 조회하기
select hr.hotel_reserve_code, hotel_name, reserve_check_in, reserve_check_out, room_att_desc, room_cat_desc, residence_num, hotel_price, residence_name_ko
from hotel_reserve hr
    join hotel h on hr.hotel_code = h.hotel_code 
    join hotel_room_att hra on hr.room_att = hra.room_att
    join hotel_room_cat hrc on hr.room_cat = hrc.room_cat
    join hotel_room hm on hr.room_cap = hm.room_cap
    join reserve_request rr on hr.hotel_reserve_code = rr.hotel_reserve_code
where user_id = 'customer' and hr.hotel_reserve_code = '20240703552OS0020' and hm.room_cat = hr.room_cat and hm.hotel_code = hr.hotel_code and hm.room_att = hr.room_att;

desc hotel_reserve;

select * from hotel_reserve;


--view 테이블 만들어서 예약 상세 뽑아내기-------------- 필요 없음
CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SHOONG". "V_CUSTOMER_RESERVE" (
    hotel_reserve_code, hotel_name, reserve_check_in, reserve_check_out, room_att_desc, room_cat_desc, residence_num, hotel_price, residence_name_ko, user_id
) AS 
SELECT hotel_reserve_code, hotel_name, reserve_check_in, reserve_check_out, room_att_desc, room_cat_desc, residence_num, hotel_price, residence_name_ko, user_id
FROM hotel_reserve hr
        join hotel h on hr.hotel_code = h.hotel_code 
        join hotel_room_att hra on hr.room_att = hra.room_att
        join hotel_room_cat hrc on hr.room_cat = hrc.room_cat
        join hotel_room hm on hr.room_cap = hm.room_cap
;


update hotel_reserve
set request_sum = '3' where hotel_reserve_code = '20240701112OS0013';

commit;

drop table reserve_request;

alter table hotel_reserve
modify requests number(3);

alter table hotel_reserve
rename column requests to request_sum;

select hr.hotel_reserve_code, hotel_name, reserve_check_in, reserve_check_out, room_att_desc, room_cat_desc, residence_num, hotel_price, residence_name_ko, request_sum
from hotel_reserve hr
    join hotel h on hr.hotel_code = h.hotel_code 
    join hotel_room_att hra on hr.room_att = hra.room_att
    join hotel_room_cat hrc on hr.room_cat = hrc.room_cat
    join hotel_room hm on hr.room_cap = hm.room_cap
where user_id = 'customer' and hr.hotel_reserve_code = '20240703552OS0020' and hm.room_cat = hr.room_cat and hm.hotel_code = hr.hotel_code and hm.room_att = hr.room_att;

desc hotel_reserve;

select * from hotel_reserve;


select * from pay where hotel_reserve_code = '20240706412KT0032';

select * from hotel_reserve
    join pay using (hotel_reserve_c);
    
select hr.hotel_reserve_code, hotel_name, reserve_check_in, reserve_check_out, room_att_desc, room_cat_desc, residence_num, 
        p.pay_price as hotel_price, residence_name_ko, request_sum, approve_no, review_available
from hotel_reserve hr
    join hotel h on hr.hotel_code = h.hotel_code 
    join hotel_room_att hra on hr.room_att = hra.room_att
    join hotel_room_cat hrc on hr.room_cat = hrc.room_cat
    join hotel_room hm on hr.room_cap = hm.room_cap
    join pay p on hr.hotel_reserve_code = p.hotel_reserve_code
where user_id = 'singasong' and hr.hotel_reserve_code = '20240708140JJ0020' and hm.room_cat = hr.room_cat and hm.hotel_code = hr.hotel_code and hm.room_att = hr.room_att
        and pay_status = 'paid';


delete from pay where hotel_reserve_code='20240707342KT0021';

delete from hotel_reserve where hotel_reserve_code='20240707342KT0021';

commit;

select * from hotel_reserve where hotel_reserve_code = '20240708140JJ0020';

update hotel_reserve
set reserve_check_out = '2024년07월03일' 
where hotel_reserve_code = '20240708140JJ0020';

desc pay;

select * from pay;

------------------------------------------------항공 결제 관련

select * from passenger_info;

select * from AIRLINE_RESERVE_INFO;

            
SELECT AIRLINE_RESERVE_CODE
FROM (
    SELECT AIRLINE_RESERVE_CODE
    FROM AIRLINE_RESERVE_INFO
    WHERE USER_ID = 'singasong'
    AND RESERVE_PHONE = '01012345678'
    AND RESERVE_EMAIL = 'sss@naver.com'
    ORDER BY RESERVE_TIME DESC
)
WHERE ROWNUM = 1;

alter table hotel_reserve
ADD RESERVE_TIME TIMESTAMP default(SYSDATE);

commit;

select * from hotel_reserve;

select * from AIRLINE_RESERVE_INFO;


 select * from airline_reserve_info
 where airline_reserve_code = '2024071009351105';
 
 select * from passenger_info;
 
 desc AIRLINE_RESERVE_INFO;
 
 select * from direct_via;
 
alter table direct_via
modify AIRLINE_RESERVE_CODE varchar2(20);
commit;



select * from seat_grade
    join direct_via using(airline_code);

select * 
    from(
        select * from airline_reserve_info
        join direct_via using(AIRLINE_RESERVE_CODE)
        )
        join seat_grade using(airline_code);
        
select * from passenger_info
    join direct_via using(AIRLINE_RESERVE_CODE);
    


---------------------------------------- 마이페이지 항공 예약 관련

-----총 예약리스트
select airline_reserve_code, airline_code, airline_name, depart_loc, depart_date, depart_time,  arrival_loc, arrival_time, arrival_date, airline_img  
from 
(select * from
(select * 
from (
select * 
from airline_reserve_info
    join direct_via using(airline_reserve_code))
    join seat_grade using(airline_code))
    join airline_info using(airline_code))
    join pay using (airline_reserve_code)
where pay_status = 'paid' and user_id = #{userId};

select airline_reserve_code, airline_img, airline_name, first_name, last_name, ari.depart_date, depart_loc, depart_time, arrival_loc, arrival_time from 
(select  *  from 
(select * from
(select * 
from (
select * from airline_reserve_info ari
    join direct_via using(airline_reserve_code))
    join seat_grade using(airline_code))
    join airline_info using(airline_code))
    join pay using (airline_reserve_code))
    join passenger_info using(airline_reserve_code)
where airline_code = 'YP10107261250';

select * from airline_reserve_info;


select ari.airline_reserve_code, ai.airline_code, ai.airline_name, ari.depart_date, ai.depart_loc, ai.depart_time, ai.arrival_loc, ai.arrival_time, ari.arrival_date, ai.airline_img   
from airline_reserve_info ari
    join direct_via dv on ari.airline_reserve_code = dv.airline_reserve_code
    join seat_grade sg on dv.airline_code = sg.airline_code
    join airline_info ai on sg.airline_code = ai.airline_code
    join pay p on ari.airline_reserve_code = p.airline_reserve_code
    join passenger_info pi on ari.airline_reserve_code = pi.airline_reserve_code
where sg.airline_code = 'YP10107261250';

select * from airline_reserve_info;

		select distinct ari.airline_reserve_code, ai.airline_code, ai.airline_name, ari.depart_date, ai.depart_loc, ai.depart_time, ai.arrival_loc, ai.arrival_time, ari.arrival_date, ai.airline_img   
		from airline_reserve_info ari
		    join direct_via dv on ari.airline_reserve_code = dv.airline_reserve_code
		    join seat_grade sg on dv.airline_code = sg.airline_code
		    join airline_info ai on sg.airline_code = ai.airline_code
		    join pay p on ari.airline_reserve_code = p.airline_reserve_code
		    join passenger_info pi on ari.airline_reserve_code = pi.airline_reserve_code
		where p.pay_status = 'paid' and ari.user_id = 'gyura34';
        
        select distinct ari.airline_reserve_code, ai.airline_code, ai.airline_name, ari.depart_date, 
ai.depart_loc, ai.depart_time, ai.arrival_loc, ai.arrival_time, ari.arrival_date, ai.airline_img 
from airline_reserve_info ari join direct_via dv on ari.airline_reserve_code = dv.airline_reserve_code 
join seat_grade sg on dv.airline_code = sg.airline_code join airline_info ai on sg.airline_code 
= ai.airline_code join pay p on ari.airline_reserve_code = p.airline_reserve_code join passenger_info 
pi on ari.airline_reserve_code = pi.airline_reserve_code where p.pay_status = 'cancel' and 
ari.user_id = 'gyrua34' ;

select * from airline_reserve_info
    join passenger_info using(airline_reserve_code)
    join pay using (airline_reserve_code)
where user_id = 'gyrua34';
        
alter table hotel_review
modify hotel_reserve_code varchar2(50);
commit;

select * from airline_reserve_info;

select * from passenger_info;


		SELECT ari.airline_reserve_code, ai.airline_code, ai.airline_name, pi.last_name, pi.first_name, ari.depart_date, ai.depart_loc, ai.depart_time, ai.arrival_loc, ai.arrival_time, 
				ari.arrival_date, ai.airline_img, p.pay_price
		FROM airline_reserve_info ari
		    join direct_via dv on ari.airline_reserve_code = dv.airline_reserve_code
		    join seat_grade sg on dv.airline_code = sg.airline_code
		    join airline_info ai on sg.airline_code = ai.airline_code
		    join pay p on ari.airline_reserve_code = p.airline_reserve_code
		    join passenger_info pi on ari.airline_reserve_code = pi.airline_reserve_code
		WHERE sg.airline_code = 
		ORDER BY ari.airline_reserve_code DESC;