package com.cn.assistantmember.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

import org.apache.commons.codec.binary.Base64;


import android.content.SharedPreferences;
import android.text.TextUtils;


/**
 * º”√‹¥Ê¥¢
 * @author yanguangtao
 *
 */
public class StoreUtils {

	public static boolean storeObject(SharedPreferences prefs, String name, Object obj) {
		try {
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			ObjectOutputStream oos = new ObjectOutputStream(baos);
			oos.writeObject(obj);
			String productBase64 = new String(Base64.encodeBase64(baos.toByteArray()));
			SharedPreferences.Editor editor = prefs.edit();
			editor.putString(name, productBase64);
			editor.commit();
			oos.close();
			return true;
		} catch (IOException e) {
			e.printStackTrace();
			return false;
		}
	}

	public static Object getObject(SharedPreferences prefs, String name) {
		Object obj = null;
		byte[] base64Bytes;
		ByteArrayInputStream bais;
		try {
			String productBase64 = prefs.getString(name, "");
			
			if (null == productBase64 || TextUtils.isEmpty(productBase64.trim())) {
				return null;
			}
			
			base64Bytes = Base64.decodeBase64(productBase64.getBytes());
			bais = new ByteArrayInputStream(base64Bytes);
			ObjectInputStream ois = new ObjectInputStream(bais);
			obj = ois.readObject();
			ois.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return obj;
	}

}