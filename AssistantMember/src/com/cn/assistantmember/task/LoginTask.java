package com.cn.assistantmember.task;

import net.tsz.afinal.FinalHttp;
import net.tsz.afinal.http.AjaxCallBack;
import net.tsz.afinal.http.AjaxParams;

import org.json.JSONException;
import org.json.JSONObject;

import com.cn.assistantmember.entity.BaseEntity;
import com.cn.assistantmember.entity.LoginBean;
import com.cn.assistantmember.listener.RequestCompleteListener;
import com.cn.assistantmember.parser.LoginParser;
import com.cn.assistantmember.util.UrlAddress.Login;

import android.util.Log;


public class LoginTask {
 private String email;
 private String password;
 private RequestCompleteListener< BaseEntity> mListener;
 private final String TAG="LoginTask";
	LoginBean loginBean=null;
	public LoginTask(String email,String password,RequestCompleteListener<BaseEntity> mListener) {
		this.email=email;
		this.password=password;
		this.mListener=mListener;
	}
	public void doLoginTask(){	
	FinalHttp fh = new FinalHttp();	  
	fh.post(Login.LOGIN_URL,getParameter(), new AjaxCallBack<Object>(){
		@Override
		public void onSuccess(Object t) {
			String mReSult=(String)t.toString();
			try {
			loginBean=LoginParser.parserLogin(mReSult);
			Log.i(TAG, loginBean.toString());
			mListener.onRequestCompleteListener(loginBean);
				
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}			
			super.onSuccess(t);
		}
	});
	}
	public AjaxParams getParameter(){
		 AjaxParams params = new AjaxParams(); 
		  params.put(Login.EMAIL,email ); 
		    params.put(Login.PASSWORD, password);  
		 return params;
	}

}
