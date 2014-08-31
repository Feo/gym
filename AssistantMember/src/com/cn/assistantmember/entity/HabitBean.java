package com.cn.assistantmember.entity;

public class HabitBean extends BaseEntity{
/**
	 * 
	 */
private static final long serialVersionUID = 1L;
private String created_at;
private String disease_history;
private String drinking;
private String drinking_times;
private String drug;
private String drug_name;
private String drug_reason;
private String id;
private String member_id;
private String self_assessment;
private String sleep_amount;
private String sleep_quality;
private String sleep_time;
private String smoking;
private String smoking_times;
private String update_at;
private String status;
private String error;
public String getCreated_at() {
	return created_at;
}
public void setCreated_at(String created_at) {
	this.created_at = created_at;
}
public String getDisease_history() {
	return disease_history;
}
public void setDisease_history(String disease_history) {
	this.disease_history = disease_history;
}
public String getDrinking() {
	return drinking;
}
public void setDrinking(String drinking) {
	this.drinking = drinking;
}
public String getDrinking_times() {
	return drinking_times;
}
public void setDrinking_times(String drinking_times) {
	this.drinking_times = drinking_times;
}
public String getDrug() {
	return drug;
}
public void setDrug(String drug) {
	this.drug = drug;
}
public String getDrug_name() {
	return drug_name;
}
public void setDrug_name(String drug_name) {
	this.drug_name = drug_name;
}
public String getDrug_reason() {
	return drug_reason;
}
public void setDrug_reason(String drug_reason) {
	this.drug_reason = drug_reason;
}
public String getId() {
	return id;
}
public void setId(String id) {
	this.id = id;
}
public String getMember_id() {
	return member_id;
}
public void setMember_id(String member_id) {
	this.member_id = member_id;
}
public String getSelf_assessment() {
	return self_assessment;
}
public void setSelf_assessment(String self_assessment) {
	this.self_assessment = self_assessment;
}
public String getSleep_amount() {
	return sleep_amount;
}
public void setSleep_amount(String sleep_amount) {
	this.sleep_amount = sleep_amount;
}
public String getSleep_quality() {
	return sleep_quality;
}
public void setSleep_quality(String sleep_quality) {
	this.sleep_quality = sleep_quality;
}
public String getSleep_time() {
	return sleep_time;
}
public void setSleep_time(String sleep_time) {
	this.sleep_time = sleep_time;
}
public String getSmoking() {
	return smoking;
}
public void setSmoking(String smoking) {
	this.smoking = smoking;
}
public String getSmoking_times() {
	return smoking_times;
}
public void setSmoking_times(String smoking_times) {
	this.smoking_times = smoking_times;
}
public String getUpdate_at() {
	return update_at;
}
public void setUpdate_at(String update_at) {
	this.update_at = update_at;
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
@Override
public String toString() {
	return "HabitBean [created_at=" + created_at + ", disease_history="
			+ disease_history + ", drinking=" + drinking + ", drinking_times="
			+ drinking_times + ", drug=" + drug + ", drug_name=" + drug_name
			+ ", drug_reason=" + drug_reason + ", id=" + id + ", member_id="
			+ member_id + ", self_assessment=" + self_assessment
			+ ", sleep_amount=" + sleep_amount + ", sleep_quality="
			+ sleep_quality + ", sleep_time=" + sleep_time + ", smoking="
			+ smoking + ", smoking_times=" + smoking_times + ", update_at="
			+ update_at + ", status=" + status + ", error=" + error + "]";
}


}
