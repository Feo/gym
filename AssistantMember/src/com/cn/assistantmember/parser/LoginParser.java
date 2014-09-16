package com.cn.assistantmember.parser;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

import com.cn.assistantmember.entity.LoginBean;
public class LoginParser {
	private final static String TAG="LoginParser";
public static LoginBean parserLogin(String mResult) throws JSONException{
	LoginBean loginBean=null;
	try{
	JSONObject jsonObject=new JSONObject(mResult);
	 loginBean=new LoginBean();
		if(jsonObject.has("status")){
			loginBean.setStatus(jsonObject.getString("status"));
		}
		if(jsonObject.has("error")){
			loginBean.setError(jsonObject.getString("error"));
		}
		if(jsonObject.has("id")){
			loginBean.setId(jsonObject.getString("id"));
		}
		if(jsonObject.has("name")){
			loginBean.setName(jsonObject.getString("name"));
		}
		if(jsonObject.has("nickname")){
			loginBean.setNickname(jsonObject.getString("nickname"));
		}
		if(jsonObject.has("email")){
			loginBean.setEmail(jsonObject.getString("email"));
		}
		if(jsonObject.has("age")){
			loginBean.setAge(jsonObject.getString("age"));
		}
		if(jsonObject.has("hava_coach")){
			loginBean.setHava_coach(jsonObject.getString("hava_coach"));
		}
		if(jsonObject.has("coach_id")){
			loginBean.setCoach_id(jsonObject.getString("coach_id"));
		}
		if(jsonObject.has("weixin")){
			loginBean.setWeixin(jsonObject.getString("weixin"));
		}
		if(jsonObject.has("qq")){
			loginBean.setQq(jsonObject.getString("qq"));
		}
		if(jsonObject.has("city")){
			loginBean.setCity(jsonObject.getString("city"));
		}
		if(jsonObject.has("district")){
			loginBean.setDistrict(jsonObject.getString("district"));
		}
		if(jsonObject.has("province")){
			loginBean.setProvince(jsonObject.getString("province"));
		}
		if(jsonObject.has("profession")){
			loginBean.setProfession(jsonObject.getString("profession"));
		}
		if(jsonObject.has("remember_token")){
			loginBean.setRemember_token(jsonObject.getString("remember_token"));
		}
		if(jsonObject.has("street")){
			loginBean.setStreet(jsonObject.getString("street"));
		}
		if(jsonObject.has("sports")){
			loginBean.setSports(jsonObject.getString("sports"));
		}
		if(jsonObject.has("update_at")){
			loginBean.setUpdate_at(jsonObject.getString("update_at"));
		}
		if(jsonObject.has("gender")){
			loginBean.setGender(jsonObject.getString("gender"));
		}
		if(jsonObject.has("grade")){
			loginBean.setGrade(jsonObject.getString("grade"));
		}
		if(jsonObject.has("grade_time")){
			loginBean.setGrade_time(jsonObject.getString("grade_time"));
		}
		if(jsonObject.has("created_at")){
			loginBean.setCreate_at(jsonObject.getString("created_at"));
		}
	
	}
	catch(JSONException e){
		e.printStackTrace();
	}
	Log.i("TAG",loginBean.toString());
	return loginBean;
}
}
