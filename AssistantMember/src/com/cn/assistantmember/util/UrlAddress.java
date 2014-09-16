package com.cn.assistantmember.util;

public interface UrlAddress {
	
	public static String VERSION="api/v1/";
	public static String URL="http://115.28.233.36/"+VERSION;
	/*
	 * ��¼
	 */
public class Login{
	public static String LOGIN_URL=URL+"members/login";
	public static String EMAIL="[session][phone]";
	public static String PASSWORD="[session][password]";
}
/*
 * ע��
 */
public class Regster{
	public static String REGISTER_URL=URL+"members/register";
	public static String NICK_NAME="[member][nickname]";
	public static String NAME="[member][name]";
	public static String PROVINCE="[member][province]"; //ʡ
	public static String CITY="[member][city]";
	public static String DISTRICT="[member][district]";
	public static String STREET="[member][street]";
	public static String PHONE="[member][phone]";
	public static String EMAIL="[member][email]";
	public static String QQ="[member][qq]";
	public static String WEIXIN="[member][weixin]";
	public static String PASSWORD="[member][password]";
	public static String PASSWORD_CONFIRM="[member][password_confirmation]";
	public static String SPORTS="[member][sports]";
	public static String PROFESSION="profession"; //ְҵ
	public static String AGE="[member][age]";
	public static String GENDER="[member][gender]";//�Ա�
	
}
/*
 * �˳�
 */
public class Logout{
	public static String LOGOUT_URL=URL+"members/logout";
}
/*
 * ���»�Ա��Ϣ
 */
public class Update{
	public static String UPDATE_URL=URL+"members/update";
	public static String NICK_NAME="[member][nickname]";
	public static String NAME="[member][name]";
	public static String PROVINCE="[member][province]"; //ʡ
	public static String CITY="[member][city]";
	public static String DISTRICT="[member][district]";
	public static String STREET="[member][street]";
	public static String PHONE="[member][phone]";
	public static String EMAIL="[member][email]";
	public static String QQ="[member][qq]";
	public static String WEIXIN="[member][weixin]";
	public static String SPORTS="[member][sports]";
	public static String PROFESSION="profession"; //ְҵ
	public static String AGE="[member][age]";
	public static String GENDER="[member][gender]";//�Ա�
}
/*
 * �޸�����
 */
public class ChangePassword{
	public static String CHANGE_PWD_URL=URL+"members/change_pwd";
	public static String PASSWORD="[member][password]";
	public static String PASSWORD_CONFIRM="[member][password_confirmation]"; //ȷ������
}
/*
 * ��ȡָ���û���Ϣ
 */
public class IdInfo{
	public static String ID_INFO_URL=URL+"members/id_info";
	
}
/*��ȡ��ǰ�û���Ϣ
 * 
 */
public class Info{
	public static String INFO_URL=URL+"members/info";
}
/*
 *��ȡָ��������Ϣ
 */
public class CoachInfo{
	public static String COACH_INFO_URL=URL+"members/coach_info";
	public static String ID="[id]";
}
/*
 * 
 * ��ȡ����������Ϣ
 */
public class CurrentCoach{
	public static String CURRENT_COACH_URL=URL+"members/current_coach";
}
/*
 * �����������
 */
public class ApplyCoach{
	public static String APPLY_COACH_URL=URL+"members/apply_coach";
	public static String ID="[id]";
}
/*
 * ȡ����������
 */
public class DeleteCoach{
	public static String DELETE_COACH=URL+"members/delete_coach";
}
/*
 * ���ֽӿ�
 */
public class GradeCoach{
	public static String GRADE_COACH=URL+"members/grade_coach";
	public static String GRADE="[grade]";
}
/*
 * ������֤
 */
public class SendToken{
	public String SEND_TOKEN=URL+"members/send_token";
	public String PHONE="[session][phone]";
}
/*
 * ��֤
 */
public class ActiviteAccount{
	public static String ACTIVITE_ACCOUNT=URL+"members/activate_account";
	public static String phone="[member][phone]";
	public static String token="[member][token]";
}
/*
 * ����û�ϰ���б�
 */
public class Habit{
	public static String HABIT_URL=URL+"memberhabits/:id/info";
}
/*
 * �����û�ϰ��
 */
public class CreateHabit{
	public static String CREATE_HABIT=URL+"memberhabits/create";
	public static String SMOKING="[habit][smoking]";
	public static String SMOKING_TIMES="[habit][smoking_times]";
	public static String DRIKING="[habit][drinking]";
	public static String DRIKING_TIMES="[habit][drinking_times]";
	public static String DRUG="[habit][drug]";
	public static String DRUG_NAME="[habit][drug_name]";
	public static String DRUG_REASON="[habit][drug_reason]";
	public static String DIEASE="[habit][disease_history]";
	public static String SLEEP_AMOUNT="[habit][sleep_amount]";
	public static String SLEEP_TIME="[habit][sleep_time]";
	public static String SLEEP_QUALITY="[habit][sleep_quality]";
	public static String SELF_ASSESSMENT="[habit][self_assessment]";
}
/*
 * �޸��û�ϰ��
 */
public class UpdateHabit{
	public static String UPDATE_HABIT=URL+"memberhabits/update";
	public static String SMOKING="[habit][smoking]";
	public static String SMOKING_TIMES="[habit][smoking_times]";
	public static String DRIKING="[habit][drinking]";
	public static String DRIKING_TIMES="[habit][drinking_times]";
	public static String DRUG="[habit][drug]";
	public static String DRUG_NAME="[habit][drug_name]";
	public static String DRUG_REASON="[habit][drug_reason]";
	public static String DIEASE="[habit][disease_history]";
	public static String SLEEP_AMOUNT="[habit][sleep_amount]";
	public static String SLEEP_TIME="[habit][sleep_time]";
	public static String SLEEP_QUALITY="[habit][sleep_quality]";
	public static String SELF_ASSESSMENT="[habit][self_assessment]";
}
/*
 * ɾ���û�ϰ��
 */
public class DeleteHabit{
	public static String DELETE_HABITE_URL=URL+"memberhabits/delete";
}
}
