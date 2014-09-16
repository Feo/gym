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
		// onCreate时，对activity入栈操作
		ActivitiesManager.getInstance().pushActivity(this);
		Log.i("AssistantMember",activityName() + " 入栈");
	}

	protected void onDestroy() {
		super.onDestroy();
		// onDestory时，出栈操作
		ActivitiesManager.getInstance().popActivity(this);
		Log.i("AssistantMember",activityName() + " 出栈");
		
	}

	protected abstract String activityName();

	public void onResume() {
		super.onResume();
		
	}

	public void onPause() {
		super.onPause();
	
	}

}
