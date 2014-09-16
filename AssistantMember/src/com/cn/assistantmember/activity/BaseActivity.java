package com.cn.assistantmember.activity;



import com.cn.assistantmember.ActivitiesManager;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.util.Log;

public abstract class BaseActivity extends Activity{
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
		// onCreateʱ����activity��ջ����
		ActivitiesManager.getInstance().pushActivity(this);
		Log.i("AssistantMember",activityName() + " ��ջ");
	}

	protected void onDestroy() {
		super.onDestroy();
		// onDestoryʱ����ջ����
		ActivitiesManager.getInstance().popActivity(this);
		Log.i("AssistantMember",activityName() + " ��ջ");
		
	}

	protected abstract String activityName();

	public void onResume() {
		super.onResume();
		
	}

	public void onPause() {
		super.onPause();
	
	}

}
