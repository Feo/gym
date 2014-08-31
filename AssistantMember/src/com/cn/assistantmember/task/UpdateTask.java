package com.cn.assistantmember.task;

import java.util.List;

import net.tsz.afinal.FinalHttp;
import net.tsz.afinal.http.AjaxCallBack;
import net.tsz.afinal.http.AjaxParams;
import android.util.Log;

import com.cn.assistantmember.util.UrlAddress.Login;
import com.cn.assistantmember.util.UrlAddress.Update;

public class UpdateTask {
private final String TAG="UpdateTask";
private String nickname;
private String name;
private String province;
private String city;
private String district;
private String street;
private String phone;
private String qq;
private String weixin;
private String  sports;
private String profession;
private String age;
private String gender;
	public UpdateTask(String nickname, String name, String province, String city,
		String district, String street, String phone, String qq, String weixin,
		String sports, String profession, String age, String gender) {
	super();
	this.nickname = nickname;
	this.name = name;
	this.province = province;
	this.city = city;
	this.district = district;
	this.street = street;
	this.phone = phone;
	this.qq = qq;
	this.weixin = weixin;
	this.sports = sports;
	this.profession = profession;
	this.age = age;
	this.gender = gender;
}
	public void doUpdateTask(){	
		FinalHttp fh = new FinalHttp();	  
		fh.post(Login.LOGIN_URL,getParameter(), new AjaxCallBack<Object>(){
			@Override
			public void onFailure(Throwable t, int errorNo, String strMsg) {		
				super.onFailure(t, errorNo, strMsg);
			}
			@Override
			public void onStart() {		
				super.onStart();
			}
			@Override
			public void onSuccess(Object t) {
				Log.i(TAG, (String)t.toString());
				super.onSuccess(t);
			}
		});
		}
		public AjaxParams getParameter(){
			 AjaxParams params = new AjaxParams(); 
			  params.put(Update.NICK_NAME,nickname); 
			    params.put(Update.NAME, name);
			    params.put(Update.PROVINCE, province);
			    params.put(Update.CITY, city);
			    params.put(Update.STREET, street);
			    params.put(Update.PHONE, phone);
			    params.put(Update.QQ, qq);
			    params.put(Update.WEIXIN, weixin);
			    params.put(Update.DISTRICT, district);
			    params.put(Update.SPORTS, sports);
			    params.put(Update.PROFESSION, profession);
			    params.put(Update.AGE, age);
			    params.put(Update.GENDER, gender);
			    
			 return params;
		}
}
