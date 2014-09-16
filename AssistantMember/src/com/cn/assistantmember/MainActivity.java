package com.cn.assistantmember;

import net.tsz.afinal.FinalHttp;
import net.tsz.afinal.http.AjaxCallBack;
import net.tsz.afinal.http.AjaxParams;

import org.json.JSONException;

import com.cn.assistantmember.entity.LoginBean;
import com.cn.assistantmember.parser.LoginParser;
import com.cn.assistantmember.task.LoginTask;
import com.cn.assistantmember.util.UrlAddress.Login;
import com.cn.assistantmember.activity.BaseActivity;
import android.os.Bundle;
import android.app.Activity;
import android.util.Log;
import android.view.Menu;

public class MainActivity extends BaseActivity{
	 private String email="member1@example.com";
	 private String password="888888";
	 private final String TAG="MainActivity";

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		doLoginTask();

	
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
	public void doLoginTask( ){	
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
				String mReSult=(String)t.toString();
				try {
				LoginBean loginBean=LoginParser.parserLogin(mReSult);
			  Log.i(TAG,loginBean.toString());
					
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
//			  params.put(Login.EMAIL,email ); 
//			    params.put(Login.PASSWORD, password);  
			 return params;
		}

		@Override
		protected String activityName() {	
			return TAG;
		}

}
