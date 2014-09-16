package com.cn.assistantmember;

import java.util.Stack;

import android.app.Activity;
import android.util.Log;



public class ActivitiesManager {

	private static final String TAG = "ActivitiesManager";
	// activityջ
	private static Stack<Activity> mActivityStack;
	private static ActivitiesManager mActivitiesManager;

	private ActivitiesManager() {

	}

	public static ActivitiesManager getInstance() {
		if (null == mActivitiesManager) {
			mActivitiesManager = new ActivitiesManager();
			if (null == mActivityStack) {
				mActivityStack = new Stack<Activity>();
			}
		}
		return mActivitiesManager;
	}

	public int stackSize() {
		return mActivityStack.size();
	}

	/**
	 * ��ȡ��ǰactivity
	 * 
	 * @return ��ǰactivity
	 */
	public Activity getCurrentActivity() {
		Activity activity = null;

		try {
			activity = mActivityStack.lastElement();
		} catch (Exception e) {
			return null;
		}

		return activity;
	}

	/**
	 * ��ջ
	 */
	public void popActivity() {
		Activity activity = mActivityStack.lastElement();
		if (null != activity) {
			Log.i(TAG, "popActivity-->" + activity.getClass().getSimpleName());
			activity.finish();
			mActivityStack.remove(activity);
			activity = null;
		}
	}

	/**
	 * ��ջ
	 * 
	 * @param activity
	 */
	public void popActivity(Activity activity) {
		if (null != activity) {
			Log.i(TAG, "popActivity-->" + activity.getClass().getSimpleName());
			activity.finish();
			mActivityStack.remove(activity);
			activity = null;
		}
	}

	/**
	 * activity��ջ
	 * 
	 * @param activity
	 */
	public void pushActivity(Activity activity) {
		mActivityStack.add(activity);
		Log.i(TAG, "pushActivity-->" + activity.getClass().getSimpleName());
	}

	/**
	 * ����activity��ջ
	 */
	public void popAllActivities() {
		while (!mActivityStack.isEmpty()) {
			Activity activity = getCurrentActivity();
			if (null == activity) {
				break;
			}
			popActivity(activity);
		}
	}

	/**
	 * ָ����activity��ջ
	 */
	public void popSpecialActivity(Class<?> cls) {
		for (Activity activity : mActivityStack) {
			if (activity.getClass().equals(cls)) {
				activity.finish();
				mActivityStack.remove(activity);
				activity = null;
			}
		}
	}

	/**
	 * ����Ŀǰջ�е�activity
	 */
	public void peekActivity() {
		for (Activity activity : mActivityStack) {
			if (null == activity) {
				break;
			}
			Log.i(TAG, "peekActivity()-->"
					+ activity.getClass().getSimpleName());
		}
	}

}
