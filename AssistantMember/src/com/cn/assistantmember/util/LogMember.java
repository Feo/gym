package com.cn.assistantmember.util;

import android.util.Log;

public class LogMember {
	public static final String TAG = "AssistantMember";
	private static final boolean DEBUG = true;
	public static final void Logv(String content) {
		if (DEBUG) {
			Log.v(TAG, content);
		}
	}

	public static final void Logv(String tag, String content) {
		if (DEBUG) {
			Log.v(tag, content);
		}
	}

	public static final void Logi(String content) {
		if (DEBUG)
			Log.i(TAG, content);
	}

	public static final void Logi(String tag, String content) {
		if (DEBUG)
			Log.i(tag, content);
	}
	
	public static final void Loge(String content) {
		Log.e(TAG, content);
	}

	
	public static final void Loge(String tag, String content) {
		Log.e(tag, content);
	}

}
