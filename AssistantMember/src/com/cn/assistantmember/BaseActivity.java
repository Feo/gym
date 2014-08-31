package com.cn.assistantmember;




import com.cn.assistantmember.util.LogMember;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
/*
 * 基类
 *  @author yanguangtao
 */

public abstract class BaseActivity extends Activity {
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
		// onCreate时，对activity入栈操作
		ActivitiesManager.getInstance().pushActivity(this);
		LogMember.Logi(activityName() + " 入栈");
	}

	protected void onDestroy() {
		super.onDestroy();
		// onDestory时，出栈操作
		ActivitiesManager.getInstance().popActivity(this);
		LogMember.Logi(activityName() + " 出栈");
	}

	protected abstract String activityName();

	public void onResume() {
		super.onResume();
	
	}

	public void onPause() {
		super.onPause();
	
	}
}
