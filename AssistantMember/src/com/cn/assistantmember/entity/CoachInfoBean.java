package com.cn.assistantmember.entity;

public class CoachInfoBean extends BaseEntity{
private static final long serialVersionUID = 1L;
private String activated;
private String age;
private String city;
private String created_at;
private String district;
private String email;
private String experience;
private String gender;
private String grade;
private String id;
private String name;
private String nickname;
private String one_to_many_teahing;
private String one_to_one_teaching;
private String open_question;
private String organization;
private String password_digest;
private String phone;
private String profession;
private String province;
private String qq;
private String remember_token;
private String street;
private String update_at;
private String weixin;
private String status;
private String error;
private String notification;
public String getNotification() {
	return notification;
}
public void setNotification(String notification) {
	this.notification = notification;
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
public String getActivated() {
	return activated;
}
public void setActivated(String activated) {
	this.activated = activated;
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
public String getCreated_at() {
	return created_at;
}
public void setCreated_at(String created_at) {
	this.created_at = created_at;
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
public String getExperience() {
	return experience;
}
public void setExperience(String experience) {
	this.experience = experience;
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
public String getOne_to_many_teahing() {
	return one_to_many_teahing;
}
public void setOne_to_many_teahing(String one_to_many_teahing) {
	this.one_to_many_teahing = one_to_many_teahing;
}
public String getOne_to_one_teaching() {
	return one_to_one_teaching;
}
public void setOne_to_one_teaching(String one_to_one_teaching) {
	this.one_to_one_teaching = one_to_one_teaching;
}
public String getOpen_question() {
	return open_question;
}
public void setOpen_question(String open_question) {
	this.open_question = open_question;
}
public String getOrganization() {
	return organization;
}
public void setOrganization(String organization) {
	this.organization = organization;
}
public String getPassword_digest() {
	return password_digest;
}
public void setPassword_digest(String password_digest) {
	this.password_digest = password_digest;
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
public String getProvince() {
	return province;
}
public void setProvince(String province) {
	this.province = province;
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
	return "CoachInfoBean [activated=" + activated + ", age=" + age + ", city="
			+ city + ", created_at=" + created_at + ", district=" + district
			+ ", email=" + email + ", experience=" + experience + ", gender="
			+ gender + ", grade=" + grade + ", id=" + id + ", name=" + name
			+ ", nickname=" + nickname + ", one_to_many_teahing="
			+ one_to_many_teahing + ", one_to_one_teaching="
			+ one_to_one_teaching + ", open_question=" + open_question
			+ ", organization=" + organization + ", password_digest="
			+ password_digest + ", phone=" + phone + ", profession="
			+ profession + ", province=" + province + ", qq=" + qq
			+ ", remember_token=" + remember_token + ", street=" + street
			+ ", update_at=" + update_at + ", weixin=" + weixin + ", status="
			+ status + ", error=" + error + "]";
}


}
