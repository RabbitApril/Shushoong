DROP TABLE "HOTEL_DELETED";
DROP TABLE "HOTEL_PIC";
DROP TABLE "HOTEL_FACILITY";
DROP TABLE "REVIEW_AVAILABLE";
DROP TABLE "HOTEL_REVIEW";
DROP TABLE "PAY";
DROP TABLE "HOTEL_RESERVE";
DROP TABLE "HOTEL_REQUEST";

DROP TABLE "HOTEL_LIKE";
DROP TABLE "HOTEL_ROOM";
DROP TABLE "HOTEL_ROOM_CAT";
DROP TABLE "HOTEL_ROOM_ATT";
DROP TABLE "HOTEL";
DROP TABLE "BUSINESS_MEMBER";

DROP TABLE "DIRECT_VIA";
DROP TABLE "SEAT_GRADE";
DROP TABLE "AIRLINE_INFO";

DROP TABLE "PASSENGER_INFO";
DROP TABLE "AIRLINE_RESERVE_INFO";

DROP TABLE "NOTICE_FILE";
DROP TABLE "NOTICE_BOARD";
DROP TABLE "ASK_FILE";
DROP TABLE "SERVICE_CENTER";
DROP TABLE "FAQ_CAT";
DROP TABLE "SNSLOGIN_INFO";
DROP TABLE "MEMBER";

DROP SEQUENCE SEQ_ARC;
DROP SEQUENCE SEQ_ASK_ID;
DROP SEQUENCE SEQ_HC;
DROP SEQUENCE SEQ_HRC;
DROP SEQUENCE SEQ_AIRC;

BEGIN
    DBMS_SCHEDULER.DROP_JOB(
        job_name => 'update_review_available_job',
        force => TRUE
    );
END;
/
DROP TRIGGER update_review_available_procedure;

CREATE SEQUENCE SEQ_ARC;
CREATE SEQUENCE SEQ_ASK_ID;
CREATE SEQUENCE SEQ_HC;
CREATE SEQUENCE SEQ_HRC;
CREATE SEQUENCE SEQ_AIRC
    START WITH 1000
    INCREMENT BY 1
    MAXVALUE 9999
    MINVALUE 1000
    CYCLE
    CACHE 5
    ;

CREATE TABLE "HOTEL" (
	"HOTEL_CODE"	VARCHAR2(10)	DEFAULT 0	NOT NULL,
	"HOTEL_NAME"	VARCHAR2(50)		NOT NULL,
	"HOTEL_ENG"	VARCHAR2(100)		NOT NULL,
	"HOTEL_ADDRESS"	VARCHAR2(500)		NOT NULL,
	"HOTEL_CALL"	VARCHAR2(20)		NOT NULL,
	"HOTEL_CHECK_IN"	VARCHAR2(25)		NOT NULL,
	"HOTEL_CHECK_OUT"	VARCHAR2(25)		NOT NULL,
	"HOTEL_POLICY"	VARCHAR2(1000)		NULL,
	"HOTEL_INTRO"	VARCHAR2(1000)		NULL,
    "HOTEL_SAFETY" VARCHAR2(1000) NULL,
	"HOTEL_PCOUNT"	NUMBER(15)	DEFAULT 0	NOT NULL,
	"HOTEL_LOC_CAT"	VARCHAR2(30)		NOT NULL,
	"BUSINESS_NUM"	NUMBER(10)		NOT NULL
);

COMMENT ON COLUMN "HOTEL"."HOTEL_CODE" IS '0JJ015';

COMMENT ON COLUMN "HOTEL"."HOTEL_NAME" IS '숙소 이름';

COMMENT ON COLUMN "HOTEL"."HOTEL_ENG" IS '숙소 영어이름';

COMMENT ON COLUMN "HOTEL"."HOTEL_ADDRESS" IS '숙소 주소';

COMMENT ON COLUMN "HOTEL"."HOTEL_CALL" IS '숙소 전화번호';

COMMENT ON COLUMN "HOTEL"."HOTEL_CHECK_IN" IS '체크인 시간';

COMMENT ON COLUMN "HOTEL"."HOTEL_CHECK_OUT" IS '체크아웃 시간';

COMMENT ON COLUMN "HOTEL"."HOTEL_POLICY" IS '숙소 정책';

COMMENT ON COLUMN "HOTEL"."HOTEL_INTRO" IS '숙소 소개';

COMMENT ON COLUMN "HOTEL"."HOTEL_PCOUNT" IS '결제 횟수';

COMMENT ON COLUMN "HOTEL"."HOTEL_LOC_CAT" IS '숙소 지역 분류';

COMMENT ON COLUMN "HOTEL"."BUSINESS_NUM" IS '숫자로만 이루어진 10자리의 숫자';

CREATE TABLE "HOTEL_REVIEW" (
	"APPROVE_NO"	VARCHAR2(100)		NOT NULL,
	"HOTEL_RESERVE_CODE"	VARCHAR2(20)		NOT NULL,
    "REVIEW_TITLE" VARCHAR2(100) NOT NULL,
	"REVIEW_COMMENT"	VARCHAR2(500)		NOT NULL,
    "USER_ID" VARCHAR2(20)  NOT NULL,
	"HOTEL_FACILITY"	NUMBER(1)	DEFAULT 0	NOT NULL,
	"HOTEL_CLEAN"	NUMBER(1)	DEFAULT 0	NOT NULL,
	"HOTEL_CONVEN"	NUMBER(1)	DEFAULT 0	NOT NULL,
	"HOTEL_KIND"	NUMBER(1)	DEFAULT 0	NOT NULL,
	"TRIPPER_CAT"	NUMBER(1)		NOT NULL
);

COMMENT ON COLUMN "HOTEL_REVIEW"."APPROVE_NO" IS '결제 완료 시 부여되는 번호';

COMMENT ON COLUMN "HOTEL_REVIEW"."HOTEL_RESERVE_CODE" IS '20240527 + 00001(SEQ)';

COMMENT ON COLUMN "HOTEL_REVIEW"."REVIEW_COMMENT" IS '숙소 리뷰';

COMMENT ON COLUMN "HOTEL_REVIEW"."HOTEL_FACILITY" IS '시설 상태 점수';

COMMENT ON COLUMN "HOTEL_REVIEW"."HOTEL_CLEAN" IS '숙소 청결 상태 점수';

COMMENT ON COLUMN "HOTEL_REVIEW"."HOTEL_CONVEN" IS '숙소 평점';

COMMENT ON COLUMN "HOTEL_REVIEW"."HOTEL_KIND" IS '직원 서비스 점수';

COMMENT ON COLUMN "HOTEL_REVIEW"."TRIPPER_CAT" IS '0 : 혼자, 1 : 커플/부부, 2 : 가족, 3 : 단체, 4 : 출장,';

CREATE TABLE "HOTEL_LIKE" (
	"USER_ID"	VARCHAR2(20)		NOT NULL,
	"HOTEL_CODE"	VARCHAR2(10)	DEFAULT 0	NOT NULL
);

COMMENT ON COLUMN "HOTEL_LIKE"."USER_ID" IS '8~20자 사이의 회원 아이디';

COMMENT ON COLUMN "HOTEL_LIKE"."HOTEL_CODE" IS '0JJ015';

CREATE TABLE "MEMBER" (
	"USER_ID"	VARCHAR2(20)		NOT NULL,
	"USER_NAME"	VARCHAR2(20)		NOT NULL,
	"USER_PWD"	VARCHAR2(80)		NOT NULL,
	"USER_EMAIL"	VARCHAR2(50)		NOT NULL,
	"USER_GRAGE"	VARCHAR2(10)		NOT NULL,
	"USER_STATUS"	NUMBER(1)	DEFAULT 1	NOT NULL,
	"JOIN_DATE"	DATE		NOT NULL,
	"EMAIL_RECEIVE"	NUMBER(1)	DEFAULT 0	NOT NULL,
	"MSG_RECEIVE"	NUMBER(1)	DEFAULT 0	NOT NULL,
	"LATEST_LOGIN"	DATE		NOT NULL
);

COMMENT ON COLUMN "MEMBER"."USER_ID" IS '8~20자 사이의 회원 아이디';

COMMENT ON COLUMN "MEMBER"."USER_NAME" IS '실명';

COMMENT ON COLUMN "MEMBER"."USER_PWD" IS '회원 비밀번호(영문, 특수문자를 조합한 8~20자리';

COMMENT ON COLUMN "MEMBER"."USER_EMAIL" IS '이메일 형식(*@*)';

COMMENT ON COLUMN "MEMBER"."USER_GRAGE" IS '관리자(admin), 일반 회원(customer), 사업자  회원 (business)';

COMMENT ON COLUMN "MEMBER"."USER_STATUS" IS '정상(1), 이용정지(0)';

COMMENT ON COLUMN "MEMBER"."JOIN_DATE" IS '가입한 날짜';

COMMENT ON COLUMN "MEMBER"."EMAIL_RECEIVE" IS '이메일 마케팅 수신 체크여부(0 : 거부)';

COMMENT ON COLUMN "MEMBER"."MSG_RECEIVE" IS '문자 마케팅 수신 체크여부(0 : 거부)';

COMMENT ON COLUMN "MEMBER"."LATEST_LOGIN" IS '마지막 로그인 기준 시간';

CREATE TABLE "NOTICE_BOARD" (
	"NOTICE_ID"	NUMBER	DEFAULT 1	NOT NULL,
	"NOTICE_TITLE"	VARCHAR2(60)		NOT NULL,
	"NOTICE_CONTENT"	VARCHAR2(4000)		NOT NULL,
	"NOTICE_TIME"	TIMESTAMP		NOT NULL,
	"USER_ID"	VARCHAR2(20)		NOT NULL
);

COMMENT ON COLUMN "NOTICE_BOARD"."NOTICE_ID" IS '글번호 SEQ_NOTICE_ID';

COMMENT ON COLUMN "NOTICE_BOARD"."NOTICE_TITLE" IS '한글 20자, 영어 60자';

COMMENT ON COLUMN "NOTICE_BOARD"."NOTICE_CONTENT" IS '글내용 작성';

COMMENT ON COLUMN "NOTICE_BOARD"."NOTICE_TIME" IS '글작성 시간(YYYY-MI-SS HH:MM:SS)';

COMMENT ON COLUMN "NOTICE_BOARD"."USER_ID" IS '공지 작성자 USER_ID';

CREATE TABLE "HOTEL_PIC" (
	"HOTEL_PICTURE"	VARCHAR2(500)		NOT NULL,
	"HOTEL_CODE"	VARCHAR2(10)	DEFAULT 0	NOT NULL
);

COMMENT ON COLUMN "HOTEL_PIC"."HOTEL_PICTURE" IS '숙소 사진';

COMMENT ON COLUMN "HOTEL_PIC"."HOTEL_CODE" IS '0JJ015';

CREATE TABLE "NOTICE_FILE" (
	"FILE_ID"	NUMBER(20)	DEFAULT 1	NOT NULL,
	"NOTICE_ID"	NUMBER(20)	DEFAULT 1	NOT NULL,
	"ORIGINAL_FILENAME"	VARCHAR2(300)		NOT NULL,
	"SAVED_FILE_PATH_NAME"	VARCHAR2(1000)		NOT NULL
);

COMMENT ON COLUMN "NOTICE_FILE"."FILE_ID" IS 'NOTICE_ID 마다 1씩 증가';

COMMENT ON COLUMN "NOTICE_FILE"."NOTICE_ID" IS '글번호 SEQ_NOTICE_ID';

COMMENT ON COLUMN "NOTICE_FILE"."ORIGINAL_FILENAME" IS '클라이언트로 전송한 파일명';

COMMENT ON COLUMN "NOTICE_FILE"."SAVED_FILE_PATH_NAME" IS '파일경로(EX. YYYYMMDDHHMMSS_00001.txt)';

CREATE TABLE "SERVICE_CENTER" (
	"FAQ_ID"	NUMBER(12)	DEFAULT 1	NOT NULL,
	"USER_ID"	VARCHAR2(20)		NOT NULL,
	"ASK_TITLE"	VARCHAR2(60)		NOT NULL,
	"ASK_CONTENT"	VARCHAR2(4000)		NOT NULL,
	"ASK_DATE"	TIMESTAMP	DEFAULT CURRENT_TIMESTAMP	NOT NULL,
	"ANS_CONTENT"	VARCHAR2(4000),
	"ANS_TIME"	TIMESTAMP	DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN "SERVICE_CENTER"."FAQ_ID" IS '문의사항에 임의의 번호 부여 (SEQ_ASK_ID)';

COMMENT ON COLUMN "SERVICE_CENTER"."USER_ID" IS '8~20자 사이의 회원 아이디';

COMMENT ON COLUMN "SERVICE_CENTER"."ASK_TITLE" IS '한글 20자, 영어 60자';

COMMENT ON COLUMN "SERVICE_CENTER"."ASK_CONTENT" IS '문의 내용 작성';

COMMENT ON COLUMN "SERVICE_CENTER"."ASK_DATE" IS '현지 작성 시간(YYYY-MI-SS HH:MM:SS)';

COMMENT ON COLUMN "SERVICE_CENTER"."ANS_CONTENT" IS '문의 답변 내용 작성';

COMMENT ON COLUMN "SERVICE_CENTER"."ANS_TIME" IS '현지 작성 시간(YYYY-MI-SS HH:MM:SS)';

CREATE TABLE "ASK_FILE" (
	"FILE_ID"	NUMBER(20)	DEFAULT 1	NOT NULL,
	"FAQ_ID"	NUMBER(12)	DEFAULT 1	NOT NULL,
	"ORIGINAL_FILENAME"	VARCHAR2(300)		NOT NULL,
	"SAVED_FILE_PATH_NAME"	VARCHAR2(1000)		NOT NULL
);

COMMENT ON COLUMN "ASK_FILE"."FILE_ID" IS '하나씩 증가';

COMMENT ON COLUMN "ASK_FILE"."FAQ_ID" IS '문의사항에 임의의 번호 부여 (SEQ_ASK_ID)';

COMMENT ON COLUMN "ASK_FILE"."ORIGINAL_FILENAME" IS '클라이언트로 전송한 파일명';

COMMENT ON COLUMN "ASK_FILE"."SAVED_FILE_PATH_NAME" IS '파일경로(EX. YYYYMMDDHHMMSS_00001.txt)';

CREATE TABLE "SNSLOGIN_INFO" (
	"USER_ID"	VARCHAR2(20)		NOT NULL,
	"SNS_TYPE"	VARCHAR(10)		NOT NULL,
	"SNS_NAME"	VARCHAR(20)		NOT NULL,
	"SNS_EMAIL"	VARCHAR2(50)		NOT NULL,
	"SNS_CONNECTE_DATE"	DATE		NOT NULL
);

COMMENT ON COLUMN "SNSLOGIN_INFO"."USER_ID" IS '8~20자 사이의 회원 아이디';

COMMENT ON COLUMN "SNSLOGIN_INFO"."SNS_TYPE" IS 'naver, kakao, google';

COMMENT ON COLUMN "SNSLOGIN_INFO"."SNS_NAME" IS 'SNS 이름';

COMMENT ON COLUMN "SNSLOGIN_INFO"."SNS_EMAIL" IS 'SNS 이메일';

COMMENT ON COLUMN "SNSLOGIN_INFO"."SNS_CONNECTE_DATE" IS 'SNS 연동날짜';

CREATE TABLE "AIRLINE_INFO" (
	"AIRLINE_CODE"	VARCHAR2(20)		NOT NULL,
	"FLIGHT_NO"	VARCHAR2(10)		NOT NULL,
	"DEPART_LOC"	VARCHAR2(15)		NOT NULL,
	"ARRIVAL_LOC"	VARCHAR2(15)		NOT NULL,
	"DEPART_TIME"	VARCHAR2(20)		NOT NULL,
	"ARRIVAL_TIME"	VARCHAR2(20)		NOT NULL,
	"DEPART_DATE"	VARCHAR2(20)		NOT NULL,
	"ARRIVAL_DATE"	VARCHAR2(20)		NOT NULL,
	"AIRLINE_NAME"	VARCHAR2(15)		NOT NULL,
	"AIRLINE_IMG"	VARCHAR2(500)		NOT NULL,
	"DOMESTIC_FLIGHTS"	CHAR(1)		NOT NULL,
	"VIA_COUNT"	NUMBER	DEFAULT 0	NOT NULL
);

COMMENT ON COLUMN "AIRLINE_INFO"."AIRLINE_CODE" IS '항공편명 + 이륙일 + 시+분';

COMMENT ON COLUMN "AIRLINE_INFO"."DEPART_LOC" IS 'ICN(서울)';

COMMENT ON COLUMN "AIRLINE_INFO"."ARRIVAL_LOC" IS 'LAX(로스앤젤레스)';

COMMENT ON COLUMN "AIRLINE_INFO"."DEPART_TIME" IS 'HH24:MI';

COMMENT ON COLUMN "AIRLINE_INFO"."ARRIVAL_TIME" IS 'HH24:MI';

COMMENT ON COLUMN "AIRLINE_INFO"."DEPART_DATE" IS '이륙일';

COMMENT ON COLUMN "AIRLINE_INFO"."ARRIVAL_DATE" IS '착륙일';

COMMENT ON COLUMN "AIRLINE_INFO"."AIRLINE_NAME" IS '항공사';

COMMENT ON COLUMN "AIRLINE_INFO"."AIRLINE_IMG" IS '항공사 이미지';

COMMENT ON COLUMN "AIRLINE_INFO"."DOMESTIC_FLIGHTS" IS 'D=DOMESTIC(국내선)  I=International(국제선)';

COMMENT ON COLUMN "AIRLINE_INFO"."VIA_COUNT" IS '경유 횟수(Default 0회)';

CREATE TABLE "SEAT_GRADE" (
	"SEAT_GRADE"	NUMBER		NOT NULL,
	"AIRLINE_CODE"	VARCHAR2(20)		NOT NULL,
	"SEAT_TOTAL"	NUMBER		NOT NULL,
	"SEAT_RESERVED"	NUMBER		NOT NULL,
	"SEAT_PRICE"	NUMBER(8)	DEFAULT 0	NOT NULL,
	"CHILD_PRICE"	NUMBER(8)	DEFAULT 0	NOT NULL,
	"TODDLER_PRICE"	NUMBER(8)	DEFAULT 0	NOT NULL
);

COMMENT ON COLUMN "SEAT_GRADE"."SEAT_GRADE" IS 'PK';

COMMENT ON COLUMN "SEAT_GRADE"."AIRLINE_CODE" IS 'PK';

COMMENT ON COLUMN "SEAT_GRADE"."SEAT_TOTAL" IS '총 좌석';

COMMENT ON COLUMN "SEAT_GRADE"."SEAT_RESERVED" IS '예매된 좌석';

COMMENT ON COLUMN "SEAT_GRADE"."SEAT_PRICE" IS '예매 가격(성인 12세 이상)';

COMMENT ON COLUMN "SEAT_GRADE"."CHILD_PRICE" IS '예매 가격 (성인 1인 티켓 값의 70%)(소아 2~ 11)';

COMMENT ON COLUMN "SEAT_GRADE"."TODDLER_PRICE" IS '예매 가격(영아 ~ 2)';

CREATE TABLE "AIRLINE_RESERVE_INFO" (
	"AIRLINE_RESERVE_CODE"	VARCHAR2(20)		NOT NULL,
	"USER_ID"	VARCHAR2(20)		NOT NULL,
    "RESERVER_PHONE" VARCHAR2(15) NOT NULL,
    "RESERVER_EMAIL" VARCHAR2(35) NOT NULL,
    "RESERVE_TIME" TIMESTAMP DEFAULT(SYSDATE) NOT NULL
);

COMMENT ON COLUMN "AIRLINE_RESERVE_INFO"."AIRLINE_RESERVE_CODE" IS 'PK(202405279641001)';

COMMENT ON COLUMN "AIRLINE_RESERVE_INFO"."USER_ID" IS '8~20자 사이의 회원 아이디';

CREATE TABLE "HOTEL_RESERVE" (
	"HOTEL_RESERVE_CODE"	VARCHAR2(20)		NOT NULL,
	"ROOM_CAT"	NUMBER(1)	NOT NULL,
	"HOTEL_CODE"	VARCHAR2(10)	DEFAULT 0	NOT NULL,
	"ROOM_CAP"	NUMBER(3)	DEFAULT 1	NOT NULL,
	"ROOM_ATT"	NUMBER(1)	NOT NULL,
    "RESIDENCE_NUM" VARCHAR2(20)    NOT NULL,
	"RESIDENCEE_EMAIL"	VARCHAR2(50)		NOT NULL,
    "RESIDENCE_BIRTH"   NUMBER(6)           NOT NULL,
    "RESIDENCE_PHONE" VARCHAR2(25) NOT NULL,
	"RESIDENCE_NAME_KO"	VARCHAR2(20)		NOT NULL,
	"RESIDENCE_NAME_EN"	VARCHAR2(50)		NOT NULL,
	"RESIDENCE_GENDER"	VARCHAR2(1)		NOT NULL,
	"RESERVE_CHECK_IN"	VARCHAR2(25)		NOT NULL,
	"RESERVE_CHECK_OUT"	VARCHAR2(25)		NOT NULL,
	"USER_ID"	VARCHAR2(20)	NOT NULL,
    "REVIEW_AVAILABLE"  NUMBER(1) DEFAULT 0 NOT NULL
);

COMMENT ON COLUMN "HOTEL_RESERVE"."HOTEL_RESERVE_CODE" IS 'YYMMDD0JJ015S04';

COMMENT ON COLUMN "HOTEL_RESERVE"."ROOM_CAT" IS '방 종류(디럭스씨뷰,디럭스마운틴뷰)';

COMMENT ON COLUMN "HOTEL_RESERVE"."HOTEL_CODE" IS '0JJ015';

COMMENT ON COLUMN "HOTEL_RESERVE"."ROOM_CAP" IS '0 : 더블, 1 : 트리플, 2 : 쿼드, 3: 파티룸';

COMMENT ON COLUMN "HOTEL_RESERVE"."ROOM_ATT" IS '0 : 없음, 1 : 오션뷰, 2 : 마운틴 뷰, 3 : 시티뷰';

COMMENT ON COLUMN "HOTEL_RESERVE"."RESERVE_NAME" IS 'DEFAULT 예약한 회원이름';

COMMENT ON COLUMN "HOTEL_RESERVE"."RESERVE_EMAIL" IS 'DEFAULT 예약한  회원 메일';

COMMENT ON COLUMN "HOTEL_RESERVE"."RESIDENCE_NUM" IS '예약한 총 투숙 인원';

COMMENT ON COLUMN "HOTEL_RESERVE"."RESIDENCE_NAME_KO" IS '대표 투숙객 이름(한글)';

COMMENT ON COLUMN "HOTEL_RESERVE"."RESIDENCE_NAME_EN" IS '대표 투숙객 이름(영문)';

COMMENT ON COLUMN "HOTEL_RESERVE"."RESIDENCE_GENDER" IS '대표 투숙객 성별';

COMMENT ON COLUMN "HOTEL_RESERVE"."REQUEST" IS '요청사항(비트연산)';

COMMENT ON COLUMN "HOTEL_RESERVE"."RESERVE_CHECK_IN" IS '예약한 체크인 날짜';

COMMENT ON COLUMN "HOTEL_RESERVE"."RESERVE_CHECK_OUT" IS '예약한 체크아웃 날짜';

COMMENT ON COLUMN "HOTEL_RESERVE"."USER_ID" IS '8~20자 사이의 회원 아이디';

CREATE TABLE "HOTEL_REQUEST" (
	"REQUEST"	NUMBER(2)		NOT NULL,
	"REQUEST_DESC"	VARCHAR2(30)		NOT NULL
);

COMMENT ON COLUMN "HOTEL_REQUEST"."REQUEST" IS '0: 싱글, 1:트윈, 2: 더블, 3:금연실, 4:흡연실, 5: 고층';

COMMENT ON COLUMN "HOTEL_REQUEST"."REQUEST_DESC" IS '요청사항 번호에 대한 설명';

CREATE TABLE "BUSINESS_MEMBER" (
	"BUSINESS_NUM"	NUMBER(10)		NOT NULL,
	"SAVED_FILE_PATH"	VARCHAR2(500)		NOT NULL,
	"HOTEL_NAME"	VARCHAR2(50)		NOT NULL,
	"USER_ID"	VARCHAR2(20)		NOT NULL
);

COMMENT ON COLUMN "BUSINESS_MEMBER"."BUSINESS_NUM" IS '숫자로만 이루어진 10자리의 숫자';

COMMENT ON COLUMN "BUSINESS_MEMBER"."SAVED_FILE_PATH" IS '사업자 등록증 서류가 올라간 파일서버의 해당 파일 URL';

COMMENT ON COLUMN "BUSINESS_MEMBER"."HOTEL_NAME" IS '호텔 상호명';

COMMENT ON COLUMN "BUSINESS_MEMBER"."USER_ID" IS '8~20자 사이의 회원 아이디';

CREATE TABLE "HOTEL_DELETED" (
	"HOTEL_CODE"	VARCHAR2(10)	DEFAULT 0	NOT NULL,
	"HOTEL_NAME"	VARCHAR2(50)		NOT NULL,
	"HOTEL_ENG"	VARCHAR2(100)		NOT NULL,
	"HOTEL_ADDRESS"	VARCHAR2(500)		NOT NULL,
	"HOTEL_CALL"	VARCHAR2(20)		NOT NULL,
	"HOTEL_CHECK_IN"	VARCHAR2(25)		NOT NULL,
	"HOTEL_CHECK_OUT"	VARCHAR2(25)		NOT NULL,
	"HOTEL_INTRO"	VARCHAR2(1000)		NULL,
	"HOTEL_POLICY"	VARCHAR2(1000)		NULL,
	"HOTEL_SAFETY"	VARCHAR2(1000)		NULL,
	"HOTEL_PCOUNT"	NUMBER(15)	DEFAULT 0	NOT NULL,
	"HOTEL_LOC_CAT"	VARCHAR2(30)		NOT NULL,
	"BUSINESS_NUM"	NUMBER(10)		NOT NULL
);

COMMENT ON COLUMN "HOTEL_DELETED"."HOTEL_CODE" IS '0JJ015';

COMMENT ON COLUMN "HOTEL_DELETED"."HOTEL_NAME" IS '숙소 이름';

COMMENT ON COLUMN "HOTEL_DELETED"."HOTEL_ENG" IS '숙소 영어이름';

COMMENT ON COLUMN "HOTEL_DELETED"."HOTEL_ADDRESS" IS '숙소 주소';

COMMENT ON COLUMN "HOTEL_DELETED"."HOTEL_CALL" IS '숙소 전화번호';

COMMENT ON COLUMN "HOTEL_DELETED"."HOTEL_CHECK_IN" IS '체크인 시간';

COMMENT ON COLUMN "HOTEL_DELETED"."HOTEL_CHECK_OUT" IS '체크아웃 시간';

COMMENT ON COLUMN "HOTEL_DELETED"."HOTEL_INTRO" IS '숙소 소개';

COMMENT ON COLUMN "HOTEL_DELETED"."HOTEL_POLICY" IS '숙소 정책';

COMMENT ON COLUMN "HOTEL_DELETED"."HOTEL_SAFETY" IS '호텔 안전 정책';

COMMENT ON COLUMN "HOTEL_DELETED"."HOTEL_PCOUNT" IS '결제 횟수';

COMMENT ON COLUMN "HOTEL_DELETED"."HOTEL_LOC_CAT" IS '숙소 지역 분류';

COMMENT ON COLUMN "HOTEL_DELETED"."BUSINESS_NUM" IS '숫자로만 이루어진 10자리의 숫자';

CREATE TABLE "PASSENGER_INFO" (
	"PASSPORT_CODE"	VARCHAR2(10)		NULL,
	"AIRLINE_RESERVE_CODE"	VARCHAR2(10)		NOT NULL,
	"LAST_NAME"	VARCHAR2(20)		NOT NULL,
	"FIRST_NAME"	VARCHAR2(15)		NOT NULL,
	"BIRTH"	DATE		NOT NULL,
	"GENDER"	CHAR(1)		NOT NULL,
	"NATION"	VARCHAR(15)		NOT NULL,
	"BAGGAGE"	NUMBER(1)	DEFAULT 1	NOT NULL,
    "PASSPORT_CODE" VARCHAR2(10),
    "PASSPORT_DATE" DATE
);

COMMENT ON COLUMN "PASSENGER_INFO"."PASSPORT_CODE" IS '국내선 자국민은 여권번호 X 그 외엔 여권번호 필수';

--COMMENT ON COLUMN "PASSENGER_INFO"."AIRLINE_RESERVE_CODE" IS 'PK';

COMMENT ON COLUMN "PASSENGER_INFO"."GENDER" IS 'M=MALE    F=FEMALE';

COMMENT ON COLUMN "PASSENGER_INFO"."BAGGAGE" IS '1, 2, 3, 4로 4가지로 분류';

CREATE TABLE "HOTEL_ROOM" (
	"ROOM_CAT"	NUMBER(1)	NOT NULL,
	"ROOM_CAP"	NUMBER(3)	DEFAULT 1	NOT NULL,
	"ROOM_ATT"	NUMBER(1)	NOT NULL,
	"HOTEL_CODE"	VARCHAR2(10)	DEFAULT 0	NOT NULL,
	"HOTEL_PRICE"	NUMBER(15)		NOT NULL,
	"HOTEL_DISCOUNT"	NUMBER(4)	DEFAULT 0	NOT NULL,
	"ROOM_COUNT"	NUMBER(4)		NOT NULL
);

COMMENT ON COLUMN "HOTEL_ROOM"."ROOM_CAT" IS '방 종류(0: 스탠다드 룸, 1: 디럭스룸, 2: 슈페리어 륨, 3:스위트 룸, 4: 기타)';

COMMENT ON COLUMN "HOTEL_ROOM"."ROOM_CAP" IS '수용 인원수';

COMMENT ON COLUMN "HOTEL_ROOM"."ROOM_ATT" IS '0 : 없음, 1 : 오션뷰, 2 : 마운틴 뷰, 3 : 시티뷰';

COMMENT ON COLUMN "HOTEL_ROOM"."HOTEL_CODE" IS '0JJ015';

COMMENT ON COLUMN "HOTEL_ROOM"."HOTEL_PRICE" IS '방 가격';

COMMENT ON COLUMN "HOTEL_ROOM"."HOTEL_DISCOUNT" IS '0~100(%)';

COMMENT ON COLUMN "HOTEL_ROOM"."ROOM_COUNT" IS '해당 속성을 가진 방의 갯수';

CREATE TABLE "HOTEL_ROOM_CAT" (
	"ROOM_CAT"	NUMBER(1)		NOT NULL,
	"ROOM_CAT_DESC"	VARCHAR2(60)		NOT NULL
);

COMMENT ON COLUMN "HOTEL_ROOM_CAT"."ROOM_CAT" IS '방종류 코드';

COMMENT ON COLUMN "HOTEL_ROOM_CAT"."ROOM_CAT_DESC" IS '방종류 설명(스위트 룸인지 디럭스 룸 인지...)';

CREATE TABLE "HOTEL_ROOM_ATT" (
	"ROOM_ATT"	NUMBER(1)		NOT NULL,
	"ROOM_ATT_DESC"	VARCHAR2(60)		NOT NULL
);

COMMENT ON COLUMN "HOTEL_ROOM_ATT"."ROOM_ATT" IS '0 : 오션뷰, 1 : 마운틴 뷰, 2 : 시티뷰';

COMMENT ON COLUMN "HOTEL_ROOM_ATT"."ROOM_ATT_DESC" IS '오션뷰인지 마운틴뷰인지 설명...';

CREATE TABLE "PAY" (
	"APPROVE_NO"	VARCHAR2(100)		NOT NULL,
	"RESERVE_CORPER"	VARCHAR2(30)		NOT NULL,
	"CARD_NUM"	VARCHAR2(20)		NOT NULL,
	"PAY_PRICE"	NUMBER(8)		NOT NULL,
	"CURRENCY"	VARCHAR2(10)	DEFAULT 'KRW'	NOT NULL,
	"PAY_STATUS"	VARCHAR2(10)		NOT NULL,
	"HOTEL_RESERVE_CODE"	VARCHAR2(20)		NULL,
	"AIRLINE_RESERVE_CODE"	VARCHAR2(10)		NULL
);

COMMENT ON COLUMN "PAY"."APPROVE_NO" IS '결제 상태에 따라 부여되는 번호';

COMMENT ON COLUMN "PAY"."RESERVE_CORPER" IS 'EX) 1 : 신한, 2 : 농협 3: 카카오...';

COMMENT ON COLUMN "PAY"."CARD_NUM" IS '카드 번호';

COMMENT ON COLUMN "PAY"."PAY_PRICE" IS '최종 결제금액';

COMMENT ON COLUMN "PAY"."CURRENCY" IS '화폐 종류(원, 달러, 엔, 위안...)';

COMMENT ON COLUMN "PAY"."PAY_STATUS" IS '0 : 결제 완료, 1 : 결제 취소, 2 : 환불';

COMMENT ON COLUMN "PAY"."HOTEL_RESERVE_CODE" IS 'YYMMDD0JJ015S04';

COMMENT ON COLUMN "PAY"."AIRLINE_RESERVE_CODE" IS 'PK(202405279641001)';

CREATE TABLE "FAQ_CAT" (
	"FAQ_ID"	NUMBER(12)	DEFAULT 1	NOT NULL,
	"QUEST_CAT"	NUMBER(1)		NOT NULL
);

COMMENT ON COLUMN "FAQ_CAT"."FAQ_ID" IS '문의사항에 임의의 번호 부여 (SEQ_ASK_ID)';

COMMENT ON COLUMN "FAQ_CAT"."QUEST_CAT" IS '개인정보문의(1) , 상품관련(2) ,  결제(3)';

CREATE TABLE "FAQ_CAT_DESC" (
	"QUEST_CAT"	NUMBER(1)		NOT NULL,
	"QUEST_CAT_DESC"	VARCHAR2(30)		NOT NULL
);

COMMENT ON COLUMN "FAQ_CAT_DESC"."QUEST_CAT" IS '개인정보문의(1) , 상품관련(2) ,  결제(3)';

COMMENT ON COLUMN "FAQ_CAT_DESC"."QUEST_CAT_DESC" IS '문의 분류 코드에 대한 설명';

CREATE TABLE "DIRECT_VIA" (
	"AIRLINE_RESERVE_CODE"	VARCHAR2(10)		NOT NULL,
	"SEAT_GRADE"	NUMBER		NOT NULL,
	"AIRLINE_CODE"	VARCHAR2(20)		NOT NULL
);

COMMENT ON COLUMN "DIRECT_VIA"."AIRLINE_RESERVE_CODE" IS 'PK(202405279641001)';

COMMENT ON COLUMN "DIRECT_VIA"."SEAT_GRADE" IS 'PK';

COMMENT ON COLUMN "DIRECT_VIA"."AIRLINE_CODE" IS 'PK';

CREATE TABLE "HOTEL_FACILITY" (
	"HOTEL_FAC_CAT"	VARCHAR2(10)		NOT NULL,
	"HOTEL_CODE"	VARCHAR2(10)	DEFAULT 0	NOT NULL
);

COMMENT ON COLUMN "HOTEL_FACILITY"."HOTEL_FAC_CAT" IS '숙소가 보유한 편의시설 종류';

COMMENT ON COLUMN "HOTEL_FACILITY"."HOTEL_CODE" IS '0JJ015';

ALTER TABLE "HOTEL" ADD CONSTRAINT "PK_HOTEL" PRIMARY KEY (
	"HOTEL_CODE"
);

ALTER TABLE "HOTEL_REVIEW" ADD CONSTRAINT "PK_HOTEL_REVIEW" PRIMARY KEY (
	"APPROVE_NO", "HOTEL_RESERVE_CODE"
);

ALTER TABLE "HOTEL_LIKE" ADD CONSTRAINT "PK_HOTEL_LIKE" PRIMARY KEY (
	"USER_ID",
	"HOTEL_CODE"
);

ALTER TABLE "MEMBER" ADD CONSTRAINT "PK_MEMBER" PRIMARY KEY (
	"USER_ID"
);

ALTER TABLE "NOTICE_BOARD" ADD CONSTRAINT "PK_NOTICE_BOARD" PRIMARY KEY (
	"NOTICE_ID"
);

ALTER TABLE "HOTEL_PIC" ADD CONSTRAINT "PK_HOTEL_PIC" PRIMARY KEY (
	"HOTEL_PICTURE",
	"HOTEL_CODE"
);

ALTER TABLE "NOTICE_FILE" ADD CONSTRAINT "PK_NOTICE_FILE" PRIMARY KEY (
	"FILE_ID",
	"NOTICE_ID"
);

ALTER TABLE "SERVICE_CENTER" ADD CONSTRAINT "PK_SERVICE_CENTER" PRIMARY KEY (
	"FAQ_ID"
);

ALTER TABLE "ASK_FILE" ADD CONSTRAINT "PK_ASK_FILE" PRIMARY KEY (
	"FILE_ID",
	"FAQ_ID"
);

ALTER TABLE "SNSLOGIN_INFO" ADD CONSTRAINT "PK_SNSLOGIN_INFO" PRIMARY KEY (
	"USER_ID"
);

ALTER TABLE "AIRLINE_INFO" ADD CONSTRAINT "PK_AIRLINE_INFO" PRIMARY KEY (
	"AIRLINE_CODE"
);

ALTER TABLE "SEAT_GRADE" ADD CONSTRAINT "PK_SEAT_GRADE" PRIMARY KEY (
	"SEAT_GRADE",
	"AIRLINE_CODE"
);

ALTER TABLE "AIRLINE_RESERVE_INFO" ADD CONSTRAINT "PK_AIRLINE_RESERVE_INFO" PRIMARY KEY (
	"AIRLINE_RESERVE_CODE"
);

ALTER TABLE "HOTEL_RESERVE" ADD CONSTRAINT "PK_HOTEL_RESERVE" PRIMARY KEY (
	"HOTEL_RESERVE_CODE"
);

ALTER TABLE "BUSINESS_MEMBER" ADD CONSTRAINT "PK_BUSINESS_MEMBER" PRIMARY KEY (
	"BUSINESS_NUM"
);

ALTER TABLE "HOTEL_DELETED" ADD CONSTRAINT "PK_HOTEL_DELETED" PRIMARY KEY (
	"HOTEL_CODE"
);

ALTER TABLE "HOTEL_DELETED" ADD CONSTRAINT "FK_BUSINESS_MEMBER_TO_HOTEL_DELETED_1" FOREIGN KEY (
	"BUSINESS_NUM"
)
REFERENCES "BUSINESS_MEMBER" (
	"BUSINESS_NUM"
);

--ALTER TABLE "PASSENGER_INFO" ADD CONSTRAINT "PK_PASSENGER_INFO" PRIMARY KEY (
--	"PASSPORT_CODE",
--	"AIRLINE_RESERVE_CODE"
--);

ALTER TABLE "HOTEL_ROOM_CAT" ADD CONSTRAINT "PK_HOTEL_ROOM_CAT" PRIMARY KEY (
	"ROOM_CAT"
);

ALTER TABLE "HOTEL_ROOM_ATT" ADD CONSTRAINT "PK_HOTEL_ROOM_ATT" PRIMARY KEY (
	"ROOM_ATT"
);

ALTER TABLE "HOTEL_ROOM" ADD CONSTRAINT "FK_HOTEL_ROOM_CAT_TO_HOTEL_ROOM_1" FOREIGN KEY (
	"ROOM_CAT"
)
REFERENCES "HOTEL_ROOM_CAT" (
	"ROOM_CAT"
);

ALTER TABLE "HOTEL_ROOM" ADD CONSTRAINT "FK_HOTEL_ROOM_ATT_TO_HOTEL_ROOM_1" FOREIGN KEY (
	"ROOM_ATT"
)
REFERENCES "HOTEL_ROOM_ATT" (
	"ROOM_ATT"
);

ALTER TABLE "HOTEL_ROOM" ADD CONSTRAINT "FK_HOTEL_TO_HOTEL_ROOM_1" FOREIGN KEY (
	"HOTEL_CODE"
)
REFERENCES "HOTEL" (
	"HOTEL_CODE"
);

ALTER TABLE "HOTEL_ROOM" ADD CONSTRAINT "PK_HOTEL_ROOM" PRIMARY KEY (
	"ROOM_CAT",
	"ROOM_CAP",
	"ROOM_ATT",
	"HOTEL_CODE"
);

ALTER TABLE "PAY" ADD CONSTRAINT "PK_PAY" PRIMARY KEY (
	"APPROVE_NO"
);

ALTER TABLE "DIRECT_VIA" ADD CONSTRAINT "PK_DIRECT_VIA" PRIMARY KEY (
	"AIRLINE_RESERVE_CODE",
	"SEAT_GRADE",
	"AIRLINE_CODE"
);

ALTER TABLE "HOTEL_FACILITY" ADD CONSTRAINT "PK_HOTEL_FACILITY" PRIMARY KEY (
	"HOTEL_FAC_CAT",
	"HOTEL_CODE"
);

ALTER TABLE "HOTEL" ADD CONSTRAINT "FK_BUSINESS_MEMBER_TO_HOTEL_1" FOREIGN KEY (
	"BUSINESS_NUM"
)
REFERENCES "BUSINESS_MEMBER" (
	"BUSINESS_NUM"
);

ALTER TABLE "HOTEL_REVIEW" ADD CONSTRAINT "FK_PAY_TO_HOTEL_REVIEW_1" FOREIGN KEY (
	"APPROVE_NO"
)
REFERENCES "PAY" (
	"APPROVE_NO"
);

ALTER TABLE "HOTEL_REVIEW" ADD CONSTRAINT "FK_HOTEL_RESERVE_TO_HOTEL_REVIEW_1" FOREIGN KEY (
	"HOTEL_RESERVE_CODE"
)
REFERENCES "HOTEL_RESERVE" (
	"HOTEL_RESERVE_CODE"
);

ALTER TABLE "HOTEL_LIKE" ADD CONSTRAINT "FK_MEMBER_TO_HOTEL_LIKE_1" FOREIGN KEY (
	"USER_ID"
)
REFERENCES "MEMBER" (
	"USER_ID"
);

ALTER TABLE "HOTEL_LIKE" ADD CONSTRAINT "FK_HOTEL_TO_HOTEL_LIKE_1" FOREIGN KEY (
	"HOTEL_CODE"
)
REFERENCES "HOTEL" (
	"HOTEL_CODE"
);

ALTER TABLE "NOTICE_BOARD" ADD CONSTRAINT "FK_MEMBER_TO_NOTICE_BOARD_1" FOREIGN KEY (
	"USER_ID"
)
REFERENCES "MEMBER" (
	"USER_ID"
);

ALTER TABLE "HOTEL_PIC" ADD CONSTRAINT "FK_HOTEL_TO_HOTEL_PIC_1" FOREIGN KEY (
	"HOTEL_CODE"
)
REFERENCES "HOTEL" (
	"HOTEL_CODE"
);

ALTER TABLE "NOTICE_FILE" ADD CONSTRAINT "FK_NOTICE_BOARD_TO_NOTICE_FILE_1" FOREIGN KEY (
	"NOTICE_ID"
)
REFERENCES "NOTICE_BOARD" (
	"NOTICE_ID"
);

ALTER TABLE "SERVICE_CENTER" ADD CONSTRAINT "FK_MEMBER_TO_SERVICE_CENTER_1" FOREIGN KEY (
	"USER_ID"
)
REFERENCES "MEMBER" (
	"USER_ID"
);

ALTER TABLE "ASK_FILE" ADD CONSTRAINT "FK_SERVICE_CENTER_TO_ASK_FILE_1" FOREIGN KEY (
	"FAQ_ID"
)
REFERENCES "SERVICE_CENTER" (
	"FAQ_ID"
);

ALTER TABLE "SNSLOGIN_INFO" ADD CONSTRAINT "FK_MEMBER_TO_SNSLOGIN_INFO_1" FOREIGN KEY (
	"USER_ID"
)
REFERENCES "MEMBER" (
	"USER_ID"
);

ALTER TABLE "SEAT_GRADE" ADD CONSTRAINT "FK_AIRLINE_INFO_TO_SEAT_GRADE_1" FOREIGN KEY (
	"AIRLINE_CODE"
)
REFERENCES "AIRLINE_INFO" (
	"AIRLINE_CODE"
);

ALTER TABLE "AIRLINE_RESERVE_INFO" ADD CONSTRAINT "FK_MEMBER_TO_AIRLINE_RESERVE_INFO_1" FOREIGN KEY (
	"USER_ID"
)
REFERENCES "MEMBER" (
	"USER_ID"
);

ALTER TABLE "HOTEL_RESERVE" ADD CONSTRAINT "FK_HOTEL_ROOM_TO_HOTEL_RESERVE_1" FOREIGN KEY (
	"ROOM_CAT", "HOTEL_CODE", "ROOM_CAP", "ROOM_ATT"
)
REFERENCES "HOTEL_ROOM" (
	"ROOM_CAT", "HOTEL_CODE", "ROOM_CAP", "ROOM_ATT"
);

ALTER TABLE "HOTEL_RESERVE" ADD CONSTRAINT "FK_MEMBER_TO_HOTEL_RESERVE_1" FOREIGN KEY (
	"USER_ID"
)
REFERENCES "MEMBER" (
	"USER_ID"
);

ALTER TABLE "HOTEL_REQUEST" ADD CONSTRAINT "PK_HOTEL_REQUEST" PRIMARY KEY (
	"REQUEST"
);

ALTER TABLE "BUSINESS_MEMBER" ADD CONSTRAINT "FK_MEMBER_TO_BUSINESS_MEMBER_1" FOREIGN KEY (
	"USER_ID"
)
REFERENCES "MEMBER" (
	"USER_ID"
);

ALTER TABLE "PASSENGER_INFO" ADD CONSTRAINT "FK_AIRLINE_RESERVE_INFO_TO_PASSENGER_INFO_1" FOREIGN KEY (
	"AIRLINE_RESERVE_CODE"
)
REFERENCES "AIRLINE_RESERVE_INFO" (
	"AIRLINE_RESERVE_CODE"
);

ALTER TABLE "PAY" ADD CONSTRAINT "FK_HOTEL_RESERVE_TO_PAY_1" FOREIGN KEY (
	"HOTEL_RESERVE_CODE"
)
REFERENCES "HOTEL_RESERVE" (
	"HOTEL_RESERVE_CODE"
);

ALTER TABLE "PAY" ADD CONSTRAINT "FK_AIRLINE_RESERVE_INFO_TO_PAY_1" FOREIGN KEY (
	"AIRLINE_RESERVE_CODE"
)
REFERENCES "AIRLINE_RESERVE_INFO" (
	"AIRLINE_RESERVE_CODE"
);

ALTER TABLE "DIRECT_VIA" ADD CONSTRAINT "FK_AIRLINE_RESERVE_INFO_TO_DIRECT_VIA_1" FOREIGN KEY (
	"AIRLINE_RESERVE_CODE"
)
REFERENCES "AIRLINE_RESERVE_INFO" (
	"AIRLINE_RESERVE_CODE"
);

ALTER TABLE "DIRECT_VIA" ADD CONSTRAINT "FK_SEAT_GRADE_TO_DIRECT_VIA_1" FOREIGN KEY (
	"SEAT_GRADE", "AIRLINE_CODE"
)
REFERENCES "SEAT_GRADE" (
	"SEAT_GRADE", "AIRLINE_CODE"
);

ALTER TABLE "HOTEL_FACILITY" ADD CONSTRAINT "FK_HOTEL_TO_HOTEL_FACILITY_1" FOREIGN KEY (
	"HOTEL_CODE"
)
REFERENCES "HOTEL" (
	"HOTEL_CODE"
);

ALTER TABLE "FAQ_CAT" ADD CONSTRAINT "PK_FAQ_CAT" PRIMARY KEY (
	"FAQ_ID",
	"QUEST_CAT"
);

ALTER TABLE "FAQ_CAT" ADD CONSTRAINT "FK_SERVICE_CENTER_TO_FAQ_CAT_1" FOREIGN KEY (
	"FAQ_ID"
)
REFERENCES "SERVICE_CENTER" (
	"FAQ_ID"
);

ALTER TABLE "FAQ_CAT" ADD CONSTRAINT "PK_FAQ_CAT" PRIMARY KEY (
	"FAQ_ID",
	"QUEST_CAT"
);

ALTER TABLE "FAQ_CAT_DESC" ADD CONSTRAINT "PK_FAQ_CAT_DESC" PRIMARY KEY (
	"QUEST_CAT"
);

insert all into hotel_room_att values (0, '없음')
        into hotel_room_att values (1, '오션뷰')
        into hotel_room_att values (2, '마운틴뷰')
        into hotel_room_att values (3, '시티뷰')
        into hotel_room_att values (4, '기타')
        select * from dual;
        
insert all into hotel_room_cat values (0, '스탠다드 룸')
        into hotel_room_cat values (1, '디럭스 룸')
        into hotel_room_cat values (2, '슈페리어 룸')
        into hotel_room_cat values (3, '스위트 룸')
        into hotel_room_cat values (4, '기타')
        select * from dual;

insert all into HOTEL_REQUEST values (1, '싱글')
            into HOTEL_REQUEST values (2, '트윈')
            into HOTEL_REQUEST values (4, '더블')
            into HOTEL_REQUEST values (8, '금연실')
            into HOTEL_REQUEST values (16, '흡연실')
            into HOTEL_REQUEST values (32, '고층')
            select * from dual;

--예약한 호텔의 체크아웃 날짜가 지나면 리뷰 작성 가능하게 만드는 트리거
CREATE OR REPLACE PROCEDURE update_review_available_procedure IS
BEGIN
    UPDATE hotel_reserve hr
    SET hr.REVIEW_AVAILABLE = 1
    WHERE EXISTS (
        SELECT 1
        FROM pay p
        WHERE p.HOTEL_RESERVE_CODE = hr.HOTEL_RESERVE_CODE
          AND p.PAY_STATUS = 'paid'
    )
    AND TO_DATE(hr.RESERVE_CHECK_OUT, 'YYYY"년"MM"월"DD"일"') <= SYSDATE;

    COMMIT;
END;
/

-- 위 트리거의 스케쥴러 작성 (1시간마다 작동)
BEGIN
    DBMS_SCHEDULER.create_job (
        job_name        => 'update_review_available_job',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN update_review_available_procedure; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=HOURLY; INTERVAL=1',
        enabled         => TRUE
    );
END;
/
            
commit;