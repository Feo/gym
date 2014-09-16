package com.cn.assistantmember.task;

import net.tsz.afinal.FinalHttp;
import net.tsz.afinal.http.AjaxCallBack;
import net.tsz.afinal.http.AjaxParams;
import org.json.JSONException;
import android.util.Log;
import com.cn.assistantmember.entity.BaseEntity;
import com.cn.assistantmember.entity.HabitBean;
import com.cn.assistantmember.listener.RequestCompleteListener;
import com.cn.assistantmember.parser.HabitParser;

import com.cn.assistantmember.util.UrlAddress.CreateHabit;
import com.cn.assistantmember.util.UrlAddress.DeleteHabit;
import com.cn.assistantmember.util.UrlAddress.Habit;
import com.cn.assistantmember.util.UrlAddress.UpdateHabit;

public class HabitTask {
	private static final String TAG="CreateHabitTask";
	private String disease_history;
	private String drinking;
	private String drinking_times;
	private String drug;
	private String drug_name;
	private String drug_reason;
	private String self_assessment;
	private String sleep_amount;
	private String sleep_quality;
	private String sleep_time;
	private String smoking;
	private String smoking_times;
	private HabitBean habitBean=null;
	private RequestCompleteListener< BaseEntity> mListener;
	public HabitTask(RequestCompleteListener<BaseEntity> mListener) {
		this.mListener = mListener;	
	}
	public HabitTask( String disease_history,
			String drinking, String drinking_times, String drug,
			String drug_name, String drug_reason, String self_assessment,
			String sleep_amount, String sleep_quality, String sleep_time,
			String smoking, String smoking_times, 
			RequestCompleteListener<BaseEntity> mListener) {
		this.disease_history = disease_history;
		this.drinking = drinking;
		this.drinking_times = drinking_times;
		this.drug = drug;
		this.drug_name = drug_name;
		this.drug_reason = drug_reason;
		this.self_assessment = self_assessment;
		this.sleep_amount = sleep_amount;
		this.sleep_quality = sleep_quality;
		this.sleep_time = sleep_time;
		this.smoking = smoking;
		this.smoking_times = smoking_times;
		this.mListener = mListener;
	}
	/*
	 * 创建用户习惯
	 */
	
	public void doCreateHabitTask(){	
		FinalHttp fh = new FinalHttp();	  
		fh.post(CreateHabit.CREATE_HABIT,getParameter(), new AjaxCallBack<Object>(){
			@Override
			public void onSuccess(Object t) {
				String mReSult=(String)t.toString();
				Log.i(TAG, mReSult);
				try {
				habitBean=HabitParser.parserHabit(mReSult);
				Log.i(TAG, habitBean.toString());
				mListener.onRequestCompleteListener(habitBean);					
				} catch (JSONException e) {
					e.printStackTrace();
				}			
				super.onSuccess(t);
			}
		});
		}
	
	/*
	 * 
	 * 修改用户习惯
	 */
	public void doUpdateHabitTask(){
		FinalHttp fh = new FinalHttp();	  
		fh.post(UpdateHabit.UPDATE_HABIT,getParameter(), new AjaxCallBack<Object>(){
			@Override
			public void onSuccess(Object t) {
				String mReSult=(String)t.toString();
				Log.i(TAG, mReSult);
				try {
				habitBean=HabitParser.parserHabit(mReSult);
				Log.i(TAG, habitBean.toString());
				mListener.onRequestCompleteListener(habitBean);					
				} catch (JSONException e) {
					e.printStackTrace();
				}			
				super.onSuccess(t);
			}
		});
	}
	
	/*
	 * 获得用户习惯
	 */
	
	public void doGetHabitTask(){
		FinalHttp fh = new FinalHttp();	  
		fh.get(Habit.HABIT_URL,new AjaxCallBack<Object>(){
			@Override
			public void onSuccess(Object t) {
				String mReSult=(String)t.toString();
				Log.i(TAG, mReSult);
				try {
				habitBean=HabitParser.parserHabit(mReSult);
				Log.i(TAG, habitBean.toString());
				mListener.onRequestCompleteListener(habitBean);					
				} catch (JSONException e) {
					e.printStackTrace();
				}			
				super.onSuccess(t);
			}
		});
	}
	/*
	 * 删除用户习惯
	 */
	public void doDeleteHabitTask(){
		FinalHttp fh = new FinalHttp();	  
		fh.get(DeleteHabit.DELETE_HABITE_URL,new AjaxCallBack<Object>(){
			@Override
			public void onSuccess(Object t) {
				String mReSult=(String)t.toString();
				Log.i(TAG, mReSult);
				try {
				habitBean=HabitParser.parserHabit(mReSult);
				Log.i(TAG, habitBean.toString());
				mListener.onRequestCompleteListener(habitBean);					
				} catch (JSONException e) {
					e.printStackTrace();
				}			
				super.onSuccess(t);
			}
		});	
	}
	
   public AjaxParams getParameter(){
 			 AjaxParams params = new AjaxParams(); 
			  params.put( CreateHabit.DIEASE,disease_history); 
			  params.put( CreateHabit.DRIKING,drinking); 
			  params.put(CreateHabit.DRIKING_TIMES,drinking_times ); 
			  params.put(CreateHabit.DRUG,drug ); 
			  params.put( CreateHabit.DRUG_NAME,drug_name); 
			  params.put(CreateHabit.DRUG_REASON,drug_reason); 
			  params.put(CreateHabit.SELF_ASSESSMENT,self_assessment ); 
			  params.put(CreateHabit.SLEEP_AMOUNT,sleep_amount); 
			  params.put(CreateHabit.SLEEP_QUALITY,sleep_quality); 
			  params.put(CreateHabit.SLEEP_TIME,sleep_time); 
			  params.put(CreateHabit.SMOKING,smoking ); 
			  params.put(CreateHabit.SMOKING_TIMES,smoking_times); 

			 return params;
		}
}
