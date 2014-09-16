package com.cn.assistantmember.parser;

import org.json.JSONException;
import org.json.JSONObject;

import com.cn.assistantmember.entity.HabitBean;

public class HabitParser {
 public static HabitBean parserHabit(String mResult) throws JSONException{
	 HabitBean bean=new HabitBean();
	 JSONObject json=new JSONObject(mResult);
	 if(json.has("created_at"))
		 bean.setCreated_at(json.getString("created_at"));
	 
	 if(json.has("disease_history"))
		 bean.setDisease_history(json.getString("disease_history"));
	 
	 if(json.has("drinking"))
		 bean.setDrinking(json.getString("drinking"));
	 
	 if(json.has("drinking_times"))
		 bean.setDrinking_times(json.getString("drinking_times"));
	 
	 if(json.has("drug"))
		 bean.setDrug(json.getString("drug"));
	 
	 if(json.has("drug_name"))
		 bean.setDrug_name(json.getString("drug_name"));
	 
	 if(json.has("drug_reason"))
		 bean.setDrug_reason(json.getString("drug_reason"));
	 
	 if(json.has("id"))
		 bean.setId(json.getString("id"));
	 
	 if(json.has("member_id"))
		 bean.setMember_id(json.getString("member_id"));
	 
	 if(json.has("self_assessment"))
		 bean.setSelf_assessment(json.getString("self_assessment"));
	 
	 if(json.has("sleep_amount"))
		 bean.setSleep_amount(json.getString("sleep_amount"));
	 
	 if(json.has("sleep_quality"))
		 bean.setSleep_quality(json.getString("sleep_quality"));
	 
	 if(json.has("sleep_time"))
		 bean.setSleep_time(json.getString("sleep_time"));
	 
	 if(json.has("smoking"))
		 bean.setSmoking(json.getString("smoking"));
	 
	 if(json.has("smoking_times"))
		 bean.setSmoking_times(json.getString("smoking_times"));
	 
	 if(json.has("update_at"))
		 bean.setUpdate_at(json.getString("update_at"));	 
	 return bean;
 }
}
