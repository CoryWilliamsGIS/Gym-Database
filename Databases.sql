--CEGEG129 - SPATIAL DATABASES AND DATA MANAGEMENT 
--ASSIGNMENT 2 
--CORY WILLIAMS



--CREATE LAND PARCEL TABLE 
CREATE TABLE public.Land_Parcel (
Parcel_Number INTEGER NOT NULL, 
Location GEOMETRY);

--CREATE FACILITY TABLE
CREATE TABLE public.Facility (
Facility_ID SERIAL NOT NULL, 
Facility_Address_Line1 VARCHAR(50) NOT NULL, 
Facility_Address_Line2 VARCHAR(50),
Facility_Address_Line3 VARCHAR(50),
Facility_Postcode VARCHAR(8) NOT NULL,
Facility_Phone_Number VARCHAR(15) NOT NULL,
Number_of_Floors INTEGER NOT NULL, 
Location GEOMETRY,
Parcel_Number INTEGER);

--CREATE MANAGER TABLE
CREATE TABLE public.Manager (
Manager_ID SERIAL NOT NULL,
Manager_Forename VARCHAR(20) NOT NULL,
Manager_Surname VARCHAR(20) NOT NULL,
Manager_Phone_Number VARCHAR(15) NOT NULL,
Manager_DOB DATE NOT NULL,
Manager_Address_Line1 VARCHAR(50) NOT NULL,
Manager_Address_Line2 VARCHAR(50),
Manager_Address_Line3 VARCHAR(50),
Manager_Postcode VARCHAR(8) NOT NULL, 
Manager_Email_Address VARCHAR(50) NOT NULL,
Facility_ID INTEGER);

--CREATE INSTRUCTOR TABLE
CREATE TABLE public.Instructor (
Instructor_ID SERIAL NOT NULL, 
Instructor_Forename VARCHAR(20) NOT NULL,
Instructor_Surname VARCHAR(20) NOT NULL,
Instructor_Phone_Number VARCHAR(15) NOT NULL,
Instructor_DOB DATE NOT NULL,
Instructor_Address_Line1 VARCHAR(50) NOT NULL,
Instructor_Address_Line2 VARCHAR(50),
Instructor_Address_Line3 VARCHAR(50),
Instructor_Postcode VARCHAR(8) NOT NULL, 
Instructor_Email_Address VARCHAR(50) NOT NULL,
Facility_ID INTEGER);

--CREATE CUSTOMER TABLE
CREATE TABLE public.Customer (
Customer_ID SERIAL NOT NULL, 
Customer_Forename VARCHAR(20) NOT NULL, 
Customer_Surname VARCHAR(20) NOT NULL,
Customer_Phone_Number VARCHAR(15) NOT NULL,  
Customer_DOB DATE NOT NULL, 
Gender CHAR(1) NOT NULL, 
Customer_Email_Address VARCHAR(50) NOT NULL, 
Facility_ID INTEGER); 

--CREATE MEMBERSHIP TABLE
CREATE TABLE public.Membership (
Membership_ID SERIAL NOT NULL,
Date_Joined DATE NOT NULL,
Activation_Date DATE NOT NULL, 
Activation_Time TIME NOT NULL, 
Date_Cancelled DATE,
Membership_type VARCHAR(10) NOT NULL,  
Active CHAR(1) NOT NULL,
Customer_ID INTEGER);

--CREATE CLASSES TABLE
CREATE TABLE public.Classes (
Class_ID SERIAL NOT NULL, 
Class_Date DATE NOT NULL,
Class_Time TIME NOT NULL,
Class_Type VARCHAR(20) NOT NULL,
Instructor_ID INTEGER,
Customer_ID INTEGER);

--CREATE EQUIPMENT TABLE
CREATE TABLE public.Equipment(
Equipment_SN INTEGER NOT NULL,
Equipment_Category VARCHAR(20) NOT NULL,
Equipment_Name VARCHAR(20) NOT NULL,
Customer_ID INTEGER);

--ADD PRIMARY KEYS TO CREATED TABLES
ALTER TABLE public.Land_Parcel ADD CONSTRAINT Land_Parcel_pk PRIMARY KEY (Parcel_Number);
ALTER TABLE public.Facility ADD CONSTRAINT Facility_pk PRIMARY KEY (Facility_ID);
ALTER TABLE public.Manager ADD CONSTRAINT Manager_pk PRIMARY KEY (Manager_ID);
ALTER TABLE public.Instructor ADD CONSTRAINT Instructor_pk PRIMARY KEY (Instructor_ID);
ALTER TABLE public.Customer ADD CONSTRAINT Customer_pk PRIMARY KEY (Customer_ID);
ALTER TABLE public.Membership ADD CONSTRAINT Membership_pk PRIMARY KEY (Membership_ID);
ALTER TABLE public.Equipment ADD CONSTRAINT Equipment_pk PRIMARY KEY (Equipment_SN);
ALTER TABLE public.Classes ADD CONSTRAINT Classes_pk PRIMARY KEY (Class_ID);

--ADD FOREIGN KEYS TO CREATED TABLES
ALTER TABLE public.Facility ADD CONSTRAINT Facility_Land_Parcel_fk FOREIGN KEY (Parcel_Number) REFERENCES public.Land_Parcel (Parcel_Number);
ALTER TABLE public.Manager ADD CONSTRAINT Manager_Facility_fk FOREIGN KEY (Facility_ID) REFERENCES public.Facility (Facility_ID);
ALTER TABLE public.Instructor ADD CONSTRAINT Instructor_Facility_fk FOREIGN KEY (Facility_ID) REFERENCES public.Facility (Facility_ID);
ALTER TABLE public.Customer ADD CONSTRAINT Customer_Facility_fk FOREIGN KEY (Facility_ID) REFERENCES public.Facility (Facility_ID);
ALTER TABLE public.Membership ADD CONSTRAINT Membership_Customer_fk FOREIGN KEY (Customer_ID) REFERENCES public.Customer(Customer_ID);
ALTER TABLE public.Classes ADD CONSTRAINT Classes_Instructor_fk FOREIGN KEY (Instructor_ID) REFERENCES public.Instructor (Instructor_ID);
ALTER TABLE public.Classes ADD CONSTRAINT Classes_Customer_fk FOREIGN KEY (Customer_ID) REFERENCES public.Customer(Customer_ID);
ALTER TABLE public.Equipment ADD CONSTRAINT Equipment_Customer_fk FOREIGN KEY (Customer_ID) REFERENCES public.Customer(Customer_ID);

--ADD UNIQUE CONSTRAINTS TO CREATED TABLES
ALTER TABLE public.Land_Parcel ADD CONSTRAINT Land_Parcel_unique UNIQUE (location);
ALTER TABLE public.Facility ADD CONSTRAINT Facility_unique UNIQUE (Facility_Postcode);
ALTER TABLE public.Manager ADD CONSTRAINT Manager_unique UNIQUE (Manager_Forename, Manager_Surname, Manager_Phone_Number);
ALTER TABLE public.Instructor ADD CONSTRAINT Instructor_unique UNIQUE (Instructor_Forename, Instructor_Surname, Instructor_Phone_Number);
ALTER TABLE public.Customer ADD CONSTRAINT Customer_unique UNIQUE (Customer_Forename, Customer_Surname, Customer_Phone_Number);
ALTER TABLE public.Membership ADD CONSTRAINT Membership_unique UNIQUE (Activation_Date, Activation_Time);
ALTER TABLE public.Classes ADD CONSTRAINT Class_Instructor_unqiue UNIQUE (Class_Date, Instructor_ID, Customer_ID);

--ADD CHECK CONSTRAINTS TO RELEVANT CREATED TABLES
--Regular expression sources: Stack Overflow User (2016), Stack Overflow User (2011), Wright (2008). Full reference available in accompanying document.
ALTER TABLE public.Facility ADD CONSTRAINT Facility_floor_check CHECK (Number_of_Floors > 0);
ALTER TABLE public.Facility ADD CONSTRAINT Facility_phone_check CHECK (Facility_Phone_Number ~* '^(((\+44\s?\d{4}|\(?0\d{4}\)?)\s?\d{3}\s?\d{3})|((\+44\s?\d{3}|\(?0\d{3}\)?)\s?\d{3}\s?\d{4})|((\+44\s?\d{2}|\(?0\d{2}\)?)\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$');
ALTER TABLE public.Facility ADD CONSTRAINT Facility_postcode_check CHECK (Facility_Postcode ~* '^ ?(([BEGLMNSWbeglmnsw][0-9][0-9]?)|(([A-PR-UWYZa-pr-uwyz][A-HK-Ya-hk-y][0-9][0-9]?)|(([ENWenw][0-9][A-HJKSTUWa-hjkstuw])|([ENWenw][A-HK-Ya-hk-y][0-9][ABEHMNPRVWXYabehmnprvwxy])))) ?[0-9][ABD-HJLNP-UW-Zabd-hjlnp-uw-z]{2}$');
ALTER TABLE public.Manager ADD CONSTRAINT Manager_email_check CHECK (Manager_Email_Address ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$');
ALTER TABLE public.Manager ADD CONSTRAINT Manager_phone_check CHECK (Manager_Phone_Number ~* '^(((\+44\s?\d{4}|\(?0\d{4}\)?)\s?\d{3}\s?\d{3})|((\+44\s?\d{3}|\(?0\d{3}\)?)\s?\d{3}\s?\d{4})|((\+44\s?\d{2}|\(?0\d{2}\)?)\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$');
ALTER TABLE public.Manager ADD CONSTRAINT Manager_postcode_check CHECK (Manager_Postcode ~* '^ ?(([BEGLMNSWbeglmnsw][0-9][0-9]?)|(([A-PR-UWYZa-pr-uwyz][A-HK-Ya-hk-y][0-9][0-9]?)|(([ENWenw][0-9][A-HJKSTUWa-hjkstuw])|([ENWenw][A-HK-Ya-hk-y][0-9][ABEHMNPRVWXYabehmnprvwxy])))) ?[0-9][ABD-HJLNP-UW-Zabd-hjlnp-uw-z]{2}$');
ALTER TABLE public.Instructor ADD CONSTRAINT Instructor_email_check CHECK (Instructor_email_Address ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$');
ALTER TABLE public.Instructor ADD CONSTRAINT Instructor_postcode_check CHECK (Instructor_Postcode ~* '^ ?(([BEGLMNSWbeglmnsw][0-9][0-9]?)|(([A-PR-UWYZa-pr-uwyz][A-HK-Ya-hk-y][0-9][0-9]?)|(([ENWenw][0-9][A-HJKSTUWa-hjkstuw])|([ENWenw][A-HK-Ya-hk-y][0-9][ABEHMNPRVWXYabehmnprvwxy])))) ?[0-9][ABD-HJLNP-UW-Zabd-hjlnp-uw-z]{2}$');
ALTER TABLE public.Instructor ADD CONSTRAINT Instructor_phone_check CHECK (Instructor_Phone_Number ~* '^(((\+44\s?\d{4}|\(?0\d{4}\)?)\s?\d{3}\s?\d{3})|((\+44\s?\d{3}|\(?0\d{3}\)?)\s?\d{3}\s?\d{4})|((\+44\s?\d{2}|\(?0\d{2}\)?)\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$');
ALTER TABLE public.Customer ADD CONSTRAINT Customer_phone_check CHECK (Customer_Phone_Number ~* '^(((\+44\s?\d{4}|\(?0\d{4}\)?)\s?\d{3}\s?\d{3})|((\+44\s?\d{3}|\(?0\d{3}\)?)\s?\d{3}\s?\d{4})|((\+44\s?\d{2}|\(?0\d{2}\)?)\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$');
ALTER TABLE public.Customer ADD CONSTRAINT Customer_gender_check CHECK (Gender = 'M' OR Gender = 'F');
ALTER TABLE public.Customer ADD CONSTRAINT Customer_email_check CHECK (Customer_Email_Address ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$');
ALTER TABLE public.Membership ADD CONSTRAINT Membership_check CHECK (Membership_Type = 'Premium' OR Membership_Type = 'Child' OR Membership_Type = 'Elderly');
ALTER TABLE public.Membership ADD CONSTRAINT Membership_join_cancel_check CHECK (Date_Joined <= Date_Cancelled);
ALTER TABLE public.Membership ADD CONSTRAINT Membership_active_check CHECK (Active = 'Y' OR Active = 'N');

--CREATE SPATIAL INDEXES
CREATE INDEX Land_parcel_gidx ON public.land_parcel USING GIST(location);
CREATE INDEX Facility_gidx ON public.Facility USING GIST(location);

--CREATE NON-SPATIAL INDEXES
CREATE INDEX Facility_idx on public.Facility(Facility_ID);
CREATE INDEX Customer_idx on public.Customer(Customer_ID);
CREATE INDEX Instructor_idx on public.Instructor(Instructor_ID);

--INSERT DATA INTO LAND PARCEL TABLE
INSERT INTO public.Land_Parcel(Parcel_Number, Location)
VALUES
(001, st_geomfromtext('POLYGON((525675 184877,525694 184877,525694 184854,525675 184854,525675 184877))',27700)),
(002, st_geomfromtext('POLYGON((525681 185224,525716 185243,525729 185219,525694 185200,525681 185224))',27700)),
(003, st_geomfromtext('POLYGON((524764 185315,524892 185357,524907 185311,524779 185269,524764	185315))',27700));

--INSERT DATA INTO FACILITY TABLE
INSERT INTO public.Facility(Facility_Address_Line1, Facility_Address_Line2,  Facility_Address_Line3, Facility_Postcode, Facility_Phone_Number, Number_of_Floors, Location, Parcel_Number)
VALUES
('LDN GYM LTD', '1 Crown CL', 'London', 'NW6 1XZ', '020 7946 0119', 2, st_geomfromtext('POLYHEDRALSURFACE(
((525676 184875 0,525693 184875 0,525693 184862 0,525676 184862 0,525676 184875 0)),
((525676 184875 0,525676 184875 10,525693 184875 10,525693 184875 0,525676 184875 0)),
((525676 184862 0,525676 184862 10,525693 184862 10,525693 184862 0,525676 184862 0)),
((525693 184862 0,525693 184862 10,525693 184875 10,525693 184875 0,525693 184862 0)),
((525676 184862 0,525676 184862 10,525676 184875 10,525676 184875 0,525676 184862 0)),
((525676 184875 10,525693 184875 10,525693 184862 10,525676 184862 10,525676 184875 10)))',27700), 001),
('LDN GYM LTD', '25 Alvanley Gardens', 'London', 'NW6 1JD', '020 7946 0403', 2, st_geomfromtext('POLYHEDRALSURFACE(
((525691 185227 0,525708 185237 0,525717 185221 0,525699 185212 0,525691 185227 0)),
((525691 185227 0,525691 185227 10,525708 185237 10,525708 185237 0,525691 185227 0)),
((525699 185212 0,525699 185212 10,525717 185221 10,525717 185221 0,525699 185212 0)),
((525717 185221 0,525717 185221 10,525708 185237 10,525708 185237 0,525717 185221 0)),
((525699 185212  0,525699 185212  10,525691 185227 10,525691 185227 0,525699 185212  0)),
((525691 185227 10,525708 185237 10,525717 185221 10,525699 185212 10,525691 185227 10)))',27700), 002),
('LDN GYM LTD', 'Gondar Gardens', 'London', 'NW6 1HA', '020 7946 0133', 2, st_geomfromtext('POLYHEDRALSURFACE(
((524791 185320 0,524874 185347 0,524885 185310 0,524803 185284 0,524791 185320 0)),
((524791 185320 0,524791 185320 10,524874 185347 10,524874 185347 0,524791 185320 0)),
((524803 185284 0,524803 185284 10,524885 185310 10,524885 185310 0,524803 185284 0)),
((524885 185310  0,524885 185310 10,524874 185347 10,524874	185347 0,524885 185310 0)),
((524803 185284 0,524803 185284 10,524791 185320 10,524791 185320 0,524803 185284 0)),
((524791 185320 10,524874 185347 10,524885 185310 10,524803 185284 10,524791 185320 10)))',27700), 003);

--INSERT DATA INTO MANAGER TABLE
INSERT INTO public.Manager (Manager_Forename, Manager_Surname, Manager_Phone_Number, Manager_DOB, Manager_Address_Line1, Manager_Address_Line2, Manager_Address_Line3, Manager_Postcode, Manager_Email_Address, Facility_ID)
VALUES
('Jack', 'Gallivan', '07700 900260', '02/05/1990',  '62 Camden High St', null, 'London', 'NW1 0LT', 'jack.gallivan@gmail.com', 1),
('Alexandros', 'Petrakis', '07700 900155', '13/03/1987', '174 Royal College Street', null, 'London', 'NW1 0SP', 'alex.petrakis@gmail.com', 2),
('Jack', 'Jones', '07700 900497', '12/12/1995', 'Flat 3 Princess Park Manor', 'Royal Drive', 'London', 'N11 3FL', 'jack.jones@gmail.com', 3);

--INSERT DATA INTO INSTRUCTOR TABLE
INSERT INTO public.Instructor (Instructor_Forename, Instructor_Surname, Instructor_Phone_Number, Instructor_DOB, Instructor_Address_Line1, Instructor_Address_Line2, Instructor_Address_Line3, Instructor_Postcode, Instructor_Email_Address, Facility_ID)
VALUES
('Dylan', 'Kennedy', '07700 900346', '03/05/1981', '79B Walm Lane', null,  'London', 'NW2 4QL', 'dylan.kennedy@gmail.com', 1),
('Kristina', 'Williams', '07700 900657', '20/05/1982', '130 Eversholt Street', 'Kings Cross', 'London', 'NW1 1DL', 'kristina.williams@gmail.com', 1),
('Brian', 'Roper', '07700 900176', '15/03/1992', '26C Blenheim Gardens', null, 'London', 'NW2 4NS', 'brian.roper@gmail.com', 1),
('Sam',  'Leck', '07700 900606', '17/05/1992', '38 Burtonhole Lane', null, 'London', 'NW7 1AL', 'sam.leck@gmail.com', 1),
('Gary', 'Wellington', '07700 900616', '24/05/1995', '132 Eversholt Street', 'Kings Cross',  'London', 'NW1 1DL', 'gary.wellington@gmail.com', 2),
('Stefan', 'Jones', '07700 900469', '16/08/1985', '8 Bramtpon Grove', null, 'London', 'NW4 4AG', 'stfean.jones@gmail.com', 2),
('Sergei', 'Foss', '07700 900607',  '20/02/1987', '145A Queens Crescent', 'Belize Park', 'London', 'NW5 4ED', 'sergei.foss@gmail.com', 2),
('Ellis', 'Knox', '07700 900965', '29/03/1990', '129 Paragon Court', 'Holders Hill Road', 'London', 'NW4 1LH', 'ellis.knox@gmail.com', 3),
('Louie', 'Donnovan', '07700 900523', '18/08/1993', '8 8hase Road', null, 'London',  'NW10 6QD', 'louie.donnovan@gmail.com', 3);

--INSERT DATA INTO CUSTOMER TABLE
INSERT INTO public.Customer (Customer_Forename, Customer_Surname, Customer_Phone_Number, Customer_DOB, Gender, Customer_Email_Address, Facility_ID)
VALUES
('Miranda', 'Hume', '07700 900448', '02/03/1952', 'F',  'mirander.hume@gmail.com', 1),
('Paige' , 'Mckee', '07700 900016',  '22/09/1980', 'F', 'paige.mckee@gmail.com', 1),
('Troy',  'Bassett', '07700 900740', '24/02/2001', 'M', 'troy.bassett@gmail.com', 2),
('Sally', 'Lara', '07700 900077', '19/05/1987', 'F', 'sally.lara@gmail.com', 1),
('Brogan', 'Kumar', '07700 900443', '10/05/1992', 'M', 'brogan.kumar@gmail.com', 3),
('Cindy', 'Ellison', '07700 900910', '14/02/1994', 'F', 'cindy.ellison@gmail.com', 2),
('Neil', 'Sawyer', '07700 900177', '08/10/1948', 'M', 'neil.sawyer@gmail.com', 2),
('Viki', 'Maag',  '07700 900257', '26/12/1982', 'F', 'viki.maag@gmail.com', 1),
('Cindie', 'Kaye', '07700 900271', '09/09/1987', 'F',  'cindie.kaye@gmail.com', 3),
('Jake', 'Marsden', '07700 900904', '07/09/1992', 'M', 'jake.marsden@gmail.com', 1),
('Gill', 'Dickerson', '07700 900167', '21/09/1952', 'F', 'gill.dickerson@gmail.com', 3),  
('Jordana', 'Vallee', '07700 900635', '05/03/1980', 'F', 'jordana.vallee@gmail.com', 1),
('Tom', 'Brown', '07700 900130', '30/03/1980', 'M', 'tom.brown@gmail.com', 2),
('Kirsty', 'Landes', '07700 900451', '13/04/1986', 'F', 'kirsty.landes@gmail.com', 1),
('Holly', 'Bading', '07700 900426', '30/06/2001', 'F', 'holly.bading@gmail.com', 3),
('Lewis', 'Davies', '07700 900224', '17/04/1993', 'M', 'lewis.davies@gmail.com', 2),
('Adam', 'Vaughan', '07700 900310',  '05/03/2002', 'M', 'adam.vaughan@gmail.com', 2),
('Tom', 'Kenvyn', '07700 900521', '24/04/1982', 'M', 'tom.kenvyn@gmail.com', 3),  
('Corey', 'Newman', '07700 900687', '26/04/2001', 'M', 'corey.newman@gmail.com', 2),
('Jack', 'Plumley', '07700 900125', '14/04/2000', 'M', 'jack.plumley@gmail.com', 2);

--INSERT DATA INTO MEMBERSHIP TABLE
INSERT INTO public.Membership(Date_Joined, Activation_Date, Activation_Time, Date_Cancelled, Membership_Type, Active, Customer_ID)
VALUES
('14/12/2017', '14/01/2018', '13:15:58', null, 'Elderly', 'Y', 1),
('25/01/2018', '25/01/2018', '13:21:57', null,'Premium', 'Y', 2),
('26/01/2018', '26/02/2018', '10:44:26', null,'Child', 'Y', 3),
('27/12/2017', '27/02/2018', '14:05:39', null, 'Premium', 'Y', 4),
('22/01/2018', '22/03/2018', '11:37:42', null,'Premium', 'Y', 5),
('08/01/2018', '08/01/2018', '07:38:42', '07/02/2018','Premium', 'N', 6),
('13/12/2017', '13/01/2018', '09:22:42', '13/02/2018','Elderly', 'N', 7),
('20/01/2018', '20/01/2018', '15:14:10', '15/02/2018','Premium', 'N', 8),
('24/12/2017', '24/01/2018', '13:56:02', null,'Premium', 'Y', 9),
('08/01/2018', '08/02/2018', '14:44:06', '08/03/2018','Premium', 'N', 10),
('19/12/2017', '19/01/2018', '10:23:29', null,'Elderly', 'Y', 11),
('31/12/2017', '31/01/2018', '14:14:35', null,'Premium', 'Y', 12),
('06/03/2017', '06/03/2018', '16:25:00', null,'Premium', 'Y', 13),
('02/01/2018', '12/03/2018', '09:08:17', null,'Premium', 'Y', 14),
('14/01/2018', '14/03/2018', '14:32:57', null,'Child', 'Y', 15),
('05/01/2018', '05/01/2018', '11:08:46', null,'Premium', 'Y', 16),
('10/01/2018', '15/02/2018', '16:03:36', '12/03/2018','Child', 'N', 17),
('02/01/2018', '18/02/2018', '13:16:07', null, 'Premium', 'Y', 18),
('24/01/2018', '24/02/2018', '11:35:08', null, 'Child', 'Y', 19),
('03/01/2018', '28/03/2018', '10:58:02', null,'Child', 'Y', 20);

--INSERT DATA INTO CLASSES TABLE
INSERT INTO public.Classes (Class_Date, Class_Time, Class_Type,  Instructor_ID, Customer_ID)
VALUES
('11/01/2018', '16:00:00', 'Power Lifting', 1, 1),
('30/01/2018', '10:30:00', 'HIIT Cardio', 7, 3),
('03/03/2018', '17:45:00', 'Olympic Lifting', 2, 4),
('06/03/2018', '09:00:00', 'HIIT Cardio', 9, 5),
('29/03/2018', '06:30:00', 'Hypertrophy', 1, 8), 
('11/01/2018', '11:30:00', 'Hypertrophy', 4, 10),
('02/02/2018', '17:30:00', 'Power Lifting', 8, 11),
('04/03/2018', '15:30:00', 'Hypertrophy', 5, 13),
('05/03/2018', '10:30:00', 'Power Lifting', 3, 12),
('10/03/2018', '12:15:00', 'HIIT Cardio', 8, 15),
('09/01/2018', '08:30:00', 'Olympic Lifting', 5, 19),
('25/01/2018', '16:00:00', 'Hypertrophy', 5, 17),
('01/03/2018', '14:30:00', 'HIIT Cardio', 6, 3),
('07/03/2018', '14:00:00', 'Olympic Lifting', 6, 3),
('28/03/2018', '15:45:00', 'HIIT Cardio', 4, 2);

--INSERT DATA INTO EQUIPMENT TABLE
INSERT INTO public.Equipment (Equipment_SN, Equipment_Category, Equipment_Name, Customer_ID)
VALUES
(4806, 'Safety', 'Weight Lifting Belt', 1),
(9838, 'Mobility', 'Lacrosse Ball', 4),
(7393, 'Comfort', 'Yoga Matt', 15),
(3837, 'Comfort', 'Barbell Pad', 19);


--FUNCTIONAL REQUIREMENTS

--FUNCTIONAL REQUIREMENT 1 - What is the total area of land owned by the business?
SELECT SUM(ST_Area(Location))/1000 as "Total Land Area(km^2)"
FROM public.Land_Parcel;

--FUNCTIONAL REQUIREMENT 2 - Which two gyms are the furthest distance away from each other?
SELECT DISTINCT a.Facility_ID, b.Facility_ID, St_3DDistance(a.location,b.location)/1000 as "Maximum Distance (km)"
FROM public.Facility a, public.Facility b
GROUP BY a.Facility_ID, b.Facility_ID
ORDER BY "Maximum Distance (km)" DESC
LIMIT 1;

--FUNCTIONAL REQUIREMENT 3 - How many gyms fall within an area of interest?
--Land Parcel entity used rather than Facility. 
SELECT Parcel_Number as "Parcel Number", (ST_Within(ST_CENTROID(Location), 
ST_GEOMFROMTEXT('Polygon((524651 184648,524926 184771,525058 184775,525067 184869,525034 184881,524958 185167,
525084 185214,525370 185249,525416 185225,525673 185339,525857 185274,526170 184976,526328 184681,526105 184735,
525689 184665,525685 184622,525636 184616,525630 184359,525653 184337,525628 184303,525475 184301,525456 184364,
525425 184363,525438 184406,525389 184398,525387 184363,525161 184376,525166 184407,525114 184446,525137 184545,
525066 184548,525058 184589,524780 184463,524651 184648))', 27700))) 
AS "Gyms in West Hampstead" FROM public.Land_Parcel;

--FUNCTIONAL REQUIREMENT 4 - What is the proximity of each gym to a proposed gym location defined by GPS coordinates?
SELECT Facility_ID, (ST_DISTANCE(Location, ST_GEOMFROMTEXT('POINT(526477 186025)', 27700))/1000)  as "Distance(km) to proposed gym location" FROM public.Facility;

--Functional Requirement 5 - What is the perimeter of a given land parcel owned by the business?
SELECT ROUND(CAST(SUM(ST_Perimeter(Location)) as numeric),2) as "Total Perimeter(m)"
FROM public.Land_Parcel WHERE Parcel_Number = 003;

--FUNCTIONAL REQUIREMENT 6 - Which member participates in the most classes during a given date range?
-- 01/03/2018 - 10/03/2018 used for this example.
SELECT t1.Customer_ID, COUNT(*) AS "Number of classes taken"
FROM public.Classes t1 INNER JOIN public.Membership t2 ON t1.Customer_ID = t2.Customer_ID
WHERE class_date >= '01/03/2018' AND class_date <= '10/03/2018' AND Active = 'Y'
GROUP BY t1.Customer_id
ORDER BY COUNT(*) DESC 
LIMIT 1;

--FUNCTIONAL REQUIREMENT 7 - Which gym facility employs the most instructors?
--Possible with and without a join - both shown below
--Using a join
SELECT t1.Facility_ID AS Facility, COUNT(t2.Instructor_ID) AS "Number of instructors"
FROM public.Facility t1 INNER JOIN Instructor t2 ON t1.Facility_ID = t2.Facility_ID
GROUP BY t1.facility_Id
ORDER BY "Number of instructors" DESC
LIMIT 1;
--Not using a join
SELECT Facility_ID as Facility, COUNT(*) as "Number of instructors" FROM public.Instructor 
GROUP BY Facility_ID
ORDER BY COUNT(*) DESC
LIMIT 1;

--FUNCTIONAL REQUIREMENT 8 - Which gym facility has the most child memberships?
--Facility table not required.
SELECT t1.Facility_ID as "Facility", t2.Membership_Type as "Membership Type"
FROM public.Customer t1 INNER JOIN Membership t2 ON t1.Customer_ID = t2.Customer_ID
WHERE t2.Membership_Type = 'Child' AND Active = 'Y'
GROUP BY t1.Facility_ID, t1.Customer_ID, t2.Membership_Type
ORDER BY t1.Facility_ID ASC;

--FUNCTIONAL REQUIREMENT 9 - What is the total number of gym members across the whole business?
--cross out member entity in FR table and edit it to membership
SELECT COUNT(*) as "Total Number of Members" 
FROM public.Membership
WHERE Active = 'Y';

--FUNCTIONAL REQUIREMENT 10 - What percentage of active memberships are classified as premium memberships?
SELECT ((SELECT COUNT(*)::FLOAT FROM public.Membership 
WHERE Membership_type = 'Premium') /
(SELECT COUNT(*)::FLOAT FROM public.Membership AS NUMERIC WHERE Active = 'Y') * 100.0)
 AS "Percentage of active memberships";