CREATE INDEX idx_users_email       ON Users(Email);
CREATE INDEX idx_users_role        ON Users(Role);

CREATE INDEX idx_uha_userid        ON User_Has_Address(UserID);

CREATE INDEX idx_restaurant_status ON Restaurant(Restaurant_Status);
CREATE INDEX idx_restaurant_rating ON Restaurant(Rating DESC);
CREATE INDEX idx_restaurant_name   ON Restaurant(Name);

CREATE INDEX idx_raddr_restid      ON Restaurant_Address(Restaurant_ID);
CREATE INDEX idx_raddr_city        ON Restaurant_Address(City);

CREATE INDEX idx_cuisine_restid    ON Cuisine(Restaurant_ID);

CREATE INDEX idx_mcat_restid       ON Menu_Category(Restaurant_ID);

CREATE INDEX idx_mitem_restid      ON Menu_Item(Restaurant_ID);
CREATE INDEX idx_mitem_category    ON Menu_Item(Category_Name, Restaurant_ID);
CREATE INDEX idx_mitem_price       ON Menu_Item(Price);
CREATE INDEX idx_mitem_available   ON Menu_Item(Is_Available);

CREATE INDEX idx_review_restid     ON Review(Restaurant_ID);
CREATE INDEX idx_review_userid     ON Review(UserID);
CREATE INDEX idx_review_rating     ON Review(Rating DESC);

CREATE INDEX idx_cart_userid       ON Cart(UserID);
CREATE INDEX idx_cart_status       ON Cart(Status);

CREATE INDEX idx_cartitem_cartid   ON Cart_Item(Cart_ID);
CREATE INDEX idx_cartitem_itemid   ON Cart_Item(Item_ID);

CREATE INDEX idx_orders_userid     ON Orders(UserID);
CREATE INDEX idx_orders_restid     ON Orders(Restaurant_ID);
CREATE INDEX idx_orders_status     ON Orders(Status);
CREATE INDEX idx_orders_datetime   ON Orders(Date_Time DESC);

CREATE INDEX idx_oitem_orderid     ON Order_Item(OrderID);
CREATE INDEX idx_oitem_itemid      ON Order_Item(Item_ID);

CREATE INDEX idx_payment_orderid   ON Payment(Order_ID);
CREATE INDEX idx_payment_status    ON Payment(Status);
CREATE INDEX idx_payment_mode      ON Payment(Mode);

CREATE INDEX idx_dp_rating         ON Delivery_Partner(Rating DESC);
CREATE INDEX idx_dp_active         ON Delivery_Partner(Is_Active);

CREATE INDEX idx_delivery_orderid  ON Delivery(OrderID);
CREATE INDEX idx_delivery_partner  ON Delivery(Partner_ID);
CREATE INDEX idx_delivery_status   ON Delivery(Status);

CREATE INDEX idx_wallet_userid     ON Wallet(UserID);

CREATE INDEX idx_wtxn_walletid     ON Wallet_Transaction(Wallet_ID);
CREATE INDEX idx_wtxn_type         ON Wallet_Transaction(Type);
CREATE INDEX idx_wtxn_datetime     ON Wallet_Transaction(Date_Time DESC);

CREATE INDEX idx_topup_walletid    ON Wallet_TopUP(Wallet_ID);
CREATE INDEX idx_topup_status      ON Wallet_TopUP(Status);

CREATE INDEX idx_discount_orderid  ON Discount(OrderID);

CREATE INDEX idx_complaint_orderid ON Complaint(OrderID);
CREATE INDEX idx_complaint_status  ON Complaint(Status);

CREATE INDEX idx_refund_orderid    ON Refund(OrderID);
CREATE INDEX idx_refund_complaint  ON Refund(Complaint_ID);
CREATE INDEX idx_refund_wallet     ON Refund(Wallet_ID);
CREATE INDEX idx_refund_status     ON Refund(Refund_Status);

CREATE INDEX idx_cancel_orderid    ON Cancellation(OrderID);
CREATE INDEX idx_cancel_by         ON Cancellation(Cancelled_By);
