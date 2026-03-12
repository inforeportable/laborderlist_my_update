-- SET NAMES 'TIS620';
-- SET NAMES 'UTF8';
set @hospital_code = (SELECT opdconfig.hospitalcode FROM opdconfig) ;
set @hospital_name = (SELECT opdconfig.hospitalname FROM opdconfig) ;
SET @dm_name = 'โรคเบาหวาน' ;
SET @clinic_id = (select clinic FROM clinic where clinic.name = @dm_name );
SET @s_date = date('2020-10-01') ;
SET @e_date = date('2026-09-30') ;
SET @hba1c = 'hba1c' ;
SET @k = '0' ;
SET @now = date(now()) ;
SET @script = 'cloud [2026-03-12 09:07:22]' ;
-- แก้ DECIMAL(5,2)

SELECT 
cast(@k := @k+1 as char) as  '[0] No.',
cast(@now as char)  as '[1] วันที่คัดกรอง', 
@hospital_code as '[2] รหัสหน่วยบริการ',
@hospital_name as '[3] ชื่อหน่วยบริการ',
cast('-' as char) as '[4] คิว',
cast('-' as char) as '[5] HN',
cast(pp.cid as char) as '[6] เลขที่ประชาชน',
cast(pp.pname as char) as '[7] คำนำหน้า',
cast(pp.fname as char) as '[8] ชื่อ',
cast(pp.lname as char) as '[9] นามสกุล',
cast(pp.sex as char) as '[10] เพศ',
cast(pp.birth as char) as '[11] วันเกิด',
cast(pp.age_year as char) as '[12] อายุปี' ,
cast(pp.age_month as char) as '[13] อายุเดือน',
cast( 'ไทย' as char) as    '[14] กลุ่มประชากร',
cast( '0=ไทย' as char) as    '[15] สัญชาติ',
cast( '' as char) as    '[16] กลุ่มสิทธิ์',
cast( '' as char) as    '[17] รหัสสิทธิ์หลัก',
cast( '' as char) as    '[18] ชื่อสิทธิ์หลัก',
cast( '' as char) as    '[19] รหัสสิทธิ์ย่อย',
cast( '' as char) as    '[20] ชื่อสิทธิ์ย่อย',
cast( '' as char) as    '[21] รหัสหน่วยบริการประจำ',
cast( '' as char) as    '[22] ชื่อหน่วยบริการประจำ',
cast( '' as char) as    '[23] รหัสหน่วยบริการปฐมภูมิ',
cast( '' as char) as    '[24] ชื่อหน่วยบริการปฐมภูมิ',
cast(pp.g as char) as '[25] ที่อยู่',
cast(pp.m as char) as '[26] หมู๋',
cast(pp.p as char) as '[27] จังหวัด',
cast(pp.a as char) as '[28] อำเภอ',
cast(pp.t as char) as '[29] ตำบล',
cast(pp.tel  as char) as '[30] โทรศัพท์' ,
cast(''   as char) as '[31] ประเภทความเสี่ยง',
cast(pp.icd as char) as '[32] ICD10' ,
cast(pp.last_hba1c_value as char) as '[33] HBA1C',
cast( '' as char) as    '[34] โรคภูมิคุ้มกัน',
cast( '' as char) as    '[35] B24',
cast( '' as char) as    '[36] เรือนจำ',
cast( '' as char) as    '[37] วันที่แรกรับ',
cast( '' as char) as    '[38] วันที่พ้นโทษ',
cast( '' as char) as    '[39] เลขที่ประชาชนคนป่วย',
cast( 'No' as char) as    '[40] ประวัติป่วย',
cast( 'No' as char) as    '[41] ประวัติสัมผัส',
cast( 'No' as char) as    '[42] ไอมากกว่า 14 วัน',
cast( 'No' as char) as    '[43] ไอเป็นเลือด',
cast( 'No' as char) as    '[44] ไอน้อยกว่า 14 วัน',
cast( 'No' as char) as    '[45] น้ำหนักลด',
cast( 'No' as char) as    '[46] มีไข้ 7 วัน',
cast( 'No' as char) as    '[47] เหงือออกผิดปกติ',
cast( '' as char) as    '[48] กลุ่มซักประวัติ',
cast( '' as char) as    '[49] วันที่xray',
cast( '' as char) as    '[50] สรุป XRAY',
cast( '' as char) as    '[51] เฉพาะ  XRAY ผิดปกติ',
cast( '' as char) as    '[52] กลุ่มสรุปผล',
cast( 'No' as char) as    '[53] ยืนยันรับบริการ',
pp.localCheck_moo,
pp.localCheck_moo_name,
pp.localCheck_death,
concat(pp.localCheck_person_type,'-',@script) as localCheck_person_type
    
FROM
(
SELECT 
clinicmember.hn,
house.address as g,
village.village_moo as m,
MID(substring_index(thaiaddress.full_name,' ',-1),3,LENGTH(thaiaddress.full_name)) as p,
MID(substring_index(substring_index(thaiaddress.full_name,' ',2)  ,' ',-1),3,LENGTH(thaiaddress.full_name)) as a,
MID(substring_index(thaiaddress.full_name,' ',1),3,LENGTH(thaiaddress.full_name)) as t,
person.cid,
person.pname,
person.fname,
person.lname,
IF(person.sex=1,'ชาย','หญิง') as sex,
date_format(person.birthdate,'%Y-%m-%d') as birth,
TIMESTAMPDIFF(YEAR, person.birthdate,@now) as age_year,
TIMESTAMPDIFF(MONTH, person.birthdate,@now)%12 as age_month,
cast(village.village_moo as  char) as localCheck_moo,
cast(village.village_name as char) as localCheck_moo_name,
cast(person.death as char) as localCheck_death,
cast(house_regist_type.house_regist_type_name as char) as localCheck_person_type,
cast(clinicmember.last_hba1c_value as decimal(5,2)) as last_hba1c_value,
(SELECT max(ovstdiag.icd10) FROM ovstdiag WHERE LEFT(ovstdiag.icd10,3) BETWEEN 'E10' AND 'E14' AND ovstdiag.hn = clinicmember.hn) as icd,
concat_ws(',',person.mobile_phone ,person.hometel,person.home_phone) as tel
FROM clinicmember
LEFT OUTER JOIN person ON clinicmember.hn = person.patient_hn
LEFT OUTER JOIN village on person.village_id = village.village_id
LEFT OUTER JOIN house on person.house_id = house.house_id
LEFT OUTER JOIN thaiaddress on village.address_id = thaiaddress.addressid
LEFT OUTER JOIN house_regist_type on person.house_regist_type_id = house_regist_type.house_regist_type_id
WHERE clinicmember.clinic = @clinic_id
AND clinicmember.lastvisit BETWEEN @s_date AND @e_date
AND village.village_moo <> 0
AND person.nationality = 99
UNION ALL
SELECT 
clinicmember.hn,
person_address.addrpart,
person_address.moopart,
MID(substring_index(t2.full_name,' ',-1),3,LENGTH(t2.full_name)) as p,
MID(substring_index(substring_index(t2.full_name,' ',2)  ,' ',-1),3,LENGTH(t2.full_name)) as a,
MID(substring_index(t2.full_name,' ',1),3,LENGTH(t2.full_name)) as t,
person.cid,
person.pname,
person.fname,
person.lname,
IF(person.sex=1,'ชาย','หญิง') as sex,
date_format(person.birthdate,'%Y-%m-%d') as birth,
TIMESTAMPDIFF(YEAR, person.birthdate,@now) as age_year,
TIMESTAMPDIFF(MONTH, person.birthdate,@now)%12 as age_month,
cast(village.village_moo as  char) as localCheck_moo,
cast(village.village_name as char) as localCheck_moo_name,
cast(person.death as char) as localCheck_death,
cast(house_regist_type.house_regist_type_name as char) as localCheck_person_type,
cast(clinicmember.last_hba1c_value as decimal(5,2)) as last_hba1c_value,
(SELECT max(ovstdiag.icd10) FROM ovstdiag WHERE LEFT(ovstdiag.icd10,3) BETWEEN 'E10' AND 'E14' AND ovstdiag.hn = clinicmember.hn) as icd,
concat_ws(',',person.mobile_phone ,person.hometel,person.home_phone) as tel
FROM clinicmember
LEFT OUTER JOIN person ON clinicmember.hn = person.patient_hn
LEFT OUTER JOIN village on person.village_id = village.village_id
LEFT OUTER JOIN house on person.house_id = house.house_id
LEFT OUTER JOIN person_address ON  person.person_id  = person_address.person_id
LEFT OUTER JOIN thaiaddress t2 ON  t2.chwpart = person_address.chwpart
AND t2.amppart = person_address.amppart
AND t2.tmbpart = person_address.tmbpart
LEFT OUTER JOIN house_regist_type on person.house_regist_type_id = house_regist_type.house_regist_type_id
WHERE clinicmember.clinic = @clinic_id
AND clinicmember.lastvisit BETWEEN @s_date AND @e_date
AND village.village_moo = 0
AND person.nationality = 99
) AS pp
ORDER BY pp.fname ;
