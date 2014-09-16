package com.cn.assistantmember;




import com.cn.assistantmember.util.LogMember;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
/*
 * ����
 *  @author yanguangtao
 */

public abstract class BaseActivity extends Activity {
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
		// onCreateʱ����activity��ջ����
		ActivitiesManager.getInstance().pushActivity(this);
		LogMember.Logi(activityName() + " ��ջ");
	}

	protected void onDestroy() {
		super.onDestroy();
		// onDestoryʱ����ջ����
		ActivitiesManager.getInstance().popActivity(this);
		LogMember.Logi(activityName() + " ��ջ");
	}

	protected abstract String activityName();

	public void onResume() {
		super.onResume();
	
	}

	public void onPause() {
		super.onPause();
	
	}
}
