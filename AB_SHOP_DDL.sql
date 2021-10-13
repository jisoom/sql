-- 주문상품
CREATE TABLE "AB_ORDER_PROD" (
	"ORDER_NO"  NUMBER NOT NULL, -- 주문번호
	"PROD_NO"   NUMBER NOT NULL, -- 상품번호
	"ORDER_QTY" NUMBER NOT NULL  -- 수량
);

-- 주문상품 기본키
CREATE UNIQUE INDEX "PK_AB_ORDER_PROD"
	ON "AB_ORDER_PROD" ( -- 주문상품
		"ORDER_NO" ASC, -- 주문번호
		"PROD_NO"  ASC  -- 상품번호
	);

-- 주문상품
ALTER TABLE "AB_ORDER_PROD"
	ADD
		CONSTRAINT "PK_AB_ORDER_PROD" -- 주문상품 기본키
		PRIMARY KEY (
			"ORDER_NO", -- 주문번호
			"PROD_NO"   -- 상품번호
		);

-- 1:1문의
CREATE TABLE "AB_QNA" (
	"QNA_NO"          NUMBER         NOT NULL, -- 문의번호
	"MEM_ID"          VARCHAR2(100)  NOT NULL, --  회원아이디
	"ADMIN_ID"        VARCHAR2(100)  NULL,     -- 관리자아이디
	"QNA_TITLE"       VARCHAR2(500)  NOT NULL, -- 제목
	"QNA_CONTENT"     VARCHAR2(1000) NOT NULL, -- 내용
	"QNA_REG_DATE"    DATE           NOT NULL, -- 문의등록일
	"QNA_RE_REG_DATE" DATE           NULL,     -- 답변등록일
	"QNA_RECONTENT"   VARCHAR2(1000) NULL      -- 관리자답변내용
);

-- 1:1문의 기본키
CREATE UNIQUE INDEX "PK_AB_QNA"
	ON "AB_QNA" ( -- 1:1문의
		"QNA_NO" ASC -- 문의번호
	);

-- 1:1문의
ALTER TABLE "AB_QNA"
	ADD
		CONSTRAINT "PK_AB_QNA" -- 1:1문의 기본키
		PRIMARY KEY (
			"QNA_NO" -- 문의번호
		);

-- 주문
CREATE TABLE "AB_ORDER" (
	"ORDER_NO"   NUMBER        NOT NULL, -- 주문번호
	"MEM_ID"     VARCHAR2(100) NOT NULL, --  회원아이디
	"ORDER_SD"   VARCHAR2(200) NOT NULL, -- 배송지
	"ORDER_DATE" DATE          NOT NULL, -- 주문일
	"ORDER_PAY"  NUMBER        NOT NULL, -- 결제금액
	"PAY_CODE"   VARCHAR2(20)  NULL      -- 결제수단코드
);

-- 주문 기본키
CREATE UNIQUE INDEX "PK_AB_ORDER"
	ON "AB_ORDER" ( -- 주문
		"ORDER_NO" ASC -- 주문번호
	);

-- 주문
ALTER TABLE "AB_ORDER"
	ADD
		CONSTRAINT "PK_AB_ORDER" -- 주문 기본키
		PRIMARY KEY (
			"ORDER_NO" -- 주문번호
		);

-- 장바구니
CREATE TABLE "AB_CART" (
	"CART_NO"  NUMBER        NOT NULL, -- 장바구니 번호
	"CART_QTY" NUMBER        NULL,     -- 수량
	"PROD_NO"  NUMBER        NOT NULL, -- 상품번호
	"MEM_ID"   VARCHAR2(100) NOT NULL  --  회원아이디
);

-- 장바구니 기본키2
CREATE UNIQUE INDEX "PK_AB_CART"
	ON "AB_CART" ( -- 장바구니
		"CART_NO" ASC -- 장바구니 번호
	);

-- 장바구니
ALTER TABLE "AB_CART"
	ADD
		CONSTRAINT "PK_AB_CART" -- 장바구니 기본키2
		PRIMARY KEY (
			"CART_NO" -- 장바구니 번호
		);

-- 관리자
CREATE TABLE "AB_ADMIN" (
	"ADMIN_ID"   VARCHAR2(100) NOT NULL, -- 관리자아이디
	"ADMIN_PW"   VARCHAR2(200) NOT NULL, -- 관리자비밀번호
	"ADMIN_NAME" VARCHAR2(200) NOT NULL  -- 관리자이름
);

-- 관리자 기본키
CREATE UNIQUE INDEX "PK_AB_ADMIN"
	ON "AB_ADMIN" ( -- 관리자
		"ADMIN_ID" ASC -- 관리자아이디
	);

-- 관리자
ALTER TABLE "AB_ADMIN"
	ADD
		CONSTRAINT "PK_AB_ADMIN" -- 관리자 기본키
		PRIMARY KEY (
			"ADMIN_ID" -- 관리자아이디
		);

-- 후기
CREATE TABLE "AB_REVIEW" (
	"MEM_ID"          VARCHAR2(100)  NOT NULL, --  회원아이디
	"REVIEW_ASTERION" NUMBER         NULL,     -- 별점
	"REVIEW_CONTENT"  VARCHAR2(1000) NULL,     -- 내용
	"REVIEW_REG_DATE" DATE           NOT NULL  -- 등록일
);

-- 후기 기본키
CREATE UNIQUE INDEX "PK_AB_REVIEW"
	ON "AB_REVIEW" ( -- 후기
		"MEM_ID" ASC --  회원아이디
	);

-- 후기
ALTER TABLE "AB_REVIEW"
	ADD
		CONSTRAINT "PK_AB_REVIEW" -- 후기 기본키
		PRIMARY KEY (
			"MEM_ID" --  회원아이디
		);

-- 공지사항
CREATE TABLE "AB_NOTICE" (
	"NOTI_NO"       NUMBER         NOT NULL, -- 공지사항번호
	"ADMIN_ID"      VARCHAR2(100)  NOT NULL, -- 관리자아이디
	"NOTI_TITLE"    VARCHAR2(500)  NOT NULL, -- 제목
	"NOTI_CONTENT"  VARCHAR2(1000) NOT NULL, -- 내용
	"NOTI_REG_DATE" DATE           NOT NULL  -- 등록일
);

-- 공지사항 기본키
CREATE UNIQUE INDEX "PK_AB_NOTICE"
	ON "AB_NOTICE" ( -- 공지사항
		"NOTI_NO" ASC -- 공지사항번호
	);

-- 공지사항
ALTER TABLE "AB_NOTICE"
	ADD
		CONSTRAINT "PK_AB_NOTICE" -- 공지사항 기본키
		PRIMARY KEY (
			"NOTI_NO" -- 공지사항번호
		);

-- 상품
CREATE TABLE "AB_PROD" (
	"PROD_NO"        NUMBER        NOT NULL, -- 상품번호
	"PROD_NAME"      VARCHAR2(200) NOT NULL, -- 상품이름
	"PROD_STOCK_QTY" NUMBER        NULL,     -- 재고수량
	"PROD_PRICE"     NUMBER        NULL,     -- 가격
	"PROD_FIELD"     VARCHAR2(200) NOT NULL, -- 분류
	"PROD_REG_DATE"  DATE          NOT NULL, -- 등록일
	"PROD_SIZE"      VARCHAR2(50)  NULL,     -- 사이즈
	"PROD_COLOR"     VARCHAR2(50)  NULL      -- 색상
);

-- 상품 기본키
CREATE UNIQUE INDEX "PK_AB_PROD"
	ON "AB_PROD" ( -- 상품
		"PROD_NO" ASC -- 상품번호
	);

-- 상품
ALTER TABLE "AB_PROD"
	ADD
		CONSTRAINT "PK_AB_PROD" -- 상품 기본키
		PRIMARY KEY (
			"PROD_NO" -- 상품번호
		);

-- 결제수단
CREATE TABLE "AB_PAY" (
	"PAY_CODE" VARCHAR2(20) NOT NULL, -- 결제수단코드
	"PAY_WAY"  VARCHAR2(50) NOT NULL  -- 결제방법
);

-- 결제수단 기본키
CREATE UNIQUE INDEX "PK_AB_PAY"
	ON "AB_PAY" ( -- 결제수단
		"PAY_CODE" ASC -- 결제수단코드
	);

-- 결제수단
ALTER TABLE "AB_PAY"
	ADD
		CONSTRAINT "PK_AB_PAY" -- 결제수단 기본키
		PRIMARY KEY (
			"PAY_CODE" -- 결제수단코드
		);

-- 회원
CREATE TABLE "AB_MEMBER" (
	"MEM_ID"    VARCHAR2(100) NOT NULL, --  회원아이디
	"MEM_PW"    VARCHAR2(200) NOT NULL, -- 회원비밀번호
	"MEM_NAME"  VARCHAR2(200) NOT NULL, -- 회원이름
	"MEM_BIRTH" DATE          NULL,     -- 생년월일
	"MEM_ADDR"  VARCHAR2(200) NULL,     -- 주소
	"MEM_TEL"   VARCHAR2(100) NULL      -- 전화번호
);

-- 회원 기본키
CREATE UNIQUE INDEX "PK_AB_MEMBER"
	ON "AB_MEMBER" ( -- 회원
		"MEM_ID" ASC --  회원아이디
	);

-- 회원
ALTER TABLE "AB_MEMBER"
	ADD
		CONSTRAINT "PK_AB_MEMBER" -- 회원 기본키
		PRIMARY KEY (
			"MEM_ID" --  회원아이디
		);

-- 주문상품
ALTER TABLE "AB_ORDER_PROD"
	ADD
		CONSTRAINT "FK_AB_PROD_TO_AB_ORDER_PROD" -- 상품 -> 주문상품
		FOREIGN KEY (
			"PROD_NO" -- 상품번호
		)
		REFERENCES "AB_PROD" ( -- 상품
			"PROD_NO" -- 상품번호
		);

-- 주문상품
ALTER TABLE "AB_ORDER_PROD"
	ADD
		CONSTRAINT "FK_AB_ORDER_TO_AB_ORDER_PROD" -- 주문 -> 주문상품
		FOREIGN KEY (
			"ORDER_NO" -- 주문번호
		)
		REFERENCES "AB_ORDER" ( -- 주문
			"ORDER_NO" -- 주문번호
		);

-- 1:1문의
ALTER TABLE "AB_QNA"
	ADD
		CONSTRAINT "FK_AB_MEMBER_TO_AB_QNA" -- 회원 -> 1:1문의
		FOREIGN KEY (
			"MEM_ID" --  회원아이디
		)
		REFERENCES "AB_MEMBER" ( -- 회원
			"MEM_ID" --  회원아이디
		);

-- 1:1문의
ALTER TABLE "AB_QNA"
	ADD
		CONSTRAINT "FK_AB_ADMIN_TO_AB_QNA" -- 관리자 -> 1:1문의
		FOREIGN KEY (
			"ADMIN_ID" -- 관리자아이디
		)
		REFERENCES "AB_ADMIN" ( -- 관리자
			"ADMIN_ID" -- 관리자아이디
		);

-- 주문
ALTER TABLE "AB_ORDER"
	ADD
		CONSTRAINT "FK_AB_MEMBER_TO_AB_ORDER" -- 회원 -> 주문
		FOREIGN KEY (
			"MEM_ID" --  회원아이디
		)
		REFERENCES "AB_MEMBER" ( -- 회원
			"MEM_ID" --  회원아이디
		);

-- 주문
ALTER TABLE "AB_ORDER"
	ADD
		CONSTRAINT "FK_AB_PAY_TO_AB_ORDER" -- 결제수단 -> 주문
		FOREIGN KEY (
			"PAY_CODE" -- 결제수단코드
		)
		REFERENCES "AB_PAY" ( -- 결제수단
			"PAY_CODE" -- 결제수단코드
		);

-- 장바구니
ALTER TABLE "AB_CART"
	ADD
		CONSTRAINT "FK_AB_PROD_TO_AB_CART" -- 상품 -> 장바구니2
		FOREIGN KEY (
			"PROD_NO" -- 상품번호
		)
		REFERENCES "AB_PROD" ( -- 상품
			"PROD_NO" -- 상품번호
		);

-- 장바구니
ALTER TABLE "AB_CART"
	ADD
		CONSTRAINT "FK_AB_MEMBER_TO_AB_CART" -- 회원 -> 장바구니2
		FOREIGN KEY (
			"MEM_ID" --  회원아이디
		)
		REFERENCES "AB_MEMBER" ( -- 회원
			"MEM_ID" --  회원아이디
		);

-- 후기
ALTER TABLE "AB_REVIEW"
	ADD
		CONSTRAINT "FK_AB_MEMBER_TO_AB_REVIEW" -- 회원 -> 후기
		FOREIGN KEY (
			"MEM_ID" --  회원아이디
		)
		REFERENCES "AB_MEMBER" ( -- 회원
			"MEM_ID" --  회원아이디
		);

-- 공지사항
ALTER TABLE "AB_NOTICE"
	ADD
		CONSTRAINT "FK_AB_ADMIN_TO_AB_NOTICE" -- 관리자 -> 공지사항
		FOREIGN KEY (
			"ADMIN_ID" -- 관리자아이디
		)
		REFERENCES "AB_ADMIN" ( -- 관리자
			"ADMIN_ID" -- 관리자아이디
		);