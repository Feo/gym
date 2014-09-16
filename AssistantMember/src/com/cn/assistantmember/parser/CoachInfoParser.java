package com.cn.assistantmember.parser;

import org.json.JSONException;
import org.json.JSONObject;

import com.cn.assistantmember.entity.CoachInfoBean;

public class CoachInfoParser {

	public CoachInfoParser() {
		// TODO Auto-generated constructor stub
	}
public CoachInfoBean parserCoachInfo(String mResult) throws JSONException{
	CoachInfoBean bean=new CoachInfoBean();
	JSONObject json=new JSONObject(mResult);
	if(json.has("activated"))
		bean.setActivated(json.getString("activated"));
	
	if(json.has("age"))
		bean.setAge(json.getString("age"));
	
	if(json.has("city"))
		bean.setCity(json.getString("city"));
	
	if(json.has("created_at"))
		bean.setCreated_at(json.getString("created_at"));
	
	if(json.has("district"))
		bean.setDistrict(json.getString("district"));
	
	if(json.has("email"))
		bean.setEmail(json.getString("email"));
	
	if(json.has("experience"))
		bean.setExperience(json.getString("experience"));
	
	if(json.has("gender"))
		bean.setGender(json.getString("gender"));
	
	if(json.has("grade"))
		bean.setGrade(json.getString("grade"));
	
	if(json.has("id"))
		bean.setId(json.getString("id"));
	
	if(json.has("name"))
		bean.setName(json.getString("name"));
	
	if(json.has("nickname"))
		bean.setNickname(json.getString("nickname"));
	
	if(json.has("notification"))
		bean.setNotification(json.getString("notification"));
	
	if(json.has("activated"))
		bean.setActivated(json.getString("activated"));
	
	if(json.has("one_to_many_teaching"))
		bean.setOne_to_many_teahing(json.getString("one_to_many_teaching"));
	
	if(json.has("one_to_one_teaching"))
		bean.setOne_to_one_teaching(json.getString("one_to_one_teaching"));
	
	if(json.has("open_question"))
		bean.setOpen_question(json.getString("open_question"));
	
	if(json.has("organization"))
		bean.setOrganization(json.getString("organization"));
	
	if(json.has("phone"))
		bean.setPhone(json.getString("phone"));
	
	if(json.has("profession"))
		bean.setProfession(json.getString("profession"));
	
	if(json.has("province"))
		bean.setProvince(json.getString("province"));
	
	if(json.has("qq"))
		bean.setQq(json.getString("qq"));
	
	if(json.has("remember_token"))
		bean.setRemember_token(json.getString("remember_token"));
	
	if(json.has("street"))
		bean.setStreet(json.getString("street"));
	
	if(json.has("updated_at"))
		bean.setUpdate_at(json.getString("updated_at"));
	
	if(json.has("weixin"))
		bean.setWeixin(json.getString("weixin"));
	
	return bean;
}
}
