package com.cn.assistantmember.entity;

public class LoginBean extends BaseEntity{

/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
private String age;
private String city;
private String coach_id;
private String create_at;
private String district;
private String email;
private String gender;
private String grade;//教练评分
private String grade_time;//评分时间
private String hava_coach;
private String id;
private String name;
private String nickname;
private String phone;
private String profession;
private String qq;
private String remember_token;
private String street;
private String province;
private String sports;
private String update_at;//数据更新时间
private String weixin;
private String status;
private String error;
public String getSports() {
	return sports;
}
public void setSports(String sports) {
	this.sports = sports;
}
public String getProvince() {
	return province;
}
public void setProvince(String province) {
	this.province = province;
}


public String getStatus() {
	return status;
}
public void setStatus(String status) {
	this.status = status;
}
public String getError() {
	return error;
}
public void setError(String error) {
	this.error = error;
}
public String getAge() {
	return age;
}
public void setAge(String age) {
	this.age = age;
}
public String getCity() {
	return city;
}
public void setCity(String city) {
	this.city = city;
}
public String getCoach_id() {
	return coach_id;
}
public void setCoach_id(String coach_id) {
	this.coach_id = coach_id;
}
public String getCreate_at() {
	return create_at;
}
public void setCreate_at(String create_at) {
	this.create_at = create_at;
}
public String getDistrict() {
	return district;
}
public void setDistrict(String district) {
	this.district = district;
}
public String getEmail() {
	return email;
}
public void setEmail(String email) {
	this.email = email;
}
public String getGender() {
	return gender;
}
public void setGender(String gender) {
	this.gender = gender;
}
public String getGrade() {
	return grade;
}
public void setGrade(String grade) {
	this.grade = grade;
}
public String getGrade_time() {
	return grade_time;
}
public void setGrade_time(String grade_time) {
	this.grade_time = grade_time;
}
public String getHava_coach() {
	return hava_coach;
}
public void setHava_coach(String hava_coach) {
	this.hava_coach = hava_coach;
}
public String getId() {
	return id;
}
public void setId(String id) {
	this.id = id;
}
public String getName() {
	return name;
}
public void setName(String name) {
	this.name = name;
}
public String getNickname() {
	return nickname;
}
public void setNickname(String nickname) {
	this.nickname = nickname;
}
public String getPhone() {
	return phone;
}
public void setPhone(String phone) {
	this.phone = phone;
}
public String getProfession() {
	return profession;
}
public void setProfession(String profession) {
	this.profession = profession;
}
public String getQq() {
	return qq;
}
public void setQq(String qq) {
	this.qq = qq;
}
public String getRemember_token() {
	return remember_token;
}
public void setRemember_token(String remember_token) {
	this.remember_token = remember_token;
}
public String getStreet() {
	return street;
}
public void setStreet(String street) {
	this.street = street;
}
public String getUpdate_at() {
	return update_at;
}
public void setUpdate_at(String update_at) {
	this.update_at = update_at;
}
public String getWeixin() {
	return weixin;
}
public void setWeixin(String weixin) {
	this.weixin = weixin;
}
@Override
public String toString() {
	return "LoginBean [age=" + age + ", city=" + city + ", coach_id="
			+ coach_id + ", create_at=" + create_at + ", district=" + district
			+ ", email=" + email + ", gender=" + gender + ", grade=" + grade
			+ ", grade_time=" + grade_time + ", hava_coach=" + hava_coach
			+ ", id=" + id + ", name=" + name + ", nickname=" + nickname
			+ ", phone=" + phone + ", profession=" + profession + ", qq=" + qq
			+ ", remember_token=" + remember_token + ", street=" + street
			+ ", province=" + province + ", sports=" + sports + ", update_at="
			+ update_at + ", weixin=" + weixin + ", status=" + status
			+ ", error=" + error + "]";
}

}
